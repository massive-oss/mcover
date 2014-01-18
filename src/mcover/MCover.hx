/**
	Copyright 2013 Massive Interactive. All rights reserved.
	
	Redistribution and use in source and binary forms, with or without modification, are
	permitted provided that the following conditions are met:
	
	   1. Redistributions of source code must retain the above copyright notice, this list of
	      conditions and the following disclaimer.
	
	   2. Redistributions in binary form must reproduce the above copyright notice, this list
	      of conditions and the following disclaimer in the documentation and/or other materials
	      provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
	FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	
	The views and conclusions contained in the software and documentation are those of the
	authors and should not be interpreted as representing official policies, either expressed
	or implied, of Massive Interactive.
**/

package mcover;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import mcover.macro.*;
import mcover.coverage.MCoverage;
import mcover.coverage.DataTypes;
import sys.io.File;
import sys.FileSystem;

using Lambda;

/**
MCover provides a collection of macro based tools for measuring code quality and behavior.

To enable code coverage

	--macro mcover.MCover.coverage(['package.name'],['sourcePath'], ['ignored patterns'])

To enable function entry/exit logging
	
	--macro mcover.MCover.logger(['package.name'],['sourcePath'], ['ignored patterns'])

**/
@:keep class MCover
{
	/** 
	Configures MCover for code coverage
	
	From the command line/hxml add a macro reference:
		--macro mcover.MCover.coverage(['package.name'], ['src'], null)
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param classPaths 	array of classpaths to search in (defaults to local scope only [''])
	@param exclusions 	array of qualified class names to exclude (supports '*' wildcard patterns)
	**/
	public static function coverage(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)	
	{	
		include(packages, classPaths, exclusions);
	}

	public static function logger(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		Context.error("MCover.logger has been removed in version 3", Context.currentPos());
	}

	public static var TEMP_DIR:String = ".temp/mcover/";

	static var classPaths:Map<String,Bool> = new Map();

	/**
		Used by BuildMacro to store generated coverage data classes that will be compiled into application.
	**/
	static public var coverageData = new Coverage();

	/** 
	Includes classes within multiple classpaths and/or packages.
	Adds @:build(mcover.macro.BuildMacro.build()) to included classes.
	
	@param packages 	array of packages to include (e.g. "com.example") (defaults to all [""])
	@param cps 		array of classpaths to search in (defaults to local scope only [''])
	@param exclusions array of qualified class names to exclude (supports '*' wildcard patterns)
	**/
	static function include(?packages : Array<String>=null, ?cps : Array<String>=null, ?exclusions : Array<String>=null)
	{	
		var temp = TEMP_DIR.split("/");

		var path = "";
		
		while (temp.length > 0)
		{	
			var part = temp.shift();
			if (part == "" && temp.length == 0) break;

			path += part;

			if (!FileSystem.exists(path)) FileSystem.createDirectory(path);

			path += "/";
		}

		initLogging();

		if (packages == null || packages.length == 0)
			packages = [""];

		if (cps == null)
			cps = [""];
		
		cps = convertToFullPaths(cps);

		if (exclusions == null)
			exclusions = [];

		for (cp in cps)
		{
			classPaths.set(cp, true);
		}

		var filter = new ClassPathFilter();
		filter.ignoreClassMeta = "IgnoreCover,:IgnoreCover,:ignore";
		var classes = filter.filter(cps, packages, exclusions);

		if (classes.count() == 0)
			Context.warning("No classes match criteria in MCover macro:\n	packages: " + packages + ",\n	classPaths: " + classPaths + ",\n	exclusions: " + exclusions, Context.currentPos());

		for (cls in classes.keys())
		{
			if (classes.get(cls))
			{
				Compiler.addMetadata("@:build(mcover.MCover.build())", cls);
				Compiler.keep(cls, null, true);
				
			}
			else
				exclusions.push(cls);
		}

		trace("Excluding: " + exclusions);

		for (pack in packages)
		{
			Compiler.include(pack, true, exclusions, cps);
		}

		haxe.macro.Context.onGenerate(onGenerate);
	}

	static function convertToFullPaths(paths:Array<String>)
	{
		var fullPaths:Array<String> = [];

		for (path in paths)
		{
			fullPaths.push(FileSystem.fullPath(path));	
		}
		return fullPaths;
	}

	/**
		Per class build macro to add coverage expressions
	@return updated array of fields for the class
	**/
	macro public static function build():Array<Field>
	{
		var classParser = new BuildMacro(classPaths); 
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
		Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	This resource is used by MCoverRunner to determine code coverage results

	@param types 		macro types passed through from the compiler
	**/
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		var serializedData = haxe.Serializer.run(MCover.coverageData);
       	Context.addResource(MCoverage.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));
	}


	static function initLogging()
	{
		// Console.removePrinter(Console.defaultPrinter);
		// Console.addPrinter(new FilePrinter(TEMP_DIR + "mcover.log"));
		// Console.start();

		var path = TEMP_DIR + "mcover.log";

		if (FileSystem.exists(path))
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

