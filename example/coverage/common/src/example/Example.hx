package example;

class Example
{
	@IgnoreCover
	static public function log(?cover:Null<Bool>=true, ?pos:haxe.PosInfos)
	{
		// var s = (cover ? "" : "! ") + pos.className + "." + pos.methodName + "(" + pos.lineNumber + ")";
		// trace(s);
	}

	public var fieldA:String;

	public function new()
	{
		covered();
		//notCovered();//isn't called so that reported as misssing coverage
		//notCoveredEmpty();//isn't called so that reported as misssing coverage
		//ignored();//isn't called, but ignored via @ignoreCover metadata

		ignoredExpr();

		ifMethod(true);
		ifMethod(false);

		elseIfMethod(0);
		elseIfMethod(1);
		elseIfMethod(2);

		switchMethod(0);
		switchMethod(1);
		switchMethod(2);

		tryCatch(false);
		tryCatch(true);

		forLoops();
		whileLoop();

		ternaryExpression(true);
		ternaryExpression(false);

		inlineFunction();
		
		branchBool(true, false);
		branchBool(false, true);
		branchBool(true, true);
		branchBool(false, false);

		branchInt(1, 0);
		branchInt(0, 1);
		branchInt(1, 1);

		var a = "a";
		var b = "b";

		branchString(a, b);
		branchString(a, a);

		branchFloat(1.1, 0.1);
		branchFloat(0.1, 1.1);
		branchFloat(1.1, 1.1);

		classInstances();
	}

	/**
	simple method that needs coverage
	*/
	function covered()
	{
		log();
	}


	/**
	method containing branch that isn't executed anywhere
	*/
	function notCovered(?value:Bool=false)
	{
		log(false);

		if (value)
		{
			log(false);
		}
	}

	/**
	Method ignored by coverage report becuase of metadata
	*/
	@IgnoreCover
	function ignored()
	{
		log(false);
	}

	/**
	Expr ignored by coverage report becuase of metadata
	*/
	function ignoredExpr()
	{
		@IgnoreCover if (false) log(false);
	}

	/**
	Empty method that isn't executed anywhere
	*/
	function notCoveredEmpty()
	{}

	/**
	various exressions that don't require coverage (ie fields and array instantiation)
	*/
	function notCoverable(?value:Bool=true)
	{
		var i = 0;

		var o = {
			a:"a",
			b:"b"
		}

		var a = [1,2,3];
	}

	function ifMethod(?value:Bool=false)
	{
		if (value)
		{
			log();
		}
		else
		{
			log();
		}
	}

	function elseIfMethod(?value:Int=0)
	{
		if (value == 0)
		{
			log();
		}
		else if (value == 1)
		{
			log();
		}
		else
		{
			log();
		}
	}

	function switchMethod(?value:Int)
	{
		switch (value)
		{
			case 0: log();
			case 1: log();
			default: log();
		}	
	}

	function tryCatch(?value:Bool=false)
	{
		try
		{
			log();
			if (value == true)
			{
				throw ("exception");
			}
		}
		catch(e:Dynamic)
		{
			log();
		}
	}

	function whileLoop()
	{
		var i = 0;
		while (i < 2)
		{
			i++;
		}

		//i = 0;
		while (i < 2) //note: will never be true (ie. i == 2)
		{
			if (i == 1) break;
			i++;
		}
	}

	function forLoops()
	{
		for (i in 0...5)
		{
			log();
		}

		var a:Array<Int> = [1,2,3,4,5];

		for (i in a)
		{
			log();
		}
	}

	function ternaryExpression(?value:Bool=true)
	{
		var n = value ? 4 : 5;
	}

	function inlineFunction()
	{
		var f = function()
		{
			log();
		}

		f();
	}
	function branchBool(a:Bool, b:Bool)
	{
		if (a || b)
		{
			log();
		}

		if (a == b)
		{
			log();
		}

		if (a != b)
		{
			log();
		}

		if (a && b)
		{
			log();
		}
	}

	function branchInt(a:Int, b:Int)
	{
		if (a == b)
		{
			log();
		}
		if (a != b)
		{
			log();
		}

		if (a < b)
		{
			log();
		}

		if (a <= b)
		{
			log();
		}

		if (a > b)
		{
			log();
		}

		if (a >= b)
		{
			log();
		}
	}
	function branchString(a:String, b:String)
	{
		if (a == b)
		{
			log();
		}
		if (a != b)
		{
			log();
		}
	}

	function branchFloat(a:Float, b:Float)
	{
		if (a == b)
		{
			log();
		}
		if (a != b)
		{
			log();
		}

		if (a < b)
		{
			log();
		}

		if (a <= b)
		{
			log();
		}

		if (a > b)
		{
			log();
		}

		if (a >= b)
		{
			log();
		}
	}

	function classInstances()
	{
		var internalInst = new InternalClass();

		var internalIgnoredInst = new InternalClassWithIgnore();

		var privateInst = new PrivateClass();

		var privateIgnoredInst = new PrivateClassWithIgnore();

		// var e2 = new example.Example2();
		// var e = cast(e2, example.Example);
	}
}

class InternalClass
{
	public function new()
	{
		Example.log();
	}
}

@IgnoreCover
class InternalClassWithIgnore
{
	public function new()
	{
		Example.log(false);
	}
}

private class PrivateClass
{
	public function new()
	{
		Example.log();
	}
}

@IgnoreCover
private class PrivateClassWithIgnore
{
	public function new()
	{
		Example.log(false);
	}
}