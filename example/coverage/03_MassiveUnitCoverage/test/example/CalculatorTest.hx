package example;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import example.Calculator;

/**
* Auto generated MassiveUnit Test Class  for example.Calculator 
*/
class CalculatorTest 
{
	var instance:Calculator; 
	
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
	public function shouldAddValues():Void
	{
		var a = 1;
		var b = 10;

		Assert.areEqual(11, Calculator.add(a, b));
	}

	@Test
	public function shouldReturn10():Void
	{
		var a = 10;
		var b = 1;

		Assert.areEqual(a, Calculator.greatestValue(a, b));
	}
}