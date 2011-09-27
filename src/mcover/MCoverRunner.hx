package mcover;

@:keep class MCoverRunner
{
	static public var VERBOSE_OUTPUT:Bool = true;
	static public var instance:MCoverRunner = new MCoverRunner();

	static public function cover(value:String)
	{	
		instance.add(value);
	}

	static public function printResults():String
	{
		trace("A");
		return instance.print();
	}


	var targetHash:Hash<Bool>;
	var hash:Hash<Bool>;
	
	public function new():Void
	{

		targetHash = new Hash();
		hash = new Hash();

		parseTargetHash();
	}

	public function add(value:String)
	{
		//trace(value);
		hash.set(value, true);
	}

	public function print():String
	{
	
		var total:Int = 0;
		var count:Int = 0;
		var missing:Array<String> = [];
		for(key in targetHash.keys())
		{
			total ++;
			if(hash.exists(key) && hash.get(key) == true) count ++;
			else missing.push(key);
		}

		var percent:Float = Math.round(count/total*1000)/10;
		var result:String = "";

		var divider:String = "----------------------------------------------------";

		if(VERBOSE_OUTPUT)
		{
			result += "\n" + divider + "\n" + "MCOVER RESULTS" + "\n" + divider + "\nMissing Blocks: \n" + missing.join("\n	") + "\n";
		}

		result +=  "\n" + divider + "\nMCover COVERAGE: " + percent + "% (" + count + "/" + total + " code blocks executed)";
		return result;
	}

	function parseTargetHash()
	{
		var file = haxe.Resource.getString("MCover");
		var lines = file.split("\n");

		for(line in lines)
		{
			targetHash.set(line, false);
		}
	}
}