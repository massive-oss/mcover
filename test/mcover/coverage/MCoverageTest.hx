package mcover.coverage;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class MCoverageTest
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
	public function shouldGetDefaultLogger()
	{
		var logger:CoverageLogger = MCoverage.getLogger();
		Assert.areEqual(MCoverage.logger, logger);
	}
}