/****
* Copyright 2013 Massive Interactive. All rights reserved.
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

package mcover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import mcover.macro.ClassParser;
import mcover.coverage.macro.CoverageMacroDelegate;
import mcover.logger.macro.LoggerMacroDelegate;
import mcover.macro.MacroDelegate;

import sys.io.File;
import sys.FileSystem;

#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<T> = Hash<T>
#end

/**
MCover provides a collection of macro based tools for measuring code quality and behavior.

To enable code coverage

	--macro mcover.MCover.coverage(['package.name'],['sourcePath'], ['ignored patterns'])

To enable function entry/exit logging
	
	--macro mcover.MCover.logger(['package.name'],['sourcePath'], ['ignored patterns'])

*/
@:keep class MCover
{
	/** 
	Configures MCover for code coverage
	
	From the command line/hxml add a macro reference:
		--macro mcover.MCover.coverage(['package.name'], ['src'], null)
	
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
		--macro mcover.MCover.logger(['package.name'], ['src'], null)
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
	public static function logger(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	delegateClasses.push(LoggerMacroDelegate);
		include(packages, classPaths, exclusions);
	}

	public static var TEMP_DIR:String = ".temp/mcover/";
	static var delegateClasses:Array<Class<MacroDelegate>> = [];
	static var delegates:Array<MacroDelegate> = [];
	static var delegatesById:StringMap<MacroDelegate> = new StringMap();

	/** 
	Includes classes within multiple classpaths and/or packages.
	Adds @:build(mcover.macro.ClassParser.build()) to included classes.
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	*/
	static function include(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		var temp = TEMP_DIR.split("/");

		var path = "";
		
		while(temp.length > 0)
		{	
			var part = temp.shift();
			if(part == "" && temp.length == 0) break;

			path += part;

			if(!FileSystem.exists(path)) FileSystem.createDirectory(path);

			path += "/";
		}

		initLogging();

		if(exclusions == null) exclusions = [];

		classPaths = convertToFullPaths(classPaths);

		for(delegateClass in delegateClasses)
		{
			var delegate = Type.createInstance(delegateClass, []);
			delegates.push(delegate);
			delegatesById.set(delegate.id, delegate);
		}

		var classMacroMap:StringMap<Array<String>> = new StringMap();

		for(delegate in delegates)
		{
			var classMap = delegate.filterClasses(packages, classPaths, exclusions);

			for(cls in classMap.keys())
			{
				
				var args:Array<String> = null;

				if(classMacroMap.exists(cls)) args = classMacroMap.get(cls);
				else args = [];

				if(classMap.get(cls) == true) args.push(delegate.id);

				classMacroMap.set(cls, args);
			}
		}

		if(Lambda.count(classMacroMap)==0)
		{
			Context.warning("No classes match criteria in MCover macro:\n	packages: " + packages + ",\n	classPaths: " + classPaths + ",\n	exclusions: " + exclusions, Context.currentPos());
		}
		
		for(cls in classMacroMap.keys())
		{
			var args = classMacroMap.get(cls);

			if(args.length > 0)
			{
				var argsString = "[\"" + args.join("\",\"") + "\"]";
				Compiler.addMetadata("@:build(mcover.MCover.build(" + argsString + "))", cls);
				Compiler.keep(cls, null, true);//ignored in haxe 2_0_8
			}
			else
			{
				exclusions.push(cls);
			}
		}

		trace("Excluding: " + exclusions);

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
			fullPaths.push(FileSystem.fullPath(path));	
		}
		return fullPaths;
	}

	/**
	Per class build macro.
	Loops through delegate ids and adds matching ExpressionParsers to the ClassParser

	@param ids 	Array of MacroDelegagte ids for including in this class build
	@return updated array of fields for the class
	*/
	#if haxe3 macro #else @macro #end
	public static function build(ids:Array<String>):Array<Field>
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
		try
		{
			var fields = classParser.parseFields();
			return fields;
		}
		catch(e:Exception)
		{
			trace(e);
			Sys.sleep(.1);
			Context.error("Exception parsing class: " + e, Context.currentPos());
		}

		return null;
		
		
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
			instance.generate(types);
		}
	}



	static function initLogging()
	{
		// Console.removePrinter(Console.defaultPrinter);
		// Console.addPrinter(new FilePrinter(TEMP_DIR + "mcover.log"));
		// Console.start();


		var path = TEMP_DIR + "mcover.log";

		if(FileSystem.exists(path))
			FileSystem.deleteFile(path);


		var file = sys.io.File.write(path, false);
		file.writeString("");
		file.close();

		haxe.Log.trace = function ( v : Dynamic, ?infos : haxe.PosInfos )
		{
			var file = sys.io.File.append(path, false);
			file.writeString(infos.className + "." + infos.methodName + "[" + infos.lineNumber + "] " + Std.string(v) + "\n");
			file.close();
		}

	}
}

#end

