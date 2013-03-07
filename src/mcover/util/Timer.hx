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

/*
 * Copyright (c) 2005, The haXe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
package mcover.util;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

#if haxe3
import haxe.CallStack;
#else
import haxe.Stack;
private typedef CallStack = haxe.Stack;
#end

@IgnoreCover
@IgnoreLogging
@:expose('mcover.util.Timer')
class Timer 
{
	public var run:Void -> Void;
	
	
	#if php

	#else

		var id:Null<Int>;
		
		#if js
			static var arr:Array<Timer> = [];
			var timerId:Int;
		#elseif (neko||cpp||php)
			var runThread:Thread;
		#end

		public function new(time_ms:Int)
		{
			run = defaultRun;
			#if flash9
				var me = this;
				id = untyped __global__["flash.utils.setInterval"](function() { me.run(); },time_ms);
			#elseif flash
				var me = this;
				id = untyped _global["setInterval"](function() { me.run(); },time_ms);
			#elseif js
				id = arr.length;
				arr[id] = this;
				timerId = untyped window.setInterval("mcover.util.Timer.arr["+id+"].run();",time_ms);
			#elseif (neko||cpp||php)
				var me = this;
				runThread = Thread.create(function() { me.runLoop(time_ms); } );
			#end
		}

		@IgnoreCover
		function defaultRun()
		{}

		public function stop()
		{
			#if( php || flash9 || flash || js )
				if (id == null) return;
			#end
			#if flash9
				untyped __global__["flash.utils.clearInterval"](id);
			#elseif flash
				untyped _global["clearInterval"](id);
			#elseif js
				untyped window.clearInterval(timerId);
				arr[id] = null;
				if (id > 100 && id == arr.length - 1) 
				{
					// compact array
					var p = id - 1;
					while ( p >= 0 && arr[p] == null) p--;
					arr = arr.slice(0, p + 1);
				}
			#elseif (neko||cpp||php)
				run = defaultRun;
				runThread.sendMessage("stop");
			#end
			id = null;
		}

		#if (neko||cpp||php)
			function runLoop(time_ms)
			{
				var shouldStop = false;
				while( !shouldStop )
				{
					Sys.sleep(time_ms/1000);
					try
					{
						run();
					}
					catch( ex:Dynamic )
					{
						trace(ex);
						trace(CallStack.toString(CallStack.exceptionStack()));
					}
					var msg = Thread.readMessage(false);
					if (msg == "stop") shouldStop = true;
				}
			}
		#end

		public static function delay(f:Void -> Void, time_ms:Int):Timer
		{
			var t = new Timer(time_ms);
			t.run = function()
			{
				t.stop();
				f();
			};
			return t;
		}

	#end

	/**
	 *	Returns a timestamp, in seconds
	 */
	public static function stamp():Float
	{
		return inlineStamp();
	}

	/**
	 *	Returns a timestamp, in seconds
	 */
	@IgnoreCover
	inline public static function inlineStamp():Float
	{
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif js
			return Date.now().getTime() / 1000;
		#elseif (neko||cpp||php)
			return Sys.time();
		#elseif cpp
			return untyped __time_stamp();
		#else
			return 0;
		#end
	}
}
