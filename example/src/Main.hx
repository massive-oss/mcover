package;

//@:build(mcover.MCoverMacro.build())
class Main
{
	static public function main():Main
	{
		var app = new Main();	
		
		mcover.MCoverRunner.report();

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
		mock();
	}
	public function ifMethod(?value:Bool=false)
	{
		if(value)
		{
			mock();
		}
		else
		{
			mock();
		}
	}

	public function elseIfMethod(?value:Int=0)
	{
		if(value == 0)
		{
			mock();
		}
		else if (value == 1)
		{
			mock();
		}
		else
		{
			mock();
		}
	}

	public function switchMethod(?value:Int)
	{
		switch(value)
		{
			case 0: mock();
			case 1: mock();
			default: mock();
			
		}
		
	}

	function mock(?posInfos:haxe.PosInfos)
	{
		//trace(posInfos);
	}
}