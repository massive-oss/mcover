package m.cover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

import m.cover.macro.PackageHelper;


@:keep class MLogger
{
	//--------------- MACROS --------------..

	/** 
	* Includes classes/packages logging.
	* Adds @:build(macro.BuildMacro.build()) to included classes
	* 
	* From the command line/hxml add a macro reference:
	*	--macro MLog.include(['package.name'], ['src'], null)
	* 
	* @param packages - array of packages to include (e.g. "com.example"). Defaults to all ([""])
	* @param classPaths - array of classpaths to search in (defaults to local scope only (''))
	* @param exclusions - array of qualified class names to exclude (supports '*' wildcard patterns)
	**/
	public static function include(?packages : Array<String>, ?classPaths : Array<String>, ?exclusions : Array<String> )
	{	
		if(packages ==  null || packages.length == 0) packages = [""];
		var helper = new PackageHelper();
		var classes = helper.include(classPaths, packages, exclusions);

		for(cl in classes)
		{
			Compiler.addMetadata("@:build(m.cover.logger.macro.LoggerBuildMacro.build())", cl);
			//Compiler.keep(cl, null, true);
		}

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}
	
		haxe.macro.Context.onGenerate(MLogger.onGenerate);
	}

	public static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		
	}
}
#else

#if neko
import neko.vm.Deque;
#end
import m.cover.logger.Logger;
import m.cover.logger.LoggerImpl;

class MLogger
{
	#if neko
		static public var mutex:neko.vm.Mutex;
	#end

	static public var logger(default, null):Logger;

	public static function getLogger():Logger
	{
		#if neko
			if(mutex == null) mutex = new neko.vm.Mutex();
		 	mutex.acquire();
		#end
		if(logger == null)
		{
			logger = new LoggerImpl();
		}
		#if neko mutex.release(); #end
		return logger;
	}

	function new()
	{
		
	}
}
#end