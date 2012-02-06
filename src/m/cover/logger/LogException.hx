package m.cover.logger;

import haxe.PosInfos;
import m.cover.Exception;

class LogException extends Exception
{
	public function new(msg:String, ?pos:PosInfos)
	{
		super(msg, pos);
	}
}