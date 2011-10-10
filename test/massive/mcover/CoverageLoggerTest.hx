package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;


class CoverageLoggerTest
{
	var logger:CoverageLogger;


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
		logger = createLogger();

	}
	
	@After
	public function tearDown():Void
	{

	}

	@Test
	public function shouldCreateReporter()
	{
		logger.createReporter();
		Assert.isNotNull(logger.reporter);
	}


	@Test
	public function shouldCreateAllClassesOnLoadAllClasses()
	{
		logger.loadAllClasses(MCover.RESOURCE_DATA);
		Assert.isNotNull(logger.allClasses);
	}

	/////////////

	function createLogger():CoverageLogger
	{
		return new CoverageLoggerMock();
	}

}
