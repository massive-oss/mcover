package;

import massive.mcover.MCover;
import massive.mcover.CoverageLogger;


class Main
{
	static var logger:CoverageLogger;

	static var completed:Bool = false;

	@IgnoreCover
	static public function main()
	{
		logger = MCover.getLogger();
		var app = new Main();
		logger.completionHandler = completionHandler;
		logger.report();

		#if neko
		while(completed != true)
		{
			neko.Sys.sleep(.1);

		}
		#end


	}
	@IgnoreCover
	static function completionHandler(percent:Float)
	{
		completed = true;
	}

	static public function here(?posInfos:haxe.PosInfos)
	{
		#if MCOVER_DEBUG
		//trace(Std.string(posInfos));
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
		otherTypes();
		branchTests();
		
	
	}


	function branchTests()
	{
		branchBool(true, false);
		branchBool(false, true);
		branchBool(true, true);
		branchBool(false, false);

		branchInt(1, 0);
		branchInt(0, 1);
		branchInt(1, 1);
	}


	function forLoops()
	{
		for(i in 0...5)
		{
			here();
		}

		var a:Array<Int> = [1,2,3,4,5];

		for(i in a)
		{
			here();
		}
	}
	function branchBool(a:Bool, b:Bool)
	{
		if(a || b)
		{
			here();
		}

		if(a == b)
		{
			here();
		}

		if(a != b)
		{
			here();
		}

		if(a && b)
		{
			here();
		}
	}

	function branchInt(a:Int, b:Int)
	{
		if(a == b)
		{
			here();
		}
		if(a != b)
		{
			here();
		}

		if(a < b)
		{
			here();
		}

		if(a <= b)
		{
			here();
		}

		if(a > b)
		{
			here();
		}

		if(a >= b)
		{
			here();
		}
	}
	function branchString(a:String, b:String)
	{
		if(a == b)
		{
			here();
		}
		if(a != b)
		{
			here();
		}
	}

	function branchFloat(a:Float, b:Float)
	{
		if(a == b)
		{
			here();
		}
		if(a != b)
		{
			here();
		}

		if(a < b)
		{
			here();
		}

		if(a <= b)
		{
			here();
		}

		if(a > b)
		{
			here();
		}

		if(a >= b)
		{
			here();
		}
	}


	function otherTypes()
	{
		var exmpl = new example.Example();

		var internal = new InternalClass();

		example.foo.Foo.bar();

		var f:example.foo.Foo<String> = new example.foo.Foo("hello");


		var fe = new example.foo.FooExtended<Int>(1);

		var n = (1 + 1 == 2) ? 4 : 5;

		var o = {
			a:"a",
			b:"b"
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

		i = 0;
		while(i < 2)
		{
			i++;
			break;
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