package massive.mcover.data;

@:keep class Branch extends AbstractBlock
{
	public var trueCount:Int;
	public var falseCount:Int;

	public function new()
	{
		super();
		trueCount = 0;
		falseCount = 0;
	}

	override public function isCovered():Bool
	{
		return trueCount > 0 && falseCount > 0;
	}

	override public function toString():String
	{
		var s:String = super.toString();
		if(!isCovered())
		{
			s += " | ";
			if(trueCount == 0) s += "t";
			if(trueCount == 0 && falseCount == 0) s +=",";
			if(falseCount == 0) s += "f";
		
		}
		return s;
	}
}