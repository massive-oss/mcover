package;

import mcover.coverage.MCoverage;
import mcover.coverage.CoverageLogger;
import example.Example;
import sys.io.File;
import sys.FileSystem;


/**
Main class as @IgnoreCover meta to ensure it is not included in the coverage
**/
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
		#if sys
			while (!completed)
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