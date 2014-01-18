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

package mcover.macro;

import haxe.crypto.Md5;

#if macro
	
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Context;

class ClassPathFilter
{
	/**
	optional class @metadata to exclude from list 
	e.g. @IgnoreFoo 
	**/
	public var ignoreClassMeta:String;

	/**
	optional class @metadata to filter by 
	e.g. @IncludeFoo 
	**/
	public var includeClassMeta:String;

	var classMap:Map<String,Bool>;
	var skip:String -> Bool;

	var cache:FilteredClassCache;

	public function new()
	{
		ignoreClassMeta = null;
		includeClassMeta = null;
	}
	/**
		Recursively loops through classpaths and filter matching classes
		@param classPaths - array of classpaths to include in coverage (defaults to local scope only - i.e. ['']
		@param packages - array of package names to filter on (e.g. "com.example"). Defaults to all - i.e. ['']
		@param exclusions - array of qualified class names /packages to exclude from coverage (supports '*' wildcard patterns)
		@return array of classes
	**/
	public function filter(?classPaths : Array<String>, ?packages : Array<String>, ?exclusions : Array<String>):Map<String,Bool>
	{
		classMap = new Map();

		if (exclusions == null || exclusions.length == 0)
		{
			skip = function(c:String) return false;
		}
		else
		{
			skip = function(c:String) return isExcludedClass(exclusions, c);
		}

		if (null == classPaths)
			classPaths = [""];

		if (null == packages)
			packages = [""];

		cache = new FilteredClassCache("cache.txt");
		cache.init(classPaths, packages, exclusions);
		
		//normalize class paths
		for ( i in 0...classPaths.length )
		{
			var cp = StringTools.replace(classPaths[i], "\\", "/");
			
			if (StringTools.endsWith(cp, "/")) cp = cp.substr(0, -1);
			classPaths[i] = cp;
		}
		
		for (cp in classPaths)
		{
			for (pack in packages)
			{
				includePackage(cp, pack);
			}
		}

		cache.save();

		return classMap;
	}

	/**
	Recursively searches a package within a class path for matching classes
	**/
	function includePackage(cp:String, pack:String)
	{
		var classes:Array<String> = [];
		var prefix:String = pack;
		var path:String = cp;

		if (pack != "")
		{
			prefix += ".";
			path += "/" + pack.split(".").join("/");
		}
		if ( !FileSystem.exists(path) || !FileSystem.isDirectory(path) ) return;

		for (file in FileSystem.readDirectory(path))
		{	
			var filePath = path + "/" + file;

			if (StringTools.endsWith(file, ".hx") )
			{
				includeFile(filePath);
			}
			else if (FileSystem.isDirectory(filePath) && !skip(prefix + file) )
			{
				includePackage(cp, prefix + file);
			}
		}
	
	}

	/**
	Includes the classes in a file to the classMap.
	Adds the path to the cache if not up to date
	**/
	function includeFile(path:String)
	{
		if (!cache.isCached(path))
		{
			addClassesInFileToCache(path);
		}
		
		for (cls in cache.getIncludedClassesInFile(path))
		{
			classMap.set(cls, true);
		}
		for (cls in cache.getExcludedClassesInFile(path))
		{
			classMap.set(cls, false);
		}	
	}

	/**
	Parses the contents of a hx file and adds the included/excluded classes to the cache

	Includes hacks to detect ignored/included class metadata without using Context.getLocalClass().get()
	which can fail compilation in some edge cases for classes with generics (e.g. class Foo<T:Bar> extends Base<T:BarBase>)
	
	@param path - the file path to cache
	**/

	function addClassesInFileToCache(path:String)
	{
		var includes:Array<String> = [];
		var excludes:Array<String> = [];

		var contents:String = File.getContent(path);

		var prefix = getPackageDefinitionInFile(contents);

		var excludesMap:Map<String,Bool> = new Map(); 

		var temp:String;

		if (ignoreClassMeta != null)
		{
			var ignoreClassMetas = "(" + ignoreClassMeta.split(",").join("|") + ")";//e.g. :(IgnoreCover|:IgnoreCover|:ignore|:macro)

			temp = contents;
			//var regIgnore:EReg = ~/@IgnoreCover([^{]*)class ([A-Z]([A-Za-z0-9])+)/m;
			var regIgnore:EReg = new EReg("@" + ignoreClassMetas + "([^{]*)class ([A-Z]([A-Za-z0-9_])+)", "m");
		
			while (regIgnore.match(temp))
			{
				excludesMap.set(prefix + regIgnore.matched(3), true);
				temp = regIgnore.matchedRight();
			}
		}

		var regInclude:EReg = null;

		if (includeClassMeta != null)
		{
			regInclude = new EReg("@" + includeClassMeta + "([^{]*)class ([A-Z]([A-Za-z0-9_])+)", "m");
		}
		else
		{

			//Note(Dom, Feb 2013): Commenting out alternative as i'm assuming this is a change from from 210 on...
			// #if haxe_210
				regInclude = ~/^([^\*;]*)class ([A-Z]([A-Za-z0-9_])+)/m;
			// #else
			// 	regInclude = ~/(.*)class ([A-Z]([A-Za-z0-9_])+)/m;
			// #end

		}

		temp = contents;

		while (regInclude.match(temp))
		{
			var cls = prefix + regInclude.matched(2);
			
			if (excludesMap.exists(cls) || skip(cls))
			{
				excludes.push(cls);
			}
			else
			{
				includes.push(cls);
			}
			temp = regInclude.matchedRight();
		}

		cache.addToCache(path, includes, excludes);
	}

	/**
		Looks for match in exlucded class patterns.
		Supports optional '*' wildcards
		e.g. foo.Foo
		e.g. foo.*
		e.g. *.Foo

		@return true if excluded
	**/
	function isExcludedClass(exclusions:Array<String>, clazz:String):Bool
	{
		for (pattern in exclusions)
		{
			if (pattern.indexOf("*") == -1)
			{
				 if (clazz == pattern) return true;
				 continue;
			}

			var expr = pattern.split(".").join("\\.");
			expr = expr.split("*").join("(.*)");

			var reg = new EReg(expr, "");

			if (reg.match(clazz))return true;
		}

		return false;
	}

	/**
		looks for a valid package definition in a class
	**/
	function getPackageDefinitionInFile(contents:String):String
	{
		//var contents = File.getContent(path);
		var reg:EReg = ~/^package ([a-z]([A-Za-z0-9\._])+);/m;

		if (reg.match(contents))
		{
			return reg.matched(1) + ".";
		}
		return "";
	}

	////////////
	
}
#end