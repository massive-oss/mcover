package mcover;

class CoverageEntry
{
	public var key(default, null):String;
	public var id(default, null):Int;
	public var classPath(default, null):String;
	public var packageName(default, null):String;
	public var className(default, null):String;
	public var min(default, null):Int;
	public var max(default, null):Int;
	public var location(default, null):String;


	public var count:Int;
	public var result(get_result, null):Bool;


	/**
	* generate a result object based on a key for the entry in the following format:
	*		id|classPath|package|class name|min character|max character|summary
	* examples:
	*		1|src||Main|1012|1161|src/Main.hx:72: lines 72-78
	*		2|src|example|Example|160|174|src/example/Example.hx:18: characters 2-16
	**/

	public function new(key:String)
	{
		this.key = key;

		var a = key.split("|");
		if(a.length != 7) throw "Invalid entry format: " + key;

		id = Std.parseInt(a[0]);
		classPath = a[1];
		packageName = a[2];
		className = a[3];
		min = Std.parseInt(a[4]);
		max = Std.parseInt(a[5]);
		location = a[6];
		count = 0;
	}

	function get_result():Bool
	{
		return count > 0;
	}

	public function toString():String
	{
		var parts:Array<Dynamic> = [id,classPath,packageName,className,min,max,location];
		return parts.join("|");
	}
}