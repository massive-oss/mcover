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
}