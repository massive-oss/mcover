package massive.mcover;

class CoverageData
{
	public var blocks:IntHash<CodeBlock>;
	public var packages:Hash<CoverageDataSet>;
	public var files:Hash<CoverageDataSet>;
	public var classes:Hash<CoverageDataSet>;

	public var total(get_total, null):Int;
	function get_total():Int
	{
		return Lambda.count(blocks);
	}

	public var count:Int;

	public var percent(get_percent, null):Float;
	function get_percent():Float
	{
		return Math.round(count/total*1000)/10;
	}

	public function new()
	{
		blocks = new IntHash();
		count = 0;

		packages = new Hash();
		files = new Hash();
		classes = new Hash();
	}
}

class CoverageDataSet
{
	public var id:Int;
	public var name:String;

	public var count:Int;
	public var total(get_total, null):Int;
	function get_total():Int
	{
		return Lambda.count(blocks);
	}

	public var percent(get_percent, null):Int;
	public function get_percent():Int
	{
		return Math.round(count/total*100);
	}
	/**
	* List of block IDs (avoids circular reference to actual block objects in haxe.Serializer)
	*/
	public var blocks:Array<Int>;

	public function new(id:Int, name:String)
	{
		this.id = id;
		this.name = name;

		count = 0;
		
		blocks = new Array();
	}

	public function addBlock(block:CodeBlock)
	{
		blocks.push(block.id);
	}

	

}


