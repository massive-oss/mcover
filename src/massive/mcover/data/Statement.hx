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


	///////////

	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(count);
    }
    
    override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        count = s.unserialize();
    }
}