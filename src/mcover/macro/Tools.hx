package mcover.macro;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.PosInfos;

using haxe.macro.Tools;

class Tools
{
	public static function at(expr:ExprDef, pos:Position):Expr
	{
		return {expr:expr, pos:pos};
	}
}

#end