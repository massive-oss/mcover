package massive.mcover;

/**
* Reprents a unique code block {} within an application
* Contains a number of properties relating to it's location and context.
*/
class CodeBlock
{
	public var id:Int;
	public var file:String;
	public var packageName:String;
	public var className:String;
	public var qualifiedClassName:String;
	public var methodName:String;

	
	public var min:Int;
	public var max:Int;
	public var location:String;

	public var count:Int;


	public function new()
	{
		count = 0;
	}

	public function hasCount():Bool
	{
		return count > 0;
	}


	public function toString():String
	{
		return qualifiedClassName + "#" + methodName + " | " + location;
	}
}