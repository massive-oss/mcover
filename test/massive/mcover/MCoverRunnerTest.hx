package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.MCoverRunner;
import massive.mcover.MCover;

class MCoverRunnerTest
{
	var runner:MCoverRunner;
	var cover:MCover;
	var client:CoverageClient;

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
		cover = new MCover();
 		client = new CoverageClientMock();
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
		runner.initialize(cover, MCover.RESOURCE_DATA);
		Assert.areEqual(cover, runner.cover);
	}

	@AsyncTest
	public function shouldCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{
		var handler:Dynamic = factory.createHandler(this, reportCompletionHandler, 300);
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
		runner.destroy();

		Assert.areEqual(0, runner.getClients().length);

	}

	///////////////

	function createRunner()
	{
		return new MCoverRunnerMock();
	}
}
