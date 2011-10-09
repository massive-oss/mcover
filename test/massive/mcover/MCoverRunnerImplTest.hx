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


	@AsyncTest
	public function shouldTriggerDelayedUpdateAfterInitialize(factory:AsyncFactory)
	{	
		initializeRunner();

		var statement = addStatementToAllClasses(0);
		cover.logStatement(statement.id);

		var handler:Dynamic = factory.createHandler(this, verifyUpdateTriggeredByInitialize, 500);
		Timer.delay(handler, 100);
	}

	function verifyUpdateTriggeredByInitialize()
	{
		var mockClient = cast(client, CoverageClientMock);

		Assert.isNotNull(mockClient.statement);
		Assert.areEqual(0, mockClient.statement.id);
		Assert.isNull(cover.getNextStatementFromQueue());
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
	public function shouldLogOustandingStatementsFromCoverOnUpdate()
	{
		initializeRunner();

		var statement = addStatementToAllClasses(0);
		cover.logStatement(statement.id);

		instance.forceUpdate();

		var mockClient = cast(client, CoverageClientMock);

		Assert.isNotNull(mockClient.statement);
		Assert.areEqual(0, mockClient.statement.id);
		Assert.isNull(cover.getNextStatementFromQueue());
	}

	@Test
	public function shouldLogOustandingBranchesFromCoverOnUpdate()
	{
		initializeRunner();

		var branch = addBranchToAllClasses(0);
		cover.logBranch(branch.id, true);

		instance.forceUpdate();

		var mockClient = cast(client, CoverageClientMock);

		Assert.isNotNull(mockClient.branch);
		Assert.areEqual(0, mockClient.branch.id);
		Assert.isNull(cover.getNextBranchResultFromQueue());
	}

	@Test
	public function shouldOnlyGenerateReportIfAllBranchesAndStatementsHaveBeenLogged()
	{
		var mockClient = cast(client, CoverageClientMock);

		var branch = addBranchToAllClasses(0);
		var statement = addStatementToAllClasses(0);

		initializeRunner();
		instance.maxLogsToParsePerTick = 2;

		cover.logStatement(statement.id);
		cover.logBranch(branch.id, true);
		instance.report();

		instance.forceUpdate();
		Assert.isNull(mockClient.allClasses);

		instance.forceUpdate();
		Assert.isNotNull(mockClient.allClasses);
	}

	@Test
	public function shouldThrowExceptionIfNotInitializedBeforeCallingUpdate()
	{
		try
		{
			var statement = addStatementToAllClasses(0);
			cover.logStatement(statement.id);
			instance.forceUpdate();	
			Assert.fail("expected MCoverException");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldThrowExceptionIfStatementNotRegistered()
	{
		try
		{
			runner.initialize(cover, new AllClasses());
			cover.logStatement(0);
			instance.forceUpdate();	
			Assert.fail("expected MCoverException");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldThrowExceptionIfBranchNotRegistered()
	{
		try
		{
			runner.initialize(cover, new AllClasses());
			cover.logBranch(0, true);
			instance.forceUpdate();	
			Assert.fail("expected MCoverException");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldIncrementCountOnStatement()
	{
		initializeRunner();
		var statement = addStatementToAllClasses(0);
		cover.logStatement(statement.id);
		instance.forceUpdate();
		Assert.areEqual(1, statement.count);
	}

	@Test
	public function shouldIncrementCountOnBranch()
	{
		initializeRunner();
		var branch = addBranchToAllClasses(0);

		Assert.areEqual(0, branch.trueCount);
		Assert.areEqual(0, branch.falseCount);

		cover.logBranch(branch.id, true);
		instance.forceUpdate();

		Assert.areEqual(1, branch.trueCount);
		Assert.areEqual(0, branch.falseCount);

		cover.logBranch(branch.id, false);
		instance.forceUpdate();

		Assert.areEqual(1, branch.trueCount);
		Assert.areEqual(1, branch.falseCount);
	}

	@Test
	public function shouldCreateDefaultClientIfNonAvailable()
	{
		initializeRunner();
		instance.removeClient(client);

		Assert.areEqual(0, instance.getClients().length);

		var originalTrace = haxe.Log.trace;
		haxe.Log.trace = function(value:Dynamic,?infos : haxe.PosInfos){};
		
		instance.report();
		instance.forceUpdate();

		haxe.Log.trace = originalTrace;

		Assert.areEqual(1, instance.getClients().length);
		Assert.areEqual(TraceClient, Type.getClass(instance.getClients()[0]));
	}

	///////////////

	function addStatementToAllClasses(?id:Int=0):Statement
	{
		var statement = NodeMock.createStatement();
		statement.id = id;
		allClasses.addStatement(statement);
		return statement;
	}

	function addBranchToAllClasses(?id:Int=0):Branch
	{
		var branch = NodeMock.createBranch();
		branch.id = id;
		allClasses.addBranch(branch);
		return branch;
	}

	override function createRunner():MCoverRunner
	{
		return new MCoverRunnerImpl();
	}
}
