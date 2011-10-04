package massive.mcover;

import massive.mcover.client.TraceClient;
import massive.mcover.CoverageClient;
import massive.mcover.util.Timer;
import massive.mcover.data.AllClasses;

import massive.mcover.data.CoverageResult;
import massive.mcover.MCover;

interface MCoverRunner
{
	/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(get_completeHandler, set_completeHandler):Float -> Void;
	
	var allClasses(default, null):AllClasses;

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

	public var allClasses(default, null):AllClasses;

	var initialized:Bool;
	var clients:Array<CoverageClient>;
	var clientCompleteCount:Int;
	var timer:Timer;

	var coverageResult:CoverageResult;

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
		
		var tempStatements:Array<Int> = [];
		#if neko
			var value = MCover.statementQueue.pop(false);
			while(value != null)
			{
				tempStatements.push(value);
				value = MCover.statementQueue.pop(false);
			}
		#else
			tempStatements = MCover.statementQueue.concat([]);
			MCover.statementQueue = [];
		#end

		for(value in tempStatements)
		{
			logStatement(value);
		}

		var tempBranches:Array<BranchResult> = new Array();

		#if neko
			var value = MCover.branchQueue.pop(false);
			while(value != null)
			{
				tempBranches.push(value);
				value = MCover.branchQueue.pop(false);
			}
		#else
			tempBranches = MCover.branchQueue.concat([]);
			MCover.branchQueue = [];
		#end

		for(value in tempBranches)
		{
			logBranch(value);
		}
	}

	function init()
	{
		initialized = true;
		clients = [];
		loadGeneratedCoverageData();		
	}

	/**
	 * Log an individual code block being executed within the code base.
	 * 
	 * @param	id		a block identifier
	 * @see mcover.CodeBlock
	 */
	function logStatement(id:Int)
	{		
		if(!allClasses.statements.exists(id)) throw "Unexpected statement " + id;

		var lookup:Array<Int> = allClasses.statements.get(id).concat([]);
		var statement = allClasses.lookupStatement(lookup);

		statement.count += 1;

		for (client in clients)
		{	
			client.logStatement(statement);
		}
	}

	function logBranch(result:BranchResult)
	{
		if(!allClasses.branches.exists(result.id)) throw "Unexpected branch " + result.id;

		var lookup:Array<Int> = allClasses.branches.get(result.id).concat([]);
		var branch = allClasses.lookupBranch(lookup);

		if(result.value)
		{
			branch.trueCount += 1;
		}
		else
		{
			branch.falseCount += 1;
		}
		
		for (client in clients)
		{	
			client.logBranch(branch);
		}
	}

	function loadGeneratedCoverageData()
	{
		var serializedData:String = haxe.Resource.getString(MCover.RESOURCE_DATA);

		if(serializedData == null) throw "No generated coverage data found in haxe Resource '" + MCover.RESOURCE_DATA  + "'";

		try
		{
			allClasses = haxe.Unserializer.run(serializedData);
		}
		catch(e:Dynamic)
		{
			trace("Unable to unserialize coverage data");
			trace("   ERROR: " + e);
			trace(haxe.Stack.toString(haxe.Stack.exceptionStack()));
		}
	}

	function generateReport()
	{
		allClasses.getResults(true);
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
			client.report(allClasses);
		}
	}
	
	function clientCompletionHandler(client:CoverageClient):Void
	{
		if (++clientCompleteCount == clients.length)
		{
			if (completionHandler != null)
			{
				var percent:Float = allClasses.getPercentage();
				var handler:Dynamic = completionHandler;
				Timer.delay(function() { handler(percent); }, 1);
			}
		}
	}
}