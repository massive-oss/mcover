package massive.mcover;

#if !macro
import massive.mcover.MCoverRunner;
import massive.mcover.CoverageClient;
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
*    createRunner();
*    report();
*    addClient(new CoverageClient());
*/
class MCover
{
	#if !macro

	static public var runner(default, null):MCoverRunner;
	static public var logQueue:Array<String> = [];
	static public var clientQueue:Array<CoverageClient> = [];
	static public var reportPending:Bool = false;
	
	static public function createRunner(?inst:MCoverRunner=null)
	{
		if(runner != null)
		{
			runner.remove();
		}

		if(inst == null)
		{
			inst = new MCoverRunnerImpc();
		}
		runner = inst;
	}

	/**
	* Trigger runner to calculate coverage and pass results to registered clients.
	* Note: actual reporting occurs asyncronously in registered clients;
	**/
	static public function report()
	{
		reportPending = true;
	}

	/**
	 * Add one or more coverage clients to interpret coverage results.
	 * 
	 * @param clientsa  client to interpret coverage results 
	 * @see massive.mcover.CoverageClient
	 * @see massive.mcover.client.PrintClient
	 */
	static public function addClient(client:CoverageClient):Void
	{
		clientQueue.push(client);
	}


	/**
	* Method called from injected code each time a code block executes. 
	* Developers should not class this method directly.
	**/
	@IgnoreCover
	static public function log(value:String)
	{	
		logQueue.push(value);
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
			//if(reg.matched(1).indexOf("@IgnoreCover"))
			//trace(reg.matched(1));
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
