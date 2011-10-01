package;

import massive.mcover.MCover;
import massive.mcover.MCoverRunner;


//@:build(mcover.MCoverMacro.build())
class Main
{
	static var runner:MCoverRunner;

	@IgnoreCover
	static public function main():Main
	{
		runner = MCover.createRunner();
		var app = new Main();

		keepAlive();
		runner.report();
		return app;
	}

	@IgnoreCover
	static public function keepAlive()
	{
		#if neko
		var i:Int = 0;
		while(i<5)
		{
			neko.Sys.sleep(.01);
			i++;
		}
		#end
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

		whileLoop();

		var exmpl = new example.Example();

		var internal = new InternalClass();

		example.foo.Foo.bar();

		var f = new example.foo.Foo();

		var n = (1 + 1 == 2) ? 4 : 5;

		var o = {
			a:"a",
			b:"b"
		}

		for(i in 0...5)
		{
			here();
		}

		var f = function()
		{
			here();
		}


		var e2 = new example.Example2();
		var e = cast(e2, example.Example);

		var a = [1,2,3];
	}

	function methodA()
	{
		here();
	}
	function ifMethod(?value:Bool=false)
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

	function elseIfMethod(?value:Int=0)
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

	function switchMethod(?value:Int)
	{
		switch(value)
		{
			case 0: here();
			case 1: here();
			default: here();
		}	
	}

	function tryCatch(?value:Bool=false)
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

	function whileLoop()
	{
		var i = 0;
		while(i < 2)
		{
			i++;
		}
	}

	@IgnoreCover
	function ignore()
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