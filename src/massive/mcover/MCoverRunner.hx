package massive.mcover;

import massive.mcover.client.TraceClient;
import massive.mcover.CoverageClient;
import massive.mcover.CodeBlock;

import massive.mcover.util.Timer;

interface MCoverRunner
{
	/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(get_completeHandler, set_completeHandler):Float -> Void;
	
	var data(default, null):CoverageData;

	function report():Void;

	/**
	 * Add a coverage clients to interpret coverage results.
	 * 
	 * @param client  client to interpret coverage results 
	 * @see massive.mcover.CoverageClient
	 * @see massive.mcover.client.PrintClient
	 */
	function addClient(client:CoverageClient):Void;
	function removeClient(client:CoverageClient):Void;
	function getClients():Array<CoverageClient>;

	/**
	* Completely resets all results, clears all clients/blocks and restarts internal timers.
	**/
	function reset():Void;

	/**
	* Removes timers and contents
	*/
	function destroy():Void;
}


class MCoverRunnerImpc implements MCoverRunner
{
	/**
	 * Handler called when all clients 
	 * have completed processing the results.
	 */
	public var completionHandler(get_completeHandler, set_completeHandler):Float -> Void;
	function get_completeHandler():Float -> Void 
	{
		return completionHandler;
	}
	function set_completeHandler(value:Float -> Void):Float -> Void
	{
		return completionHandler = value;
	}

	public var data(default, null):CoverageData;

	var initialized:Bool;
	var clients:Array<CoverageClient>;
	var clientCompleteCount:Int;
	var timer:Timer;

	/**
	 * Class constructor.
	 */
	public function new()
	{
		clients = [];
		reset();
	}

	/**
	 * Initializes timer to handle incoming logs on a set interval.
	 * This is to prevent logs being parsed before instance is initialized
	 * (edge case usually, but always occurs when running against MCover!!)
	 */
	public function reset()
	{
		initialized = false;
		if(timer != null) timer.stop();
		timer = new Timer(10);
		timer.run = tick;
	}

	public function report()
	{
		if(timer != null)
		{
			timer.stop();
			timer = null;
		}
		tick();//make sure to capture any pending logs

		generateReport();
	}

	public function addClient(client:CoverageClient)
	{
		for(c in clients)
		{
			if(c == client) return;
		}

		client.completionHandler = clientCompletionHandler;
		clients.push(client);
	}

	public function removeClient(client:CoverageClient)
	{
		client.completionHandler = null;
		for(i in clients.length...0)
		{
			var c = clients[i];
			if(c ==client) clients.splice(i, 1);
		}
	}

	public function getClients():Array<CoverageClient>
	{
		return clients.concat([]);
	}

	public function destroy()
	{
		initialized = false;
		if(timer != null) timer.stop();
		for(c in clients)
		{
			c.completionHandler = null;
		}
	}

	///////////////////////////////////

	@IgnoreCover
	function tick()
	{
		if(!initialized)
		{
			init();
		}
		
		var tempLogs:Array<Int> = [];
		#if neko
			var value = MCover.logQueue.pop(false);
			while(value != null)
			{
				tempLogs.push(value);
				value = MCover.logQueue.pop(false);
			}
		#else
			tempLogs = MCover.logQueue.concat([]);
			MCover.logQueue = [];
		#end

		for(value in tempLogs)
		{
			log(value);
		}
	}

	function init()
	{
		initialized = true;
		clients = [];
		loadCoverageData();		
	}

	/**
	 * Log an individual code block being executed within the code base.
	 * 
	 * @param	id		a block identifier
	 * @see mcover.CodeBlock
	 */
	function log(id:Int)
	{		
		//trace(value);
		if(!data.blocks.exists(id)) throw "Unexpected block " + id;
		var block = data.blocks.get(id);

		if(!block.hasCount())
		{
			//this is the first time this block has been called
			data.count += 1;
			data.packages.get(block.packageName).count += 1;
			data.files.get(block.file).count += 1;
			data.classes.get(block.qualifiedClassName).count += 1;
		}
		
		block.count += 1;

		for (client in clients)
		{	
			client.log(block);
		}
	}

	function loadCoverageData()
	{
		var serializedData:String = haxe.Resource.getString(MCover.RESOURCE_DATA);

		if(serializedData == null) throw "No generated coverage data found in haxe Resource '" + MCover.RESOURCE_DATA  + "'";

		data = haxe.Unserializer.run(serializedData);
	}

	function generateReport()
	{
		reportToClients();
	}

	function reportToClients()
	{
		clientCompleteCount = 0;

		if(clients.length == 0)
		{
			var client = new TraceClient();
			client.completionHandler = clientCompletionHandler;
			clients.push(client);
		}
			
		for (client in clients)
		{	
			client.report(data);
		}
	}
	
	function clientCompletionHandler(client:CoverageClient):Void
	{
		if (++clientCompleteCount == clients.length)
		{
			if (completionHandler != null)
			{
				var percent:Float = data.percent;
				var handler:Dynamic = completionHandler;
				Timer.delay(function() { handler(percent); }, 1);
			}
		}
	}
}