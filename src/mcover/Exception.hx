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

package mcover;

import haxe.PosInfos;

#if haxe3
import haxe.CallStack;
#else
import haxe.Stack;
private typedef CallStack = haxe.Stack;
#end

class Exception
{
	/**
	 * The exception type. 
	 * 
	 * Should be the fully qualified name of the Exception class. e.g. 'massive.io.IOException'
	 */
	public var type(default, null):String;
	
	/**
	 * A description of the exception
	 */
	public var message(default, null):String;
	
	/**
	 * The pos infos from where the exception was created.
	 */
	public var info(default, null):PosInfos;

	/**
	* An optional reference to a lower level exception that
	* triggered the current exception to be thrown
	*/
	public var cause(default, null):Dynamic;
	public var causeExceptionStack(default, null):Array<StackItem>;
	public var causeCallStack(default, null):Array<StackItem>;
	
	/**
	 * @param	message			a description of the exception
	 */
	public function new(message:String, ?cause:Dynamic, ?info:PosInfos) 
	{
		type = here().className;
		this.message = message;
		this.cause = cause;
		this.info = info;

		if(cause != null)
		{
			causeExceptionStack = CallStack.exceptionStack();
			causeCallStack = CallStack.callStack();
		}
	}

	/**
	 * Returns a string representation of this exception.
	 * 
	 * Format: <type>: <message> at <className>#<methodName> (<lineNumber>)
	 */
	public function toString():String
	{
		var str:String = type + ": " + message;
		if (info != null)
			str += " at " + info.className + "#" + info.methodName + " (" + info.lineNumber + ")";
		if (cause != null)
        	str += "\n\t Caused by: " + cause; 
		return str;
	}

	//////////////////

	function here(?info:PosInfos):PosInfos
	{
		return info;
	}
}
