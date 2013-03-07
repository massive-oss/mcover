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

package mcover.logger.data;
import haxe.PosInfos;
import mcover.util.NumberUtil;
@IgnoreLogging
class Log
{
	public var id:Int;
	public var name(get_name, null):String;

	public var children:Array<Log>;

	//call stack depth
	public var depth:Int;

	public var entryPos:PosInfos;
	public var exitPos:PosInfos;
	
	//timestamp
	public var entryTime:Float;
	public var exitTime(default, set_exitTime):Float;

	/**
	Total time method was running (exitTime-entryTime)
	*/
	public var totalDuration:Float;

	/**
	Time taken directly (not inclusive of other methods)
	*/
	public var internalDuration:Float;

	/**
	Indicates that log didn't exit properly (ie didn't catch an exception from a nested function)
	*/
	public var skipped:Bool;
	
	/**
	Indicates log refers to an inline function (not a class method)
	*/
	public var inlined:Bool;

	public function new(id:Int)
	{
		this.id = id;
		inlined = false;
		skipped = false;
		totalDuration = 0;
		internalDuration = 0;
		children = [];
	}

	public function toString():String
	{
		return name + " (" + NumberUtil.round(totalDuration) + ", " + NumberUtil.round(internalDuration) + ")";
	}

	public function enter(pos:PosInfos, time:Float, depth:Int)
	{
		entryPos = pos;
		entryTime = time;
		this.depth = depth;
	}

	public function exit(pos:PosInfos, time:Float)
	{
		exitPos = pos;
		exitTime = time;
		totalDuration = exitTime-entryTime;
		
		skipped = pos == null;


		internalDuration = totalDuration;

		for(child in children)
		{
			internalDuration -= child.totalDuration;
		}
	}


	function get_name():String
	{
		if(name == null)
		{
			if(entryPos == null) return null;

			name = entryPos.className + "/" + entryPos.methodName;
			if(inlined) name += "/function_" + entryPos.lineNumber;
		}
		return name;
	}

	function set_exitTime(value:Float):Float
	{
		exitTime = value;
		
		return value;
	}
}
