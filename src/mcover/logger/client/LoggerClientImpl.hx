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

package mcover.logger.client;

#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<T> = Hash<T>
#end


import mcover.logger.data.Log;
import mcover.logger.data.LogRecording;
import mcover.logger.client.LoggerClient;
import mcover.util.NumberUtil;

@IgnoreLogging
@IgnoreCover
class LoggerClientImpl implements LoggerClient
{
	/**
	Handler which if present, should be called when the client has completed its processing of the results.
	 */
	public var completionHandler(default, default):LoggerClient -> Void;

	/**
	String representation of report output;
	*/
	public var output(default, null):String;

	public function new()
	{
		output = "";
	}

	/**
	Generates report output for the current logs
	
	@param logs 		an array of captured logs
	@param recording 	additional metadata such as start/end time
	*/
	public function report(logs:Array<Log>, recording:LogRecording):Void
	{
		var buf = new StringBuf();

		reportFull(buf, logs, recording);
		
		reportFrequency(buf, logs, recording);
		reportSlowest(buf, logs, recording);
		
		reportStats(buf, logs, recording);

		output = buf.toString();	

		trace(output);

		if(completionHandler != null) completionHandler(this);
	}

	////////////////////////


	function reportStats(buf:StringBuf, logs:Array<Log>, recording:LogRecording)
	{
		buf.add("\n\n--------");
		buf.add("\nStats:");
		
		buf.add("\n    Total logs: " + logs.length);
		buf.add("\n    Max depth: " + recording.maxDepth);
		buf.add("\n--------\n");
	}

	function reportFrequency(buf:StringBuf, logs:Array<Log>, recording:LogRecording)
	{
		buf.add("\n\nHighest Frequency:\n");

		var map:StringMap<LogCount> = new StringMap();

		for(log in logs)
		{

			var logCount:LogCount;
			if(map.exists(log.name)) logCount = map.get(log.name);
			else logCount = {name:log.name, count:0};
			
			logCount.count ++;
			map.set(log.name, logCount);
		}

		var a = Lambda.array(map);
		a.sort(sortOnCount);

		var count = 0;
		for(logCount in a)
		{
			buf.add("\n   " + logCount.count + " | "  + logCount.name);
			count ++;

			if(count > 10 ) break;
		}


	}

	function sortOnCount(a:LogCount, b:LogCount):Int
	{
		return Math.round(-a.count+b.count);
	}


	function reportSlowest(buf:StringBuf, logs:Array<Log>, recording:LogRecording)
	{
		buf.add("\n\nLongest Execution Times:\n");

		var a = logs.concat([]);

		a.sort(sortOnExecution);
		
		var count = 0;
		for(log in a)
		{
			buf.add("\n   " + NumberUtil.round(log.internalDuration) + " | "  + log.name);
			count ++;

			if(count > 10 || NumberUtil.round(log.internalDuration) == 0 ) break;
		}

	}

	function sortOnExecution(a:Log, b:Log):Int
	{
		return Math.round(-a.internalDuration*10000 + b.internalDuration*10000);
	}


	function reportFull(buf:StringBuf, logs:Array<Log>, recording:LogRecording)
	{
		buf.add("\n\nFull log:\n");
		var count = 0;
		var padding = "                                                                         ";

		for(log in logs)
		{
			count ++;
			var time = formatTime(log.entryTime - recording.startTime);
			var char = log.skipped ? "!" : ">";
			buf.add("\n    " + time + "| " + padding.substr(0, log.depth) + char + " " + log.toString());

			if(count > 200)
			{
				break;
			}
		}
		return buf.toString();	
	}

	function formatTime(value:Float, ?decimalCount:Int=4, ?length:Int = 8, ?char:String=" "):String
	{
		value = NumberUtil.round(value, decimalCount);
		return StringTools.rpad(Std.string(value), char, length);
	}
}

typedef LogCount = 
{
	name:String,
	count:Int
}