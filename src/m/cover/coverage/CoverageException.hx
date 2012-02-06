package m.cover.coverage;

import haxe.PosInfos;
import m.cover.Exception;

class CoverageException extends Exception
{
	public function new(message:String, ?cause:Dynamic, ?info:PosInfos)
	{
		super(message, cause, info);
		type = here().className;
	}
}