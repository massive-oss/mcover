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
		mock();
	}

	function testB()
	{
		mock();
	}

	function mock(?posInfos:haxe.PosInfos)
	{
		
	}
}