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

import massive.mcover.MCoverException;

interface MCoverRunner
{
	/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(default, default):Float -> Void;
	
	var allClasses(default, null):AllClasses;

	var cover(default, null):MCover;


	function initialize(cover:MCover, allClasses:AllClasses):Void;

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
	* Removes timers and contents
	*/
	function destroy():Void;
}


class MCoverRunnerImpl implements MCoverRunner
{
	static var TICK_INTERVAL_MS:Int = 1;
	static var MAX_COUNT_PER_TICK:Int = 200;
	/**
	 * Handler called when all clients 
	 * have completed processing the results.
	 */
	public var completionHandler(default, default):Float -> Void;

	public var allClasses(default, null):AllClasses;
	public var cover(default, null):MCover;

	public var maxLogsToParsePerTick(default, default):Int;

	var resourceName:String;
	var clients:Array<CoverageClient>;
	var clientCompleteCount:Int;
	var timer:Timer;

	var coverageResult:CoverageResult;
	var startTime:Float;
	var reportPending:Bool;


	#if neko
	static var mutex:neko.vm.Mutex;
	#end

	/**
	 * Class constructor.
	 */
	public function new()
	{
		startTime = Date.now().getTime();
		clients = [];
		reportPending = false;
		maxLogsToParsePerTick = MAX_COUNT_PER_TICK;

		#if neko
		mutex = new neko.vm.Mutex();
		#end
	}

	public function initialize(cover:MCover, allClasses:AllClasses)
	{
		this.cover = cover;
		this.allClasses = allClasses;
		resetTimer();
	}

	/**
	 * Initializes timer to handle incoming logs on a set interval.
	 * This is to prevent logs being parsed before instance is initialized
	 * (edge case usually, but always occurs when running against MCover!!)
	 */
	function resetTimer()
	{
		if(timer != null) timer.stop();
		timer = new Timer(TICK_INTERVAL_MS);
		timer.run = tick;
	}

	public function report()
	{
		reportPending = true;
		if(timer == null) resetTimer();
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
		clients.remove(client);
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

		clients = [];
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

	/**
	* For testing purposes only
	* forceUpdate should not need to be called directly by users.
	*/
	public function forceUpdate()
	{
		update();
	}

	@IgnoreCover
	function update()
	{	
		var statements:Array<Int> = [];

		if(cover == null) throw new MCoverException("Runner has not been initialized");

		var count = 0;
		var value = cover.getNextStatementFromQueue();
	
		while(value != null && count < maxLogsToParsePerTick)
		{
			count ++;
			statements.push(value);
			if(count < maxLogsToParsePerTick)
			{
				value = cover.getNextStatementFromQueue();
			}
			
		}

		for(s in statements)
		{
			logStatement(s);
		}

		if(count >= maxLogsToParsePerTick-1) return;

		var branches:Array<BranchResult> = [];
		var value = cover.getNextBranchResultFromQueue();
		while(value != null && count < maxLogsToParsePerTick)
		{
			count ++;
			branches.push(value);
			if(count < maxLogsToParsePerTick)
			{
				value = cover.getNextBranchResultFromQueue();
			}
		}

		for(b in branches)
		{
			logBranch(b);
		}

		if(count >= maxLogsToParsePerTick) return;


		if(reportPending)
		{
			if(timer != null)
			{
				timer.stop();
				timer = null;
			}
		
			generateReport();
			
			reportPending = false;
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
		var statement = allClasses.getStatementById(id);

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
		var branch = allClasses.getBranchById(id);
		
		if(log.value)
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

	function generateReport()
	{
		allClasses.getResults(true);

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

		#if MCOVER_DEBUG
		generateInternalStats();
		#end
	}


	function clientCompletionHandler(client:CoverageClient):Void
	{
		if (++clientCompleteCount == clients.length)
		{
			if (completionHandler != null)
			{
				executeCompletionHandler();
				//Timer.delay(executeCompletionHandler, 1);
			}
		}
	}

	function executeCompletionHandler()
	{
		var percent:Float = allClasses.getPercentage();
		completionHandler(percent);
	}

	/////////////// DEBUGGING METHODS  ////////////


	@IgnoreCover
	function debug(value:Dynamic)
	{
		#if MCOVER_DEBUG
		trace(Std.string(value) + " time: " + Timer.stamp());
		#end
	}


}