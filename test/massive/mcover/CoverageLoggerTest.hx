package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.AllClasses;


class CoverageLoggerTest
{
	var logger:CoverageLogger;
	var client:CoverageReportClient;
	var allClasses:AllClasses;

	var originalTrace:Dynamic;


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
		client = new CoverageReportClientMock();
 		allClasses = new AllClasses();

	}
	
	@After
	public function tearDown():Void
	{
		if(originalTrace != null)
		{
			haxe.Log.trace = originalTrace;
		}
	}

	@Test
	public function shouldCreateAllClassesOnInitializeAllClasses()
	{
		logger.initializeAllClasses(MCover.RESOURCE_DATA);
		Assert.isNotNull(logger.allClasses);
	}


	@AsyncTest
	public function shouldCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{	
		logger.addClient(client);
		var handler:Dynamic = factory.createHandler(this, reportCompletionHandler, 700);
		logger.completionHandler = handler;
		logger.report();
	}

	function reportCompletionHandler(percent:Float)
	{
		Assert.isNotNull(percent);
	}

	@Test
	public function shouldAddAndRemoveClient()
	{
		logger.addClient(client);

		Assert.areEqual(1, logger.getClients().length);
		Assert.areEqual(client, logger.getClients()[0]);

		logger.removeClient(client);
		Assert.areEqual(0, logger.getClients().length);
	}


	/////////////


	function createLogger():CoverageLogger
	{
		return new CoverageLoggerMock();
	}

}
