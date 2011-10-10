package massive.mcover;

import haxe.PosInfos;
import haxe.Stack;

class MCoverException
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
			causeExceptionStack = haxe.Stack.exceptionStack();
			causeCallStack = haxe.Stack.callStack();
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
