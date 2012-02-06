package m.cover.coverage;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.PosInfos;
class CoverageExceptionTest extends m.cover.ExceptionTest
{

	public function new()
	{
		super();
	}

	override function createInstance(msg:String="message", ?cause:Dynamic=null, ?info:PosInfos):Exception
	{
		return new CoverageException(msg, cause, info);
	}

	override function getTypeString():String
	{
		return "m.cover.coverage.CoverageException";
	}

	// override function getTestName():String
	// {
	// 	return here().className;
	// }
}
