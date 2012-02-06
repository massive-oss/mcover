package m.cover.logger;

#if neko
import neko.vm.Deque;
#end
import m.cover.logger.Logger;
import m.cover.logger.LoggerImpl;

@IgnoreLogging
class MLogger
{
	#if neko
		static public var mutex:neko.vm.Mutex;
	#end

	static public var logger(default, null):Logger;

	public static function getLogger():Logger
	{
		#if neko
			if(mutex == null) mutex = new neko.vm.Mutex();
		 	mutex.acquire();
		#end
		if(logger == null)
		{
			logger = new LoggerImpl();
		}
		#if neko mutex.release(); #end
		return logger;
	}

	function new()
	{
		
	}
}