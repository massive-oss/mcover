package massive.mcover;

class CodeBlock
{
	public var key(default, set_key):String;
	public var id(default, null):Int;
	public var filePath(default, null):String;
	public var packageName(default, null):String;
	public var className(default, null):String;
	public var qualifiedClassName(default, null):String;
	public var methodName(default, null):String;

	
	public var min(default, null):Int;
	public var max(default, null):Int;
	public var location(default, null):String;

	public var count:Int;
	public var result(get_result, null):Bool;

	/**
	* generate a result object based on a key for the block in the following format:
	*		id|filePath|package|class name|method name|min character|max character|summary
	* examples:
	*		1|src/Main.hx||Main|new|1012|1161|src/Main.hx:72: lines 72-78
	*		2|src/example/Example.hx|example|Example|doSomething|160|174|src/example/Example.hx:18: characters 2-16
	**/
	
	public function new(value:String)
	{
		key = value;
		//parse(key);
	}

	function set_key(value:String)
	{
		key = value;
		parse(key);
		return key;
	}

	function get_result():Bool
	{
		return count > 0;
	}


	function parse(key:String)
	{
		var a = key.split("|");
		if(a.length != 8) throw "Invalid block format: " + key;

		id = Std.parseInt(a[0]);
		filePath = a[1];
		packageName = a[2];
		className = a[3];
		qualifiedClassName = (packageName != "" ? packageName + "." : "") + className;
		methodName = a[4];
		min = Std.parseInt(a[5]);
		max = Std.parseInt(a[6]);
		location = a[7];
		count = 0;
	}

	function hxSerialize( s : haxe.Serializer )
	{
        key = toString();
        s.serialize(key);
    }
    function hxUnserialize( s : haxe.Unserializer )
    {
        key = s.unserialize();
    }

	public function toString():String
	{
		var parts:Array<Dynamic> = [id, filePath, packageName, className, methodName, min, max, location];
		return parts.join("|");
	}
}


