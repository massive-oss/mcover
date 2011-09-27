package mcover;

class CoverageEntryCollection
{
	public var name:String;
	public var entries:IntHash<CoverageEntry>;
	public var count(get_count, null):Int;
	public var total(get_total, null):Int;
	public var percent(get_percent, null):Int;
	public function new(name:String)
	{
		this.name = name;
		entries = new IntHash();	
	}

	public function addEntry(entry:CoverageEntry)
	{
		for ( elem in entries)
		{
    		if(elem == entry) throw "Entry aleady exists in result " + entry;
    	}

		entries.set(Lambda.count(entries), entry);
	}

	public function get_percent():Int
	{
		return Math.round(count/total*100);
	}

	function get_count():Int
	{
		var n = 0;
		for ( elem in entries)
		{
    		if(elem.result) n++;

    	}
    	return n;
	}

	function get_total():Int
	{
		return Lambda.count(entries);
	}
}