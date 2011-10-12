package example;

@IgnoreCover
class Example2 extends Example
{
	public function new()
	{
		super();
		testC();
	
	}

	public function testC()
	{
		Main.here();
	}

}