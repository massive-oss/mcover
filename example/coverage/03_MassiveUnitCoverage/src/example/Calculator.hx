package example;

class Calculator 
{
	public function new(){}

	static public function add(a:Int, b:Int):Int
	{
		return a + b;
	}

	static public function greatestValue(a:Int, b:Int):Int
	{
		if (a > b) return a;
		return b;
	}
}