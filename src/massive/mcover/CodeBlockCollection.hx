package massive.mcover;

class CodeBlockCollection
{
	public var name:String;
	public var blocks:IntHash<CodeBlock>;
	public var count(get_count, null):Int;
	public var total(get_total, null):Int;
	public var percent(get_percent, null):Int;
	public function new(name:String)
	{
		this.name = name;
		blocks = new IntHash();
	}

	public function addBlock(block:CodeBlock)
	{
		for ( elem in blocks)
		{
    		if(elem == block) throw "Block aleady exists in result " + blocks;
    	}

		blocks.set(Lambda.count(blocks), block);

		
	}

	public function get_percent():Int
	{
		return Math.round(count/total*100);
	}

	function get_count():Int
	{
		var n = 0;
		for ( block in blocks)
		{
    		if(block.result) n++;

    	}
    	return n;
	}

	function get_total():Int
	{
		return Lambda.count(blocks);
	}
}
