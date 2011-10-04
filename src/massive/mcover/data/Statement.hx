package massive.mcover.data;

@:keep class Statement extends AbstractBlock
{
	public var count:Int;

	public function new()
	{
		super();
		count = 0;
	}

	override public function isCovered():Bool
	{
		return count > 0;
	}
}