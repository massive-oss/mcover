package m.cover.logger;

#if macro

import m.cover.MCover;
import m.cover.macro.PackageHelper;
import m.cover.macro.BuildMacro;
import m.cover.macro.IncludeMacro;

import m.cover.logger.macro.LoggerBuildMacro;

class LoggerMacro implements IncludeMacro
{
	public var id(default, null):String;

	public function new()
	{
		id = "logger";
	}

	public function initialize()
	{
		BuildMacro.registerParser(id, LoggerBuildMacro);
	}

	public function getClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):Array<String>
	{
		if(packages ==  null || packages.length == 0) packages = [""];
		var helper = new PackageHelper();
		helper.ignoreClassMeta = "IgnoreLogging";
		
		var classes = helper.include(classPaths, packages, exclusions);
		return classes;

	}


	public function onGenerate(types:Array<haxe.macro.Type>):Void
	{

	}
}

#end