package massive.mcover;

import haxe.PosInfos;
import haxe.Stack;

class MCoverException
{
	/**
	* Utility method to generate a new MCoverException instance with a reference to an existing exception 
	*/
	static public function rethrow(e:Dynamic, message:String, ?info:PosInfos):MCoverException
	{
		var exception = new MCoverException(message, info);
		exception.originalException = e;
		return exception;
	}

	//////////////////

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
	public var originalException(default, set_originalException):Dynamic;
	public var originalExceptionStack(default, null):Array<StackItem>;
	public var originalExceptionCallStack(default, null):Array<StackItem>;
	
	/**
	 * @param	message			a description of the exception
	 */
	public function new(message:String, ?info:PosInfos) 
	{
		this.message = message;
		this.info = info;
		type = here().className;
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
		return str;
	}

	public function hasOriginalException():Bool
	{
		return originalException != null;
	}

	//////////////////

	function set_originalException(e:Dynamic):Dynamic
	{
		originalException = e;
		originalExceptionStack = haxe.Stack.exceptionStack();
		originalExceptionCallStack = haxe.Stack.callStack();
			
	}
	function here(?info:PosInfos):PosInfos
	{
		return info;
	}
}
