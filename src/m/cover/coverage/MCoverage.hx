package m.cover.coverage;

#if neko
import neko.vm.Deque;
#end

import m.cover.coverage.CoverageLogger;

class MCoverage
{
	static public var RESOURCE_DATA:String = "MCoverData";

	#if neko
		static public var mutex:neko.vm.Mutex;
	#end

	static public var logger(default, null):CoverageLogger;

	
	@IgnoreCover
	public static function getLogger():CoverageLogger
	{
		#if neko
			if(mutex == null) mutex = new neko.vm.Mutex();
		 	mutex.acquire();
		#end
		if(logger == null)
		{
			logger = new CoverageLoggerImpl();
		}
		#if neko mutex.release(); #end
		return logger;
	}

	@IgnoreCover
	function new()
	{
		
	}
}