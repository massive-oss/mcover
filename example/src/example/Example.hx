package example;

class Example
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
		//trace(posInfos);
	}
}