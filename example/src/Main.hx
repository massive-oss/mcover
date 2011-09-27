package;

//@:build(mcover.MCoverMacro.build())
class Main
{
	static public function main():Main
	{
		var app = new Main();
		
		mcover.MCoverRunner.VERBOSE_OUTPUT = true;
		trace(mcover.MCoverRunner.printResults());

		return app;
	}

	public var fieldA:String;

	public function new()
	{

		methodA();

		//ifMethod(true);
		//ifMethod(false);

		//elseIfMethod(0);
		elseIfMethod(1);
		elseIfMethod(2);

		switchMethod(0);
		switchMethod(1);
		switchMethod(2);

		var example = new example.Example();

	}

	public function methodA()
	{
		trace("method A");
	}
	public function ifMethod(?value:Bool=false)
	{
		if(value)
		{
			trace("ifMethod if " + value);
		}
		else
		{
			trace("ifMethod else " + value);	
		}
	}

	public function elseIfMethod(?value:Int=0)
	{
		if(value == 0)
		{
			trace("ifElseMethod if " + value);
		}
		else if (value == 1)
		{
			trace("ifElseMethod elseif " + value);	
		}
		else
		{
			trace("ifElseMethod else " + value);	
		}
	}

	public function switchMethod(?value:Int)
	{
		switch(value)
		{
			case 0: trace("switch 0 " + value);
			case 1: trace("switch 1 " + value);
			default: trace("switch default " + value);
			
		}
		
	}
}