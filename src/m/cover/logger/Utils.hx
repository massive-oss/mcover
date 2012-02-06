package m.cover.logger;

class Utils
{
	/**
	 *	Returns a timestamp, in seconds
	 */

	public static function stamp():Float
	{
		return inlineStamp();
	}

	inline public static function inlineStamp()
	{
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif neko
			return neko.Sys.time();
		#elseif php
			return php.Sys.time();
		#elseif js
			return Date.now().getTime() / 1000;
		#elseif cpp
			return untyped __time_stamp();
		#else
			return 0;
		#end
	}


	static public function formatTime(value:Float, ?decimalCount:Int=4, ?length:Int = 8, ?char:String=" "):String
	{
		value = Utils.round(value, decimalCount);
		return StringTools.rpad(Std.string(value), char, length);
	}


	static public function round(value:Float, ?precision:Int=4):Float
	{
		value = value * Math.pow(10, precision);
		return Math.round(value) / Math.pow(10, precision);
	}
	
}