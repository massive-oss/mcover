package massive.mcover;

import massive.mcover.CodeBlock;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class CodeBlockTest 
{	

	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function shouldHaveCount():Void
	{
		var block = new CodeBlock();
		Assert.areEqual(0, block.count);
		Assert.isFalse(block.hasCount());
		block.count ++;
		Assert.isTrue(block.hasCount());
	}

	@Test
	public function testToString():Void
	{
		var block = new CodeBlock();
		block.qualifiedClassName = "a";
		block.methodName = "b";
		block.location = "c";

		Assert.areEqual("a#b | c", block.toString());
	}
}