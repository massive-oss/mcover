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

package m.cover.macro;

#if neko
class PackageHelper
{
	/**
	optional class @metadata to exclude from list 
	e.g. @IgnoreFoo 
	*/
	public var ignoreClassMeta:String;

	/**
	optional class @metadata to filter by 
	e.g. @IncludeFoo 
	*/
	public var includeClassMeta:String;

	var classHash:Hash<Bool>;
	var skip:String -> Bool;

	public function new()
	{
		ignoreClassMeta = null;
		includeClassMeta = null;
	}
	/**
	* Recursively loops through classpaths and filter matching classes
	*
	* @param classPaths - array of classpaths to include in coverage (defaults to local scope only - i.e. ['']
	* @param packages - array of package names to filter on (e.g. "com.example"). Defaults to all - i.e. ['']
	* @param exclusions - array of qualified class names /packages to exclude from coverage (supports '*' wildcard patterns)
	* @return array of classes
	*/
	public function include(?classPaths : Array<String>, ?packages : Array<String>, ?exclusions : Array<String>)
	{
		var classes:Array<String> = [];
		classHash = new Hash();

		if(exclusions == null || exclusions.length == 0)
		{
			skip = function(c:String) return false;
		}
		else
		{
			skip = function(c:String) return isExcludedClass(exclusions, c);
		}

		if(null == classPaths)
			classPaths = [""];

		if(null == packages)
			packages = [""];
		
		//normalize class paths
		for( i in 0...classPaths.length )
		{
			var cp = StringTools.replace(classPaths[i], "\\", "/");
			if(StringTools.endsWith(cp, "/")) cp = cp.substr(0, -1);
			classPaths[i] = cp;
		}
		
		for(cp in classPaths)
		{
			for(pack in packages)
			{
				classes = classes.concat(includePackage(cp, pack));
			}
		}
		return classes;
	}


	/**
	Recursively searches a package within a class path for matching classes
	*/
	function includePackage(cp:String, pack:String):Array<String>
	{
		var classes:Array<String> = [];
		var prefix:String = pack;
		var path:String = cp;

		if(pack != "")
		{
			prefix += ".";
			path += "/" + pack.split(".").join("/");
		}

		if( !neko.FileSystem.exists(path) || !neko.FileSystem.isDirectory(path) ) return classes;
				
		for(file in neko.FileSystem.readDirectory(path))
		{	
			if(StringTools.endsWith(file, ".hx") )
			{
				var tempClasses = getClassesInFile(path + "/" + file);

				prefix = getPackageDefinitionInFile(path + "/" + file);
				
				for(cl in tempClasses)
				{
					cl = prefix + cl;
					if(skip(cl)) continue;
					if(classHash.exists(cl)) continue;
					
					classHash.set(cl, true);
					classes.push(cl);
				}
			}
			else if(neko.FileSystem.isDirectory(path + "/" + file) && !skip(prefix + file) )
			{
				classes = classes.concat(includePackage(cp, prefix + file));
			}
		}

		return classes;
	
	}


	/**
	* Looks for match in exlucded class patterns.
	* Supports optional '*' wildcards
	* e.g. foo.Foo
	* e.g. foo.*
	* e.g. *.Foo
	*
	* @return true if excluded
	*/
	function isExcludedClass(exclusions:Array<String>, clazz:String):Bool
	{
		for(pattern in exclusions)
		{
			if(pattern.indexOf("*") == -1)
			{
				 if(clazz == pattern) return true;
				 continue;
			}

			var expr = pattern.split(".").join("\\.");
			expr = expr.split("*").join("(.*)");

			var reg = new EReg(expr, "");

			if(reg.match(clazz)) return true;
		}

		return false;
	}

	/**
	* looks for a valid package definition in a class
	*/
	function getPackageDefinitionInFile(path:String):String
	{
		var contents = neko.io.File.getContent(path);
		var reg:EReg = ~/^package ([a-z]([A-Za-z0-9\.])+);/;

		if(reg.match(contents))
		{
			return reg.matched(1) + ".";
		}
		return "";
	}



	/**
	Returns all matching classes in a file.

	Includes hacks to detect ignored/included class metadata without using Context.getLocalClass().get()
	which can fail compilation in some edge cases for classes with generics (e.g. class Foo<T:Bar> extends Base<T:BarBase>)
	
	@param path - the file path to inspect
	@return array of matching class names
	*/
	function getClassesInFile(path:String):Array<String>
	{
		var classes:Array<String> = [];
		var contents:String;

		var ignoredClasses:Hash<Bool> = new Hash(); 

		if(ignoreClassMeta != null)
		{
			//var regIgnore:EReg = ~/@IgnoreCover([^{]*)class ([A-Z]([A-Za-z0-9])+)/m;
			var regIgnore:EReg = new EReg("@" + ignoreClassMeta + "([^{]*)class ([A-Z]([A-Za-z0-9])+)", "m");

			contents = neko.io.File.getContent(path);

			while(regIgnore.match(contents))
			{
				ignoredClasses.set(regIgnore.matched(2), true);
				contents = regIgnore.matchedRight();
			}
		}

		var regInclude:EReg = null;

		if(includeClassMeta != null)
		{
			regInclude = new EReg("@" + includeClassMeta + "([^{]*)class ([A-Z]([A-Za-z0-9])+)", "m");
		}
		else
		{
			regInclude = ~/(.*)class ([A-Z]([A-Za-z0-9])+)/;
		}

		contents = neko.io.File.getContent(path);

		while(regInclude.match(contents))
		{
			var cls = regInclude.matched(2);
			if(!ignoredClasses.exists(cls))
			{
				classes.push(cls);
			}
			
			contents = regInclude.matchedRight();
		}
		return classes;
	}


	/**
	* returns all class definitions in a file.
	*/
	function getClassesInFileSimple(path:String):Array<String>
	{
		var classes:Array<String> = [];
		var contents:String;

		var reg:EReg = ~/(.*)class ([A-Z]([A-Za-z0-9])+)/;
		contents = neko.io.File.getContent(path);
		
		while(reg.match(contents))
		{
			var cls = reg.matched(2);
			classes.push(cls);
			contents = reg.matchedRight();
		}
		return classes;
	}

	
}
#end