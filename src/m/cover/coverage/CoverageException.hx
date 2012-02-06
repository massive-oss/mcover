package m.cover.coverage;

import haxe.PosInfos;
import m.cover.Exception;

class CoverageException extends Exception
{
	public function new(msg:String, ?pos:PosInfos)
	{
		super(msg, pos);
	}
}