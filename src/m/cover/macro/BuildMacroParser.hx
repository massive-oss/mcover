package m.cover.macro;

#if macro
import haxe.macro.Expr;
import m.cover.macro.BuildMacro;

interface BuildMacroParser
{
	
	var ignoreFieldMeta(default, default):String;
	var includeFieldMeta(default, default):String;

	var target(default, default):IBuildMacro;

	function parseExpr(expr:Expr):Expr;
}

#end