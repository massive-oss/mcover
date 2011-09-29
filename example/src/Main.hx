package;

import massive.mcover.MCover;
import massive.mcover.MCoverRunner;


//@:build(mcover.MCoverMacro.build())
class Main
{
	@IgnoreCover
	static public function main():Main
	{
		MCover.createRunner();
		var app = new Main();	
		MCover.report();
		return app;
	}

	static public function here(?posInfos:haxe.PosInfos)
	{
		#if MCOVER_DEBUG
		trace(Std.string(posInfos));
		#end
	}

	public var fieldA:String;

	public function new()
	{
		methodA();

		ifMethod(true);
		ifMethod(false);

		elseIfMethod(0);
		elseIfMethod(1);
		elseIfMethod(2);

		switchMethod(0);
		switchMethod(1);
		switchMethod(2);

		ignore();

		tryCatch(false);
		tryCatch(true);

		var exmpl = new example.Example();

		var internal = new InternalClass();

		example.foo.Foo.bar();

		var f = new example.foo.Foo();

	}

	public function methodA()
	{
		here();
	}
	public function ifMethod(?value:Bool=false)
	{
		if(value)
		{
			here();
		}
		else
		{
			here();
		}
	}

	public function elseIfMethod(?value:Int=0)
	{
		if(value == 0)
		{
			here();
		}
		else if (value == 1)
		{
			here();
		}
		else
		{
			here();
		}
	}

	public function switchMethod(?value:Int)
	{
		switch(value)
		{
			case 0: here();
			case 1: here();
			default: here();
		}	
	}

	public function tryCatch(?value:Bool=false)
	{
		try
		{
			here();
			if(value == true)
			{
				throw ("exception");
			}
		}
		catch(e:Dynamic)
		{
			here();
		}
	}

	@IgnoreCover
	public function ignore()
	{
		here();
	}

}

class InternalClass
{
	public function new()
	{
		Main.here();
	}
}

@IgnoreCover class InternalClassWithIgnore
{
	public function new()
	{
		Main.here();
	}
}