package massive.mcover;

import massive.mcover.data.Package;
import massive.mcover.data.File;
import massive.mcover.data.Clazz;
import massive.mcover.data.Method;
import massive.mcover.data.Branch;
import massive.mcover.data.Statement;
import massive.mcover.data.AbstractNode;
import massive.mcover.data.AbstractBlock;
import massive.mcover.data.AbstractNodeList;
import massive.mcover.data.AllClasses;
import massive.mcover.data.CoverageResult;

#if !macro
import massive.mcover.MCoverRunner;
import massive.mcover.CoverageClient;
import massive.mcover.MCoverException;

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
*    createRunner();
*/
@:keep class MCover
{
	static public var RESOURCE_DATA:String = "MCoverData";

	#if !macro
	
	static public var instance(default, null):MCover;

	#if neko

	static public var mutex:neko.vm.Mutex = new neko.vm.Mutex();

	public var statementQueue(default, null):Deque<Int>;
	public var branchQueue(default, null):Deque<BranchResult>;

	#else

	public var statementQueue(default, null):Array<Int>;
	public var branchQueue(default, null):Array<BranchResult>;

	#end

	public var runner(default, null):MCoverRunner;


	/*
	 * total execution count for statements by id
	*/
	var statementResultsById:IntHash<Int>;
	
	/*
	 * total execution summary for branches by id
	*/
	var branchResultsById:IntHash<BranchResult>;

	public var allClasses(default, null):AllClasses;

	@IgnoreCover
	public static function getInstance():MCover
	{
		#if neko mutex.acquire(); #end
		if(instance == null)
		{
			instance = new MCover();
		}
		#if neko mutex.release(); #end
		return instance;
	}
	
	@IgnoreCover
	public function new()
	{
		#if neko
		statementQueue = new Deque();
		branchQueue = new Deque();
		#else
		statementQueue = [];
		branchQueue = [];
		#end

		statementResultsById = new IntHash();
		branchResultsById = new IntHash();
	}

	public function createRunner(?runnerClass:Class<MCoverRunner>=null, overwrite:Bool=false):MCoverRunner
	{
		#if neko mutex.acquire(); #end
		if(runner != null)
		{
			if(!overwrite)
			{
				#if neko mutex.release(); #end
				throw new MCoverException("Runner already exists. Set overwrite to true to replace runner.");
			}

			runner.destroy();
			runner = null;
		}

		if(allClasses == null)
		{
			loadAllClasses();	
		}

		if(runnerClass == null) runnerClass =MCoverRunnerImpl;

		runner = Type.createInstance(runnerClass, []);
		runner.initialize(this, allClasses);

		#if neko mutex.release(); #end
		return runner;
	}

	public function loadAllClasses(?resourceName:String = null)
	{
		if(resourceName == null) resourceName = MCover.RESOURCE_DATA;
		var serializedData:String = haxe.Resource.getString(resourceName);
		if(serializedData == null) throw new MCoverException("No generated coverage data found in haxe Resource '" + resourceName  + "'");
		try
		{
			allClasses = haxe.Unserializer.run(serializedData);
			allClasses.setStatementResultsHash(statementResultsById);
			allClasses.setBranchResultsHash(branchResultsById);
		}
		catch(e:Dynamic)
		{
			throw new MCoverException("Unable to unserialize coverage data in " + resourceName, e);
		}
	}

	/**
	* Method called from injected code each time a code block executes. 
	* Developers should not class this method directly.
	**/
	@IgnoreCover
	public function logStatement(id:Int)
	{	
		#if neko mutex.acquire(); #end
		var count = 1;

		if(statementResultsById.exists(id))
		{
			count = statementResultsById.get(id) + 1;
		}

		statementResultsById.set(id, count);

		if(count == 1)
		{
			#if neko
			statementQueue.add(id);
			#else
			statementQueue.unshift(id);
			#end
		}
		#if neko mutex.release(); #end
	}
	
	/**
	* Method called from injected code each time a binary operation resolves to true or false 
	* Developers should not class this method directly.
	**/
	@IgnoreCover
	public function logBranch(id:Int, value:Bool):Bool
	{
		#if neko mutex.acquire(); #end

		var r:BranchResult = null;
		
		if(branchResultsById.exists(id))
		{
			r = branchResultsById.get(id);

		}
		else
		{
			r = {id:id, value:false, result:"00", trueCount:0, falseCount:0, total:0};
			branchResultsById.set(id, r);
		}

		//record current value
		if(value) r.trueCount ++;
		else r.falseCount ++;

		r.total ++;
		
		var changed = false;
			
		if(r.result == "11")
		{
			//both true and false have already been logged
		}
		else if(value && r.result.charAt(0) == "0")
		{
			//log true
			r.result = "1" + r.result.substr(1,1);
			changed = true;
		}
		else if(!value && r.result.charAt(1) == "0")
		{
			//log false
			r.result = r.result.substr(0,1) + "1";
			changed = true;
		}

		if(changed)
		{
			var copy = copyBranchResult(r);
			copy.value = value;
			#if neko
			branchQueue.add(copy);
			#else
			branchQueue.unshift(copy);
			#end
		}

		#if neko mutex.release(); #end
		return value;
	}

	public function getNextBranchResultFromQueue():BranchResult
	{
		var result:BranchResult = null; 

		#if neko
		mutex.acquire();
		result = branchQueue.pop(false);
		mutex.release();
		#else
		result = branchQueue.pop();
		#end

		return result;
	}

	public function getNextStatementFromQueue():Null<Int>
	{

		var result:Null<Int> = null;
		#if neko 
		mutex.acquire();
		result = statementQueue.pop(false);
		mutex.release();
		#else
		result = statementQueue.pop();
		#end
	
		return result;
	}


	function copyBranchResult(r:BranchResult):BranchResult
	{
		if(r == null) return null;

		return {id:r.id, value:r.value, result:r.result.toString(), trueCount:r.trueCount, falseCount:r.falseCount, total:r.total};
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

