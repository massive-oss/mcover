/****
* Copyright 2013 Massive Interactive. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

package mcover.logger;

import haxe.PosInfos;
import mcover.util.Timer;
import mcover.logger.data.Log;
import mcover.logger.data.LogRecording;
import mcover.logger.client.LoggerClient;
import mcover.logger.client.LoggerClientImpl;


#if neko
import neko.vm.Deque;
import neko.vm.Mutex;
#elseif cpp
import cpp.vm.Deque;
import cpp.vm.Mutex;
#end

#if haxe3
import haxe.ds.IntMap;
#else
private typedef IntMap<T> = IntHash<T>
#end

@IgnoreLogging
@IgnoreCover
class LoggerImpl implements Logger
{
	static public var MAX_STACK_DEPTH_LIMIT:Int = 26;

	#if (neko||cpp)
		static public var mutex:Mutex = new Mutex();
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
	var logsById:IntMap<Log>;
	var recording:LogRecording;

	public var clients(default, null):Array<LoggerClient>;
	var clientCompleteCount:Int;

	public var defaultClient:LoggerClient;


	public function new()
	{	
		defaultClient = new LoggerClientImpl();
		clients = [];
		clientCompleteCount = 0;
		reset();
	}

	public function reset()
	{
		count = 0;
		logs = [];
		stack = [];
		logsById = new IntMap();
		depth = 0;
		maxDepth = 0;
	}



	/**
	* Logs function entry
	* @see Logger.logEntry
	**/
	public function logEntry(?isInlineFunction:Bool=false, ?pos:PosInfos):Int
	{
		if(!isRecording) return -1;

		#if (neko||cpp) mutex.acquire(); #end

		var t = Timer.stamp();
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

		#if (neko||cpp) mutex.release(); #end

		return log.id;
	}


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
			#if (neko||cpp) mutex.release(); #end
			trace("WARNING: Cannot find matching entry log. " + entryId + ", " + pos);
			return;
		}

		try
		{
			var t = Timer.stamp();

			var entryLog = logsById.get(entryId);
			var log:Log = stack.pop();

			if(log != entryLog)
			{
				//update any logs that were skipped due to a throw
				while(log != null && log != entryLog)
				{
					log.exit(null, t);
					depth --;
					log = stack.pop();
				}
			}

			
			depth --;

			entryLog.exit(pos, t);

			if(depth < 0) depth = 0;
		}
		catch(e:Dynamic)
		{
			trace(e);
			#if (neko||cpp) mutex.release(); #end
		}
		

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
		if(!isRecording) throw new LoggerException("No recording active.");

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
		recording.endTime = Timer.stamp();
		recording.duration = recording.endTime -recording.startTime;
	}

	public function report(?recording:LogRecording=null):Void
	{
		#if (neko||cpp) mutex.acquire(); #end

		if(recording ==  null) recording = getRecording();

		if(recording == null) throw new LoggerException("Cannot report on empty log.\nYour should probably make sure to call startRecording() sometime before calling report()");

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
		#if (neko||cpp) mutex.release(); #end
	}

	function clientCompletedHandler(client:LoggerClient)
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
	public function addClient(client:LoggerClient):Void
	{
		clients.remove(client);
		clients.push(client);
	}

	/**
	Removes a client from reporting on logs
	
	@param client 	the log client to remove
	*/
	public function removeClient(client:LoggerClient):Void
	{
		clients.remove(client);
	}


}