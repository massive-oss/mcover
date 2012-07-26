package;

import m.cover.coverage.MCoverage;
import m.cover.coverage.CoverageLogger;
import example.Example;

#if haxe_208
	#if neko
	import neko.Sys;
	#elseif cpp
	import cpp.Sys;
	#elseif php
	import php.Sys;
	#end
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
	}

}