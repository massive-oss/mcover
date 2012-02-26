/****
* Copyright 2012 Massive Interactive. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

package m.cover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import m.cover.macro.ClassParser;
import m.cover.coverage.macro.CoverageMacroDelegate;
import m.cover.logger.macro.LoggerMacroDelegate;
import m.cover.macro.MacroDelegate;



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
	{	delegateClasses.push(CoverageMacroDelegate);
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
	{	delegateClasses.push(LoggerMacroDelegate);
		include(packages, classPaths, exclusions);
	}

	static var delegateClasses:Array<Class<MacroDelegate>> = [];
	static var delegates:Array<MacroDelegate> = [];
	static var delegatesById:Hash<MacroDelegate> = new Hash();

	/** 
	Includes classes within multiple classpaths and/or packages.
	Adds @:build(m.cover.macro.ClassParser.build()) to included classes.
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
	static function include(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		initialiseTrace();

		var classMacroHash:Hash<Array<String>> = new Hash();
		
		classPaths = convertToFullPaths(classPaths);

		for(delegateClass in delegateClasses)
		{
			var delegate = Type.createInstance(delegateClass, []);
			delegates.push(delegate);
			delegatesById.set(delegate.id, delegate);
		}

		for(delegate in delegates)
		{
			var classes = delegate.getClasses(packages, classPaths, exclusions);

			for(cls in classes)
			{
				var args:Array<String> = [];
				if(classMacroHash.exists(cls)) args = classMacroHash.get(cls);
				args.push(delegate.id);
				classMacroHash.set(cls, args);
			}
		}

		flush();

		if(Lambda.count(classMacroHash)==0)
		{
			Context.warning("No classes match criteria in MCover macro:\n	packages: " + packages + ",\n	classPaths: " + classPaths + ",\n	exclusions: " + exclusions, Context.currentPos());
		}

		for(cls in classMacroHash.keys())
		{
			var args = classMacroHash.get(cls);
			var argsString = "[\"" + args.join("\",\"") + "\"]";
			trace(cls);
			flush();
			Compiler.addMetadata("@:build(m.cover.MCover.build(" + argsString + "))", cls);
			//Compiler.keep(cl, null, true);//ignored in haxe 2_0_8
		}

		flush();

		for(pack in packages)
		{
			Compiler.include(pack, true, exclusions, classPaths);
		}

		haxe.macro.Context.onGenerate(onGenerate);
	}

	static function convertToFullPaths(paths:Array<String>)
	{
		var fullPaths:Array<String> = [];

		for(path in paths)
		{
			fullPaths.push(neko.FileSystem.fullPath(path));	
		}
		return fullPaths;
	}

	/**
	Per class build macro.
	Loops through delegate ids and adds matching ExpressionParsers to the ClassParser

	@param ids 	Array of MacroDelegagte ids for including in this class build
	@return updated array of fields for the class
	*/
	@:macro public static function build(ids:Array<String>):Array<Field>
	{
		var classParser = new ClassParserImpl(); 

		for(id in ids)
		{
			if(!delegatesById.exists(id))
			{
				Context.error("Unknown macro id: " + id, Context.currentPos());
			}
			var delegate = delegatesById.get(id);
			var parserClass = delegate.getExpressionParser();


			if(parserClass != null)
			{
				var parser = Type.createInstance(parserClass, []);
				classParser.addExpressionParser(parser);
			}
		}

		var fields = classParser.parseFields();
		return fields;
	}
	
	/**
	Generate method for macro.Context.
	Loops through all registered include macros and calls their generate method.
	
	@param types 		macro types passed through from the compiler
	*/
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		for(instance in delegates)
		{
			neko.Lib.print(".");
			instance.generate(types);
		}
		flush();       
	}

	///// TRACE OUTPUT ///////

	static var TRACE_OUTPUT_FILE = ".mcover-debug";
	static var traceOutput:String = "";

	/**
	maps trace function to MCover.traceToFile
	Clears existing trace output from file
	*/
	static function initialiseTrace()
	{
		var file = neko.io.File.write(TRACE_OUTPUT_FILE, false);
		file.writeString("");
		file.close();

		haxe.Log.trace = traceToFile;
	}

	/**
	Custom trace function that appends trace messages to text file.
	Used to avoid slowdown from default trace writing to stdout in recursive expression parser
	*/
	static function traceToFile(msg:Dynamic, ?pos:haxe.PosInfos)
	{
		traceOutput += "\n" + StringTools.rpad(pos.className + ":" + pos.lineNumber + " ", " ", 60) + "| " + Std.string(msg);
	}

	/**
	Writes trace output to file
	*/
	static function flush()
	{
		var file = neko.io.File.append(TRACE_OUTPUT_FILE, false);	
		file.writeString(traceOutput);
		file.close();
		traceOutput = "";
	}

}

#end

