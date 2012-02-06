package m.cover.coverage;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import m.cover.coverage.CoverageLogger;
import m.cover.MCover;
import m.cover.coverage.data.Coverage;
import m.cover.coverage.data.Branch;

import m.cover.coverage.client.TraceClient;

class CoverageLoggerImplTest extends CoverageLoggerTest
{
	var instance:CoverageLoggerImpl;
	var client2:CoverageReportClient;
	var hasCompletedReport:Bool;

	public function new()
	{
		super();
	}

	@BeforeClass
	override public function beforeClass():Void
	{
		super.beforeClass();
	}
	
	@AfterClass
	override public function afterClass():Void
	{
		super.afterClass();
	}
	
	@Before
	override public function setup():Void
	{
		super.setup();
		instance = new CoverageLoggerImpl();
	
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();

	}

	@Test
	public function shouldAddClientCompletionHandlerWhenAddedToRunner()
	{
		instance.addClient(client);
		Assert.isNotNull(client.completionHandler);
	}

	@Test
	public function shouldNotAddSameClientTwice()
	{
		instance.addClient(client);
		instance.addClient(client);
		Assert.areEqual(1, instance.getClients().length);
	}

	@Test
	public function shouldRemoveClientCompletionHandlerWhenRemovedFromRunner()
	{
		instance.addClient(client);
		instance.removeClient(client);
		Assert.isNull(client.completionHandler);
	}



	@Test
	public function shouldAddCoverageToClientOnReport()
	{
		instance.addClient(client);
		instance.report();

		var mockClient = cast(client, CoverageReportClientMock);
		Assert.isNotNull(mockClient.coverage);
	}

	@Test
	public function shouldNotUpdateClientIfSkipClientsIsTrue()
	{
		instance.addClient(client);
		instance.report(true);

		var mockClient = cast(client, CoverageReportClientMock);
		Assert.isNull(mockClient.coverage);
	}


	@Test
	public function shouldCreateDefaultClientIfNonAvailable()
	{
	
		originalTrace = haxe.Log.trace;
		haxe.Log.trace = function(value:Dynamic,?infos : haxe.PosInfos){};

		Assert.areEqual(0, instance.getClients().length);

		instance.report();

		haxe.Log.trace = originalTrace;


		var clients = instance.getClients().concat([]);

		Assert.areEqual(1, clients.length);
		Assert.areEqual(TraceClient, Type.getClass(clients[0]));
	}

	@AsyncTest
	public function shouldOnlyExecuteCompletionHandlerAfterAllClientsHaveCompleted(factory:AsyncFactory)
	{
		instance.addClient(client);
		client2 = new CoverageReportClientMock();

		instance.addClient(client2);

		var handler:Dynamic = factory.createHandler(this, reportCompletionHandler, 500);

		instance.completionHandler = handler;
		instance.report();
	}
	
	/**
	* This test is a bit pointless, but it is to ensure branch coverage when completionHandler is null
	*/
	@AsyncTest
	public function shouldNotCallCompletionHandlerIfNoneSet(factory:AsyncFactory)
	{
		instance.addClient(client);

		var handler:Dynamic = factory.createHandler(this, reportCompletionHandlerHasntExecuted, 500);

		Timer.delay(handler, 200);

		instance.report();
	}


	function reportCompletionHandlerHasntExecuted()
	{
		Assert.isTrue(true);
	}


	@Test
	public function shouldInitializeCoverageOnReport()
	{
		instance.addClient(client);
		Assert.isNull(instance.coverage);
		
		instance.report();
		Assert.isNotNull(instance.coverage);		
	}

	@Test
	public function shouldNotReInitializeCoverageWhenRunnerAdded()
	{
		instance.addClient(client);
		instance.initializeCoverage();
		var coverage = instance.coverage;

		instance.report();
		Assert.areEqual(coverage, instance.coverage);
	}

	

	@Test
	public function shouldInitializeCoverage()
	{
		Assert.isNull(instance.coverage);
		instance.initializeCoverage();
		Assert.isNotNull(instance.coverage);
	}

	@Test
	public function shouldThrowExceptionIfNoMatchingResource()
	{
		try
		{
			instance.initializeCoverage("InvalidMCoverResourceName");
			Assert.fail("Exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);

		}
	}

	@Test
	public function shouldThrowExceptionForInvalidResource()
	{
		try
		{
			instance.initializeCoverage("MockMCoverResource");
			Assert.fail("Exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);

		}
	}

	@Test
	public function shouldThrowExceptionIfCurrentTestIsNull()
	{
		try
		{
			instance.reportCurrentTest();
			Assert.fail("exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);
		}	
	}

	@Test
	public function shouldOnlyReportLogsSinceCurrentTestWasSet()
	{
		var mockClient = cast(client, CoverageReportClientMock);
		
		instance.addClient(client);
		
		instance.logStatement(0);
		instance.logBranch(0, true);
		instance.currentTest = "foo";

		instance.reportCurrentTest();

		Assert.areEqual(0, mockClient.coverage.getPercentage());

		instance.logStatement(1);
		instance.logBranch(0, false);

		instance.reportCurrentTest();

		Assert.isTrue(mockClient.coverage.getPercentage() > 0);

		instance.currentTest = "bar";
		
		instance.reportCurrentTest();

		Assert.areEqual(0, mockClient.coverage.getPercentage());


	}


	@Test
	public function shouldNotUpdateClientIfReportCurrentTestSkipClientsIsTrue()
	{
		instance.addClient(client);
		instance.currentTest = "foo";
		instance.logStatement(0);
		instance.reportCurrentTest(true);

		var mockClient = cast(client, CoverageReportClientMock);
		Assert.isNull(mockClient.coverage);
	}


	//////////////////////////

	function copyBranchResult(r:BranchResult):BranchResult
	{
		if(r == null) return null;

		return {id:r.id, trueCount:r.trueCount, falseCount:r.falseCount, total:r.total};
	}

	function assertBranchResultsAreEqual(r1:BranchResult, r2:BranchResult)
	{
		Assert.areEqual(r1.id, r2.id);
		Assert.areEqual(r1.trueCount, r2.trueCount);
		Assert.areEqual(r1.falseCount, r2.falseCount);
		Assert.areEqual(r1.total, r2.total);
			
	}


	/////////////
	override function createLogger():CoverageLogger
	{
		return new CoverageLoggerImpl();
	}
}