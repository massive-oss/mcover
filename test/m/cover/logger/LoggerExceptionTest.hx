package m.cover.logger;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import m.cover.logger.LoggerException;
import haxe.PosInfos;
import m.cover.Exception;

/**
* Auto generated MassiveUnit Test Class  for m.cover.logger.LoggerException 
*/
class LoggerExceptionTest extends m.cover.ExceptionTest
{
	
	public function new() 
	{
		super();
	}
	
	///

	override function createInstance(msg:String="message", ?cause:Dynamic=null, ?info:PosInfos):Exception
	{
		return new LoggerException(msg, cause, info);
	}

	override function getTypeString():String
	{
		return "m.cover.logger.LoggerException";
	}
}