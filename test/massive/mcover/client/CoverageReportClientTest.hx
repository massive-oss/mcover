package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.AllClasses;
import massive.mcover.CoverageReportClientMock;
import massive.mcover.CoverageReportClient;


class CoverageReportClientTest
{
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
		client = createClient();
		allClasses = new AllClasses();
	}
	
	@After
	public function tearDown():Void
	{
		
	}

	@AsyncTest
	public function shouldCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{	
		var handler:Dynamic = factory.createHandler(this, clientCompleteHandler, 500);
		client.completionHandler = handler;
		client.report(allClasses);
	}
	
	function clientCompleteHandler(c:CoverageReportClient)
	{
		Assert.areEqual(client, c);
	}
	////////////

	function createClient():CoverageReportClient
	{
		return new CoverageReportClientMock();
	}
}
