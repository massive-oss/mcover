package mcover.logger;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.logger.LoggerException;
import haxe.PosInfos;
import mcover.Exception;

/**
* Auto generated MassiveUnit Test Class  for mcover.logger.LoggerException 
*/
class LoggerExceptionTest extends mcover.ExceptionTest
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
		return "mcover.logger.LoggerException";
	}
}