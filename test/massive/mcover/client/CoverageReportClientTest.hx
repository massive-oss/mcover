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
		var handler:Dynamic = factory.createHandler(this, assertCompletionCountIsOne, 1000);
		
		completionCount = 0;
		client.completionHandler = clientCompleteHandler;
		client.report(coverage);

		Timer.delay(handler, 400);
	}
	
	@AsyncTest
	public function shouldNotCallCompletionHandlerAfterReport(factory:AsyncFactory)
	{	

		var handler:Dynamic = factory.createHandler(this, assertCompletionCountIsZero, 1000);

		completionCount = 0;
		client.completionHandler = null;
		client.report(coverage);

		Timer.delay(handler, 400);
	}

	function clientCompleteHandler(c:CoverageReportClient)
	{
		completionCount ++;	
	}


	function assertCompletionCountIsOne()
	{
		Assert.areEqual(1, completionCount);
	}


	function assertCompletionCountIsZero()
	{
		Assert.areEqual(0, completionCount);
	}


	////////////

	function createClient():CoverageReportClient
	{
		return new CoverageReportClientMock();
	}
}
