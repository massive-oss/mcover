package;

import massive.munit.util.Timer;
import massive.munit.Assert;

class ExampleTest
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
	public function testThatTracesAndPasses()
	{
		trace("this is a trace that passes");
		Assert.isTrue(true);
	}

	@Test
	public function testThatTracesAndFails()
	{
		trace("this is a trace that fails");
		Assert.isTrue(false);
	}

	
	@Ignore
	@Test
	public function testThatIsIgnored()
	{
		Assert.isTrue(false);
	}

	@Test
	public function testThatFails()
	{
		Assert.isTrue(false);
	}

	@Test("This is a description")
	public function testThatFailsWithDescription()
	{
		Assert.isTrue(false);
	}

}