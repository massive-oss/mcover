package m.cover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import m.cover.macro.BuildMacro;
import m.cover.coverage.CoverageMacro;
import m.cover.logger.LoggerMacro;
import m.cover.macro.PackageHelper;
import m.cover.macro.IncludeMacro;



/**
* MCover provides a collection of macro based tools for measuring code quality and behavior.
* 
* MACRO USAGE:
*
* To configure which tools to include, use:
*	--macro m.cover.MCover.configure(...);
*
* To specify which class paths/packages to include, use:
* 	--macro m.cover.MCover.include(['package.name'],['sourcePath'], ['ignored patterns'])
* 
*/
@:keep class MCover
{
	public static var includes:Array<IncludeMacro> = [];
	
	/** 
	* Configures MCover features for compilation
	* A
	* From the command line/hxml add a macro reference:
	*	--macro m.cover.MCover.configure();
	* 
	* @param coverage 		include code coverage macros
	* @param logging 		include function logging macros
	**/
	public static function configure(?coverage:Bool=true, ?logging:Bool=false):Void
	{
		if(coverage) includes.push(new CoverageMacro());
		if(logging) includes.push(new LoggerMacro());
	}

	/** 
	* Includes classes/packages for MCover.
	* Adds @:build(m.cover.macro.BuildMacro.build()) to included classes
	* 
	* From the command line/hxml add a macro reference:
	*	--macro m.cover.MCover.include(['package.name'], ['src'], null)
	* 
	* @param packages - array of packages to include (e.g. "com.example"). Defaults to all ([""])
	* @param classPaths - array of classpaths to search in (defaults to local scope only (''))
	* @param exclusions - array of qualified class names to exclude (supports '*' wildcard patterns)
	**/
	static function include(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		var classes:Array<String> = [];

		if(includes.length == 0)
		{
			var pos = haxe.macro.Context.makePosition({file:"m.cover.MCover", min:0, max:0});//haxe.macro.Context.currentPos()
			haxe.macro.Context.error("MCover not configured. Please ensure to set --macro m.cover.MCover.configure() before calling --macro m.cover.MCover.include", pos);
		}
			
		for(item in includes)
		{
			item.initialize();
			var a = item.getClasses(packages, classPaths, exclusions);
			classes = appendClasses(a, classes);
		}

		for(cl in classes)
		{
			//trace(cl);
			Compiler.addMetadata("@:build(m.cover.macro.BuildMacro.build())", cl);
			//Compiler.keep(cl, null, true);
		}

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}
	
		haxe.macro.Context.onGenerate(onGenerate);
	}

	static function appendClasses(a1:Array<String>, a2:Array<String>):Array<String>
	{
		for(a in a1)
		{
			a2.remove(a);
		}

		return a2.concat(a1);
	}

		
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		for(item in includes)
		{
			item.onGenerate(types);
		}       
	}
}

#end

