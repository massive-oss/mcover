package;

import mcover.coverage.MCoverage;
import mcover.coverage.CoverageLogger;
import example.Example;

#if haxe_208
	#if neko
	import neko.Sys;
	import neko.io.File;
	import neko.FileSystem;
	#elseif cpp
	import cpp.Sys;
	import cpp.io.File;
	import cpp.FileSystem;
	#elseif php
	import php.Sys;
	import php.io.File;
	import php.FileSystem;
	#end
#elseif sys
	import sys.io.File;
	import sys.FileSystem;
#end


/**
Main class as @IgnoreCover meta to ensure it is not included in the coverage
*/
@IgnoreCover
class Main
{
	static var logger:CoverageLogger;
	static var completed:Bool = false;
	
	static public function main()
	{
		//execute appliction code
		var example = new Example();

		logger = MCoverage.getLogger();
		logger.completionHandler = completionHandler;
		logger.report();//print report to screen

		#if (neko||cpp||php)
			while(completed != true)
			{
				Sys.sleep(.1);
			}
		#end
	}

	static function completionHandler(percent:Float)
	{
		completed = true;
		trace("Coverage report complete: " + percent + "%");

		#if sys
			var serializedData = haxe.Serializer.run(logger.coverage);

			if(!FileSystem.exists(".temp/mcover")) FileSystem.createDirectory(".temp/mcover");
			if(!FileSystem.exists(".temp/mcover/data")) FileSystem.createDirectory(".temp/mcover/data");
			#if neko
				File.saveContent(".temp/mcover/data/neko.mcover", serializedData);
			#elseif cpp
				File.saveContent(".temp/mcover/data/cpp.mcover", serializedData);
			#elseif php
				File.saveContent(".temp/mcover/data/php.mcover", serializedData);
			#end
		#end
		
	}

}
