package example;

class Example
{
	public var i:Int;


	public function new()
	{
		i = 0;
		emptyFunction();
		ignoredFunction();
		
		returnValue();
			
		returnValueOfOtherFunction(true);
		returnValueOfOtherFunction(false);
		
		try
		{
			throwException();
		}
		catch(e:Dynamic)
		{
			catchException();
		}

		nestedCallThrowsException();

		recurse();
	}

	/**
	simple method that needs coverage
	*/
	function emptyFunction()
	{
		
	}

	/**
	Method ignored by logging
	*/
	@IgnoreLogging
	function ignoredFunction()
	{
		
	}

	function returnValue():Int
	{
		return i;
		
	}

	function returnValueOfOtherFunction(?value:Bool=false)
	{
		return returnTrueOrFalse(value);
	}

	function returnTrueOrFalse(?value:Bool=false):Bool
	{
		if(value)
		{
			return true;
		}
		return false;
	}

	function throwException()
	{
		throw "exception";
	}

	function catchException()
	{
		try
		{
			throw "exception";
		}
		catch(e:Dynamic)
		{
			//
		}
	}

	function nestedCallThrowsException()
	{
		try
		{
			level2();
		}
		catch(e:Dynamic)
		{
			//
		}
	}

	function level2()
	{
		level3();
	}

	function level3()
	{
		throw "exception";
	}


	function recurse(depth:Int=0)
	{
		depth ++;
		if(depth <= 10)
		{
			i = 0;
			while(i < 5000)
			{
				i++;
			}
			recurse(depth);
		}
	}

}

class InternalClass
{
	public function new()
	{
		
	}
}

@IgnoreLogging
class InternalClassWithIgnore
{
	public function new()
	{
		
	}
}

private class PrivateClass
{
	public function new()
	{
		
	}
}

@IgnoreLogging
private class PrivateClassWithIgnore
{
	public function new()
	{
		
	}
}