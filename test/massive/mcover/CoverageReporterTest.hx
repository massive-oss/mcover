package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.CoverageReporter;
import massive.mcover.CoverageLogger;
import massive.mcover.data.AllClasses;

class CoverageReporterTest
{
	var runner:CoverageReporter;
	var logger:CoverageLogger;
	var client:CoverageReportClient;
	var allClasses:AllClasses;

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
		runner = createRunner();
		logger = new CoverageLoggerMock();
 		client = new CoverageReportClientMock();
 		allClasses = new AllClasses();
	}
	
	@After
	public function tearDown():Void
	{
		if(runner != null)
		{
			runner.destroy();	
		}	
	}


	@Test
	public function shouldInitialize()
	{
		initializeRunner();
		Assert.areEqual(logger, runner.logger);
	}

	@AsyncTest
	public function shouldCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{	
		initializeRunner();
		var handler:Dynamic = factory.createHandler(this, reportCompletionHandler, 700);
		runner.completionHandler = handler;
		runner.report();
	}

	function reportCompletionHandler(percent:Float)
	{
		Assert.isNotNull(percent);
	}

	@Test
	public function shouldAddAndRemoveClient()
	{
		runner.addClient(client);

		Assert.areEqual(1, runner.getClients().length);
		Assert.areEqual(client, runner.getClients()[0]);

		runner.removeClient(client);
		Assert.areEqual(0, runner.getClients().length);
	}

	@Test
	public function shouldDestroy()
	{
		runner.addClient(client);
		runner.destroy();
		Assert.areEqual(0, runner.getClients().length);

	}

	///////////////

	function createRunner():CoverageReporter
	{
		return new CoverageReporterMock();
	}

	function initializeRunner()
	{
		runner.initialize(logger, allClasses);
		runner.addClient(client);
	}
}
