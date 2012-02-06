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
	static var includes:Array<Class<IncludeMacro>> = [];
	static var instances:Array<IncludeMacro> = [];
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
		if(coverage) addInclude(CoverageMacro);
		if(logging) addInclude(LoggerMacro);
	}

	static function addInclude(cls:Class<IncludeMacro>)
	{
		includes.remove(cls);
		includes.push(cls);
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
		var buildArgs:Hash<Array<String>> = new Hash();

		if(includes.length == 0)
		{
			var pos = haxe.macro.Context.makePosition({file:"m.cover.MCover", min:0, max:0});//haxe.macro.Context.currentPos()
			haxe.macro.Context.error("MCover not configured. Please ensure to set --macro m.cover.MCover.configure() before calling --macro m.cover.MCover.include", pos);
		}
			
		for(includeClass in includes)
		{
			var instance = Type.createInstance(includeClass, []);
			instances.push(instance);
		}

		for(instance in instances)
		{
			instance.initialize();
			var classes = instance.getClasses(packages, classPaths, exclusions);

			for(cls in classes)
			{
				var args:Array<String> = [];
				if(buildArgs.exists(cls)) args = buildArgs.get(cls);
				args.push(instance.id);
				buildArgs.set(cls, args);
			}
		}

		for(cls in buildArgs.keys())
		{
			var args = buildArgs.get(cls);
			var argsString = "[\"" + args.join("\",\"") + "\"]";
			//trace(cl);
			Compiler.addMetadata("@:build(m.cover.macro.BuildMacro.build(" + argsString + "))", cls);

			//Compiler.keep(cl, null, true);
		}

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}
	
		haxe.macro.Context.onGenerate(onGenerate);
	}
		
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		for(instance in instances)
		{
			instance.onGenerate(types);
		}       
	}
}

#end

