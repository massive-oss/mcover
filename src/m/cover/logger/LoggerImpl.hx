package m.cover.logger;

import haxe.PosInfos;
import m.cover.logger.data.Log;
import m.cover.logger.data.LogRecording;
import m.cover.logger.client.LogClient;
import m.cover.logger.client.LogClientImpl;

class LoggerImpl implements Logger
{
	static public var MAX_STACK_DEPTH_LIMIT:Int = 26;

	#if neko
		static public var mutex:neko.vm.Mutex = new neko.vm.Mutex();
	#end

	/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	public var completionHandler(default, default):Logger -> Void;

	public var isRecording(default, null):Bool;

	var count:Int;
	var depth:Int;
	var maxDepth:Int;
	var logs:Array<Log>;

	var stack:Array<Log>;
	var logsById:IntHash<Log>;
	var recording:LogRecording;

	public var clients(default, null):Array<LogClient>;
	var clientCompleteCount:Int;

	public var defaultClient:LogClient;

	public function new()
	{	
		defaultClient = new LogClientImpl();
		clients = [];
		clientCompleteCount = 0;
		reset();
	}

	public function reset()
	{
		count = 0;
		logs = [];
		stack = [];
		logsById = new IntHash();
		depth = 0;
		maxDepth = 0;

		stackTime = 0;
	}



	/**
	* Logs function entry
	* @see Logger.logEntry
	**/
	public function logEntry(?isInlineFunction:Bool=false, ?pos:PosInfos):Int
	{
		if(!isRecording) return -1;

		#if neko mutex.acquire(); #end

		
		var t = Utils.stamp();
		var log = new Log(count ++);

		log.enter(pos, t, depth++);
		
		log.inlined = isInlineFunction;	

		logsById.set(log.id, log);
		
		logs.push(log);

		if(stack.length > 0)
		{
			stack[stack.length-1].children.push(log);
		}

		stack.push(log);

		if(depth > maxDepth) maxDepth = depth;

		#if neko mutex.release(); #end

		return log.id;
	}

	var stackTime:Float;

	/**
	* Logs function exit
	* @see Logger.logExit
	**/
	public function logExit(entryId:Int, ?pos:PosInfos):Void
	{
		if(!isRecording) return;

		#if neko mutex.acquire(); #end
		
		if(!logsById.exists(entryId))
		{
			#if neko mutex.release(); #end
			throw "Cannot find matching entry log. " + [entryId, pos];
		}

		var entryLog = logsById.get(entryId);
		var log:Log = stack.pop();
		var t = Utils.stamp();

		//update any logs that were skipped due to a throw
		while(log != null && log != entryLog)
		{
			log.exit(null, t);
			depth --;
			//#if neko neko.Lib.println("skipping " + log.toString()); #end
			log = stack.pop();
		}
		
		depth --;

		entryLog.exit(pos, t);
		stackTime = log.totalDuration;

		#if neko mutex.release(); #end
	}

	

	public function startRecording():Void
	{
		isRecording = true;
		reset();
		recording = new LogRecording();
	}

	
	public function stopRecording():Void
	{
		if(!isRecording) throw new LogException("No recording active.");

		isRecording = false;
		
		updateRecording();

	}

	public function getRecording():LogRecording
	{
		if(isRecording)
		{
			//keep on recording, but update current values
			updateRecording();
		}
		return recording;
	}

	/**
	* updates values in current recording.
	* called when either stopRecording or getCurrentRecording is called
	*/
	function updateRecording()
	{
		if(recording == null) return;

		recording.maxDepth = maxDepth;
		recording.endTime = Utils.stamp();
		recording.duration = recording.endTime -recording.startTime;
	}

	public function report(?recording:LogRecording=null):Void
	{
		#if neko mutex.acquire(); #end

		if(recording ==  null) recording = getRecording();

		if(recording == null) throw new LogException("Cannot report on empty log.\nYour should probably make sure to call startRecording() sometime before calling report()");

		clientCompleteCount = 0;

		if(clients.length == 0 && defaultClient != null)
		{
			defaultClient.completionHandler = clientCompletedHandler;
			defaultClient.report(logs, recording);
		}
		else
		{
			for(client in clients)
			{
				client.completionHandler = clientCompletedHandler;
				client.report(logs, recording);
			}
		}
		#if neko mutex.release(); #end
	}

	function clientCompletedHandler(client:LogClient)
	{
		clientCompleteCount ++;

		if(clientCompleteCount >= clients.length)
		{
			if(completionHandler != null) completionHandler(this);
		}
	}

	/**
	Adds a client to report on logs
	
	@param client 	the log client to add
	*/
	public function addClient(client:LogClient):Void
	{
		clients.remove(client);
		clients.push(client);
	}

	/**
	Removes a client from reporting on logs
	
	@param client 	the log client to remove
	*/
	public function removeClient(client:LogClient):Void
	{
		clients.remove(client);
	}


}