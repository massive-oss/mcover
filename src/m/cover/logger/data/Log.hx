package m.cover.logger.data;
import haxe.PosInfos;

@IgnoreLogging
class Log
{
	public var id:Int;
	public var name(get_name, null):String;

	public var children:Array<Log>;

	//call stack depth
	public var depth:Int;

	public var entryPos:PosInfos;
	public var exitPos:PosInfos;
	
	//timestamp
	public var entryTime:Float;
	public var exitTime(default, set_exitTime):Float;

	/**
	Total time method was running (exitTime-entryTime)
	*/
	public var totalDuration:Float;

	/**
	Time taken directly (not inclusive of other methods)
	*/
	public var internalDuration:Float;

	/**
	Indicates that log didn't exit properly (ie didn't catch an exception from a nested function)
	*/
	public var skipped:Bool;
	
	/**
	Indicates log refers to an inline function (not a class method)
	*/
	public var inlined:Bool;

	public function new(id:Int)
	{
		this.id = id;
		inlined = false;
		skipped = false;
		totalDuration = 0;
		internalDuration = 0;
		children = [];
	}

	public function toString():String
	{
		return name + " (" + Utils.round(totalDuration) + ", " + Utils.round(internalDuration) + ")";
	}

	public function enter(pos:PosInfos, time:Float, depth:Int)
	{
		entryPos = pos;
		entryTime = time;
		this.depth = depth;
	}

	public function exit(pos:PosInfos, time:Float)
	{
		exitPos = pos;
		exitTime = time;
		totalDuration = exitTime-entryTime;
		
		skipped = pos == null;


		internalDuration = totalDuration;

		for(child in children)
		{
			internalDuration -= child.totalDuration;
		}
	}


	function get_name():String
	{
		if(name == null)
		{
			if(entryPos == null) return null;

			name = entryPos.className + "/" + entryPos.methodName;
			if(inlined) name += "/function_" + entryPos.lineNumber;
		}
		return name;
	}

	function set_exitTime(value:Float):Float
	{
		exitTime = value;
		
		return value;
	}
}
