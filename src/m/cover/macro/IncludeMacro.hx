package m.cover.macro;
interface IncludeMacro
{
	function initialize():Void;
	function getClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):Array<String>;
	function onGenerate(types:Array<haxe.macro.Type>):Void;
} 