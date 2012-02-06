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
MCover provides a collection of macro based tools for measuring code quality and behavior.

To enable code coverage

	--macro m.cover.MCover.coverage(['package.name'],['sourcePath'], ['ignored patterns'])

To enable function entry/exit logging
	
	--macro m.cover.MCover.logger(['package.name'],['sourcePath'], ['ignored patterns'])

*/
@:keep class MCover
{
	/** 
	Configures MCover for code coverage
	
	From the command line/hxml add a macro reference:
		--macro m.cover.MCover.coverage(['package.name'], ['src'], null)
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
	public static function coverage(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)	
	{	includes.push(CoverageMacro);
		include(packages, classPaths, exclusions);
	}

	/** 
	Configures MCover for function logging
	
	From the command line/hxml add a macro reference:
		--macro m.cover.MCover.logger(['package.name'], ['src'], null)
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
	public static function logger(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	includes.push(LoggerMacro);
		include(packages, classPaths, exclusions);
	}


	static var includes:Array<Class<IncludeMacro>> = [];
	static var instances:Array<IncludeMacro> = [];

	/** 
	Includes classes within multiple classpaths and/or packages.
	Adds @:build(m.cover.macro.BuildMacro.build()) to included classes.
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
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

			//Compiler.keep(cl, null, true);//ignored in haxe 2_0_8
		}

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}
	
		haxe.macro.Context.onGenerate(onGenerate);
	}
	
	/**
	Generate method for macro.Context.
	Loops through all registered include macros and calls their generate method.
	
	@param types 		macro types passed through from the compiler
	*/
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		for(instance in instances)
		{
			instance.onGenerate(types);
		}       
	}
}

#end

