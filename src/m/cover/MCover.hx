package m.cover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

import m.cover.coverage.macro.CoverageBuildMacro;
import m.cover.macro.PackageHelper;

/**
* Main Coverage class containing macro and runtime  methods for creating,
* logging and reporting code coverage.
* 
* MACRO USAGE:
*
* Use --macro m.cover.MCover.include(['package.name'],['sourcePath'], ['ignored patterns'])
* to specifiy which packages/src directories to cover
* 
* 
* RUNTIME USAGE:
*
* See detailed documentation below for the following:
*    getLogger();
*/
@:keep class MCover
{
	static public var RESOURCE_DATA:String = "MCoverData";

	static public var classPathHash:IntHash<String> = new IntHash();
	//--------------- MACROS --------------..

	/** 
	* Includes classes/packages logging.
	* Adds @:build(macro.BuildMacro.build()) to included classes
	* 
	* From the command line/hxml add a macro reference:
	*	--macro m.cover.MCover.include(['package.name'], ['src'], null)
	* 
	* @param packages - array of packages to include (e.g. "com.example"). Defaults to all ([""])
	* @param classPaths - array of classpaths to search in (defaults to local scope only (''))
	* @param exclusions - array of qualified class names to exclude (supports '*' wildcard patterns)
	**/
	public static function include(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		if(packages ==  null || packages.length == 0) packages = [""];
		var helper = new PackageHelper();
		helper.ignoreClassMeta = "@IgnoreCover";
		var classes = helper.include(classPaths, packages, exclusions);

		for(cp in classPaths)
		{
			classPathHash.set(Lambda.count(classPathHash), cp);
		}

		for(cl in classes)
		{
			//trace(cl);
			Compiler.addMetadata("@:build(m.cover.coverage.macro.CoverageBuildMacro.build())", cl);
			//Compiler.keep(cl, null, true);
		}

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}
	
		haxe.macro.Context.onGenerate(CoverageBuildMacro.onGenerate);
	}

	public static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		
	}
}
#else

#if neko
import neko.vm.Deque;
#end

import m.cover.coverage.CoverageLogger;

class MCover
{
	static public var RESOURCE_DATA:String = "MCoverData";

	#if neko
		static public var mutex:neko.vm.Mutex;
	#end

	static public var logger(default, null):CoverageLogger;

	
	@IgnoreCover
	public static function getLogger():CoverageLogger
	{
		#if neko
			if(mutex == null) mutex = new neko.vm.Mutex();
		 	mutex.acquire();
		#end
		if(logger == null)
		{
			logger = new CoverageLoggerImpl();
		}
		#if neko mutex.release(); #end
		return logger;
	}

	@IgnoreCover
	function new()
	{
		
	}
}
#end

