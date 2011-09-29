package example;

@IgnoreCover
class Example2
{
	public function new()
	{
		testA();
		testB();
	}

	public function testA()
	{
		Main.here();
	}

	function testB()
	{
		Main.here();
	}
}