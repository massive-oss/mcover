package mcover.coverage.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.coverage.data.Coverage;
import mcover.coverage.CoverageReportClientMock;
import mcover.coverage.CoverageReportClient;

class CoverageReportClientTest
{
	var client:CoverageReportClient;
	var coverage:Coverage;
	var completionCount:Int;

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
		completionCount = 0;
	}
	
	@After
	public function tearDown():Void
	{
		
	}

	@AsyncTest
	public function shouldCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{	
		completionCount = 0;
		client.completionHandler = clientCompleteHandler;
		client.report(coverage);

		var handler:Dynamic = factory.createHandler(this, assertCompletionCountIsOne, 1000);

		Timer.delay(handler, 1);
	}
	
	function clientCompleteHandler(c:CoverageReportClient)
	{
		completionCount ++;	
	}

	function assertCompletionCountIsOne()
	{
		Assert.areEqual(1, completionCount);
	}

	////////////

	function createClient():CoverageReportClient
	{
		return new CoverageReportClientMock();
	}
}
