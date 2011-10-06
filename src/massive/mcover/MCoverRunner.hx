package massive.mcover;

import massive.mcover.client.TraceClient;
import massive.mcover.CoverageClient;
import massive.mcover.util.Timer;
import massive.mcover.data.AllClasses;

import massive.mcover.data.CoverageResult;

import massive.mcover.data.Package;
import massive.mcover.data.File;
import massive.mcover.data.Clazz;
import massive.mcover.data.Method;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
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

	var clients:Array<CoverageClient>;
	var clientCompleteCount:Int;
	var timer:Timer;

	var coverageResult:CoverageResult;
	var startTime:Float;

	#if neko
	static var mutex:neko.vm.Mutex;
	#end

	/**
	 * Class constructor.
	 */
	public function new()
	{
		#if neko
		mutex = new neko.vm.Mutex();
		#end

		loadGeneratedCoverageData();
		startTime = Date.now().getTime();
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
		
		#if neko mutex.acquire(); #end

		update();//make sure to capture any pending logs
		#if neko mutex.release(); #end

		debug("gen report ");
		generateReport();
		debug("gen report complete ");
		#if MCOVER_DEBUG
		generateInternalStats();
		#end
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
		if(timer != null)
		{
			timer.stop();
			timer = null;
		}
		for(c in clients)
		{
			c.completionHandler = null;
		}
	}

	///////////////////////////////////

	@IgnoreCover
	function tick()
	{
		#if neko
		if(mutex.tryAcquire() == false) return;
		#end
		update();
		#if neko mutex.release(); #end
	}

	@IgnoreCover
	function update()
	{	
		var cover = MCover.getInstance();
		var statements:Array<Int> = [];

		var value = cover.getNextStatementFromQueue();
	
		while(!Math.isNaN(value) #if !flash && value != null #end)
		{
			statements.push(value);
			value = cover.getNextStatementFromQueue();
		}
		for(s in statements)
		{
			logStatement(s);
		}
	
		var branches:Array<BranchResult> = [];
		var value = cover.getNextBranchResultFromQueue();
		while(value != null)
		{
			branches.push(value);
			value = cover.getNextBranchResultFromQueue();
		}
		for(b in branches)
		{
			logBranch(b);
		}
	}

	/**
	 * Log an individual code block being executed within the code base.
	 * 
	 * @param	id		a block identifier
	 * @see mcover.data.Statement
	 */
	function logStatement(id:Int)
	{		
		if(allClasses == null) throw "allClasses is null";
		var statement = allClasses.getStatementById(id);

		if(statement == null) throw "Null statement for " + id;
		
		statement.count += 1;

		for (client in clients)
		{	
			client.logStatement(statement);
		}
	}

	/**
	* @param id	id of branch
	* @param value - string representation of true/false branch executions (e.g. 1,ttfftf)
	*/
	function logBranch(log:BranchResult)
	{
		var id = log.id;
		var value = log.result;
		if(allClasses == null) throw "allClasses is null";
		var branch = allClasses.getBranchById(id);

		if(branch == null) throw "Null branch for " + id;
		
		if(value.charAt(0) == "1") branch.trueCount += 1;
		if(value.charAt(1) == "1") branch.falseCount += 1;
		
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
			trace(haxe.Stack.toString(haxe.Stack.callStack()));
			throw(e);
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
				var handler:Float -> Void = completionHandler;

				//handler(percent);
				Timer.delay(function() {handler(percent); }, 200);
			}
		}
	}

	/////////////// DEBUGGING METHODS  ////////////

	/**
	* Outputs all branch and statement logs sorted by highest frequency.
	* For branches reports also totals for true/false  
	*/
	function generateInternalStats()
	{
		var output:String = "";

		var cover = MCover.getInstance();

		var statements:IntHash<Int> = cover.getCopyOfStatements();
		var s:Array<{statement:Statement, value:Int}> = [];
		for(key in statements.keys())
		{
			s.push({statement:allClasses.getStatementById(key), value:statements.get(key)});
		}
		s.sort(function(a, b){return -a.value+b.value;});

		output += "STATEMENTS ORDERED BY EXECUTION COUNT " + getTimer();
		
		output += "\n";
		for(item in s)
		{
			output += "\n    ";
			output += StringTools.rpad(Std.string(item.value), " ", 10);
			output += item.statement.toString();
		}

		output += "\n\n";

		var branches:IntHash<BranchResult> = cover.getCopyOfBranches();
		var b:Array<{branch:Branch, value:BranchResult}> = [];
		for(key in branches.keys())
		{
			b.push({branch:allClasses.getBranchById(key), value: branches.get(key)});
		}
		b.sort(function(a, b){return -a.value.total+b.value.total;});

		output += "BRANCHES ORDERED BY EXECUTION COUNT " + getTimer();
		
		output += "\n";
		
		output +="\n    ";
		output += StringTools.rpad("TOTAL", " ", 10);
		output += StringTools.rpad("TRUE", " ", 10);
		output += StringTools.rpad("FALSE", " ", 10);
		
		output += "\n";

		for(item in b)
		{
			output +="\n    ";
			output += StringTools.rpad(Std.string(item.value.total), " ", 10);
			output += StringTools.rpad(Std.string(item.value.trueCount), " ", 10);
			output += StringTools.rpad(Std.string(item.value.falseCount), " ", 10);
			output += item.branch.toString();
		}
		output += "\n\n";

		trace(output);
	}

	@IgnoreCover
	function debug(value:Dynamic)
	{
		#if MCOVER_DEBUG
		trace(Std.string(value) + " time: " + getTimer());
		#end
	}

	@IgnoreCover
	function getTimer():Float
	{
		return Date.now().getTime()-startTime;
	}

}