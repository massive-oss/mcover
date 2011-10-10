package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.MCoverRunner;
import massive.mcover.MCover;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.AllClasses;

import massive.mcover.data.NodeMock;
import massive.mcover.client.TraceClient;

class MCoverRunnerImplTest extends MCoverRunnerTest
{
	var instance:MCoverRunnerImpl;
	
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
		instance = cast(runner, MCoverRunnerImpl);
	
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
			Assert.fail("expected MCoverException");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldThrowExceptionIfNotInitializedWithAllClasses()
	{
		instance.initialize(cover, null);
		try
		{
			instance.report();	
			Assert.fail("expected MCoverException");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}
	
	@Test
	public function shouldAddAllClassesToClientOnReport()
	{
		initializeRunner();
		instance.report();

		var mockClient = cast(client, CoverageClientMock);
		Assert.isNotNull(mockClient.allClasses);
	}

	@Test
	public function shouldCreateDefaultClientIfNonAvailable()
	{
		instance.initialize(cover, allClasses);


		var originalTrace = haxe.Log.trace;
		haxe.Log.trace = function(value:Dynamic,?infos : haxe.PosInfos){};

		Assert.areEqual(0, instance.getClients().length);

		instance.report();

		haxe.Log.trace = originalTrace;


		var clients = instance.getClients().concat([]);

		Assert.areEqual(1, clients.length);
		Assert.areEqual(TraceClient, Type.getClass(clients[0]));
	}

	///////////////

	override function createRunner():MCoverRunner
	{
		return new MCoverRunnerImpl();
	}
}
