package massive.mcover.data;

import massive.mcover.data.AbstractBlock;
import massive.mcover.data.Statement;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class StatementTest 
{	
	var statement:Statement;

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
		statement = new Statement();
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function shouldBeCoveredIfCountIncrements():Void
	{
		Assert.areEqual(0, statement.count);
		Assert.isFalse(statement.isCovered());
		statement.count ++;
		Assert.isTrue(statement.isCovered());
	}

	@Test
	public function testToString():Void
	{
		statement.qualifiedClassName = "a";
		statement.methodName = "b";
		statement.location = "c";

		Assert.areEqual("a#b | c", statement.toString());
	}
}