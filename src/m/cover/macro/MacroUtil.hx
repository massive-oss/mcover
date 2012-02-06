package m.cover.macro;

import haxe.macro.Expr;
import haxe.macro.Context;

class MacroUtil
{
	static public function incrementPos(pos:Position, length:Int):Position
	{
		var posInfos = Context.getPosInfos(pos);
		posInfos.max = posInfos.min + length;
		return Context.makePosition(posInfos);
	}
}