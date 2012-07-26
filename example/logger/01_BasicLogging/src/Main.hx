package;

import m.cover.logger.MCoverLogger;
import m.cover.logger.Logger;
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
Main class as @IgnoreLogging meta to ensure it is not included in the coverage
*/
@IgnoreLogging
class Main
{
	static var completed:Bool = false;
	
	static public function main()
	{

		var logger = MCoverLogger.getLogger();
		logger.startRecording();
		//execute appliction code
		var example = new Example();

		logger.completionHandler = completionHandler;
		logger.report();//print report to screen

		#if (neko||cpp||php)
			while(completed != true)
			{
				Sys.sleep(.1);
			}
		#end
	}

	static function completionHandler(logger:Logger)
	{
		completed = true;
		trace("Logging report complete");
	}

}