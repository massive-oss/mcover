/****
* Copyright 2011 Massive Interactive. All rights reserved.
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

package massive.mcover;

#if !macro
import massive.mcover.CoverageLogger;

#if neko
import neko.vm.Deque;
#end

#else
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
#end

/**
* Main Coverage class containing macro and runtime  methods for creating,
* logging and reporting code coverage.
* 
* MACRO USAGE:
*
* Use --macro massive.mcover.MCover.include('package.name',['sourcePath'])
* to specifiy which packages/src directories to cover
* 
* 
* RUNTIME USAGE:
*
* See detailed documentation below for the following:
*    getInstance();
*    createReporter();
*/
@:keep class MCover
{
	static public var VERSION:String = "1.0";
	static public var RESOURCE_DATA:String = "MCoverData";

	#if !macro
	
	static public var logger(default, null):CoverageLogger;

	#if neko
	static public var mutex:neko.vm.Mutex = new neko.vm.Mutex();
	#end

	@IgnoreCover
	public static function getLogger():CoverageLogger
	{
		#if neko mutex.acquire(); #end
		if(logger == null)
		{
			logger = new CoverageLoggerImpl();
		}
		#if neko mutex.release(); #end
		return logger;
	}

	#else
	//--------------- MACROS --------------..

	static public var classPathHash:IntHash<String> = new IntHash();
	static public var classHash:IntHash<String> = new IntHash();
		
	/** 
	* Includes classes/packages for code coverage.
	* Adds @:build(mcover.MCoverMacro.build()) to all classes/packages referenced
	* 
	* From the command line/hxml add a macro reference:
	*	--macro mcover.MCover.include('package.name', ['src'], null)
	* 
	* @param pack - package name to filter on (e.g. "com.example"). Use empty string to match all classes ('')
	* @param classPaths - zero or more classpaths to include in coverage (defaults to local scope only (''))
	* @param ignore - array of qualified classe names to exclude from coverage
	**/
	public static function include( pack : String, ?classPaths : Array<String>, ?ignore : Array<String> )
	{
		includePackage(pack, classPaths, ignore);
	
		for(i in 0...Lambda.count(classHash))
		{
			debug("    " + classHash.get(i));
		}

		haxe.macro.Context.onGenerate(massive.mcover.macro.CoverClassMacro.onGenerate);
	}

	/**
	* Recursively loops through classpaths and appends @:build metadata into each matching class
	* @param pack - package name to filter on (e.g. "com.example"). Use empty string to match all classes ('')
	* @param classPaths - zero or more classpaths to include in coverage (defaults to local scope only (''))
	* @param ignore - array of classes to exclude from coverage
	*/
	static function includePackage(pack : String, ?classPaths : Array<String>, ?ignore : Array<String>)
	{
		var skip = if(null == ignore) {
			function(c) return false;
		} else {
			function(c) return Lambda.has(ignore, c);
		}

		if(null == classPaths)
			classPaths = [""];
		
		//normalize class paths
		for( i in 0...classPaths.length )
		{
			var cp = StringTools.replace(classPaths[i], "\\", "/");
		if(StringTools.endsWith(cp, "/"))
			cp = cp.substr(0, -1);
		
			classPaths[i] = cp;
			classPathHash.set(Lambda.count(classPathHash), cp);
		}
		
		var prefix = pack == '' ? '' : pack + '.';
		for( cp in classPaths ) {
			var path = pack == '' ? cp : cp + "/" + pack.split(".").join("/");

			if( !neko.FileSystem.exists(path) || !neko.FileSystem.isDirectory(path) )
				continue;
			
			for( file in neko.FileSystem.readDirectory(path) ) {
				if( StringTools.endsWith(file, ".hx") ) {
					var classes = getClassesInFile(path + "/" + file);
					for(cl in classes)
					{
						cl = prefix + cl;
						if( skip(cl) )
							continue;
						classHash.set(Lambda.count(classHash), cl);
						Compiler.addMetadata("@:keep @:build(massive.mcover.macro.CoverClassMacro.build())", cl);
					}
				} else if(neko.FileSystem.isDirectory(path + "/" + file) && !skip(prefix + file) )
					includePackage(prefix + file, classPaths, ignore);
			}
		}
	}

	static function getClassesInFile(path:String):Array<String>
	{
		var classes:Array<String> = [];
		var contents = neko.io.File.getContent(path);
		var reg:EReg = ~/^(.*)class ([A-Z]([A-Za-z0-9])+)/;

		while(reg.match(contents))
		{
			classes.push(reg.matched(2));
			contents = reg.matchedRight();
		}
		return classes;
	}

	static function debug(value:Dynamic, ?posInfos:haxe.PosInfos)
	{
		#if MCOVER_DEBUG
			neko.Lib.println(posInfos.fileName+ ":" + posInfos.lineNumber + ": " + value);
		#end
	}
	#end
}