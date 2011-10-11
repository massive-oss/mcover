package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import massive.mcover.CoverageLogger;
import massive.mcover.MCover;
import massive.mcover.data.AllClasses;
import massive.mcover.data.Branch;

import massive.mcover.client.TraceClient;

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
	public function shouldAddAllClassesToClientOnReport()
	{
		instance.addClient(client);
		instance.report();

		var mockClient = cast(client, CoverageReportClientMock);
		Assert.isNotNull(mockClient.allClasses);
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
	public function shouldInitializeAllClassesOnReport()
	{
		instance.addClient(client);
		Assert.isNull(instance.allClasses);
		
		instance.report();
		Assert.isNotNull(instance.allClasses);		
	}

	@Test
	public function shouldNotReInitializeAllClassesWhenRunnerAdded()
	{
		instance.addClient(client);
		instance.loadAllClasses();
		var allClasses = instance.allClasses;

		instance.report();
		Assert.areEqual(allClasses, instance.allClasses);
	}

	

	@Test
	public function shouldLoadAllClasses()
	{
		Assert.isNull(instance.allClasses);
		instance.loadAllClasses();
		Assert.isNotNull(instance.allClasses);
	}

	@Test
	public function shouldThrowExceptionIfNoMatchingResource()
	{
		try
		{
			instance.loadAllClasses("InvalidMCoverResourceName");
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
			instance.loadAllClasses("MockMCoverResource");
			Assert.fail("Exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);

		}
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