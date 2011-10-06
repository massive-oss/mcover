package massive.mcover.data;

/**
* Reprents a unique code block {} within an application
* Contains a number of properties relating to it's location and context.
*/
@:keep class AbstractBlock extends AbstractNode
{
	public var file:String;
	
	public var packageName:String;
	public var className:String;
	public var qualifiedClassName:String;
	public var methodName:String;

	public var min:Int;
	public var max:Int;

	public var location:String;

	public var lookup:Array<Int>;

	function new()
	{
		super();
	}

	public function isCovered():Bool
	{
		return false;
	}

	public function toString():String
	{
		return qualifiedClassName + "#" + methodName + " | " + location;
	}

	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(file);
        s.serialize(packageName);
        s.serialize(className);
        s.serialize(qualifiedClassName);
        s.serialize(methodName);
        s.serialize(min);
        s.serialize(max);
        s.serialize(location);
        s.serialize(lookup);
     } 

    override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        file = s.unserialize();
        packageName = s.unserialize();
        className = s.unserialize();
        qualifiedClassName = s.unserialize();
        methodName = s.unserialize();
        min = s.unserialize();
        max = s.unserialize();
        location = s.unserialize();
        lookup = s.unserialize();
    }

}