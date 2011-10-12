package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.Coverage;
import massive.mcover.CoverageReportClientMock;
import massive.mcover.CoverageReportClient;


class CoverageReportClientTest
{
	var client:CoverageReportClient;
	var coverage:Coverage;
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
		coverage = new Coverage();
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
		client.report(coverage);
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
