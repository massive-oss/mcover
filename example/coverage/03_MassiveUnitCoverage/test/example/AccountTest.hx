package example;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import example.Account;

/**
* Auto generated MassiveUnit Test Class  for example.Account 
*/
class AccountTest 
{
	var instance:Account; 
	
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
	public function shouldBeEmptyAtConstructor():Void
	{
		instance = new Account();
		Assert.areEqual(0, instance.totalValue());
	}

	@Test
	public function shouldAddValueToTotal()
	{
		instance = new Account();
		instance.add(10);
		instance.add(1);
		Assert.areEqual(11, instance.totalValue());
	}
	@Test
	public function shouldDouble()
	{
		instance = new Account();
		Assert.areEqual(4, instance.double(2));
	}
}