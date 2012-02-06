package m.cover.coverage.munit.client;
import massive.munit.client.RichPrintClient;

class RichPrintClientHelperMock extends massive.munit.client.RichPrintClientHelper
{
	public var queue:Array<String>;
	public var prints:Array<String>;
	public var printLines:Array<String>;
	public function new()
	{
		super();
		queue = [];
		prints = [];
		printLines = [];
	}

	override public function print(value:String)
	{
		prints.push(value);
	}

	override public function printLine(value:String)
	{
		printLines.push(value);
	}

	override function addToQueue(method:String, ?args:Array<Dynamic>):Bool
	{
		var jsCode = convertToJavaScript(method, args);
		queue.push(jsCode);
		return true;
	}
}
