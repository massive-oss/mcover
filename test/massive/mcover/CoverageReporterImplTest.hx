package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.CoverageReporter;

import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.AllClasses;

import massive.mcover.data.NodeMock;
import massive.mcover.client.TraceClient;

class CoverageReporterImplTest extends CoverageReporterTest
{
	var instance:CoverageReporterImpl;
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
		instance = cast(runner, CoverageReporterImpl);
	
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
	public function shouldRemoveClientHandlerOnDestroy()
	{
		instance.addClient(client);
		instance.destroy();
		Assert.isNull(client.completionHandler);
		Assert.areEqual(0, instance.getClients().length);
	}
	@Test
	public function shouldThrowExceptionIfNotInitializedWithCover()
	{
		instance.initialize(null, null);
		try
		{
			instance.report();	
			Assert.fail("expected Exception");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldThrowExceptionIfNotInitializedWithAllClasses()
	{
		instance.initialize(logger, null);
		try
		{
			instance.report();	
			Assert.fail("expected Exception");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);
		}
	}
	
	@Test
	public function shouldAddAllClassesToClientOnReport()
	{
		initializeRunner();
		instance.report();

		var mockClient = cast(client, CoverageReportClientMock);
		Assert.isNotNull(mockClient.allClasses);
	}

	@Test
	public function shouldCreateDefaultClientIfNonAvailable()
	{
		instance.initialize(logger, allClasses);


		var originalTrace = haxe.Log.trace;
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
		initializeRunner();
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
		initializeRunner();
		
		var handler:Dynamic = factory.createHandler(this, reportCompletionHandlerHasntExecuted, 500);

		Timer.delay(handler, 200);
		instance.report();
	}


	function reportCompletionHandlerHasntExecuted()
	{
		Assert.isTrue(true);
	}

	///////////////

	override function createRunner():CoverageReporter
	{
		return new CoverageReporterImpl();
	}
}
