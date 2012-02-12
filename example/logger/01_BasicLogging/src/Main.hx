package;

import m.cover.logger.MCoverLogger;
import m.cover.logger.Logger;
import example.Example;

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

		#if neko
			while(completed != true)
			{
				neko.Sys.sleep(.1);
			}
		#end
	}

	static function completionHandler(logger:Logger)
	{
		completed = true;
		trace("Logging report complete");
		
	}

}