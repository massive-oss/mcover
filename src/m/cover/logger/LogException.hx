package m.cover.logger;

import haxe.PosInfos;
import m.cover.Exception;

class LogException extends Exception
{
	public function new(message:String, ?cause:Dynamic, ?info:PosInfos)
	{
		super(message, cause, info);
		type = here().className;
	}
}