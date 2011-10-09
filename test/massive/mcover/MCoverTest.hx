package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.MCoverRunner;
import massive.mcover.MCover;
import massive.mcover.data.AllClasses;
import massive.mcover.data.Branch;

class MCoverTest
{
	var cover:MCover;
	var runner:MCoverRunner;
	var runner2:MCoverRunner;


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
		cover = new MCover();
	}
	
	@After
	public function tearDown():Void
	{
		if(runner != null)
		{
			runner.destroy();
		}

		if(runner2 != null)
		{
			runner2.destroy();
		}
	}

	@Test
	public function shouldGetDefaultInstance()
	{
		cover = MCover.getInstance();
		Assert.areEqual(MCover.instance, cover);
	}

	@Test
	public function shouldCreateDefaultRunnerIfNonExisting()
	{
		runner = cover.createRunner();
		Assert.isNotNull(runner);
		Assert.areEqual(MCoverRunnerImpl, Type.getClass(runner));
		
	}

	@Test
	public function shouldThrowExceptionIfOverwritingRunnerWithoutFlag()
	{
		try
		{
			runner = cover.createRunner(MCoverRunnerMock);
			runner = cover.createRunner(MCoverRunnerMock);
			Assert.fail("Expected MCoverException for overwriting existing runner cover");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldCreateNewDefaultRunner()
	{
		runner = cover.createRunner(MCoverRunnerMock);
		runner2 = cover.createRunner(null, true);

		Assert.isNotNull(runner2);
		Assert.areEqual(MCoverRunnerImpl, Type.getClass(runner2));
		Assert.areNotEqual(runner, runner2);
		Assert.isTrue(cast(runner, MCoverRunnerMock).isDestroyed);
	}

	@Test
	public function shouldCreateCustomerRunner()
	{
		runner = cover.createRunner(MCoverRunnerMock);
		Assert.areEqual(MCoverRunnerMock,  Type.getClass(runner));
	}

	@Test
	public function shouldInitializeAllClassesWhenRunnerAdded()
	{
		Assert.isNull(cover.allClasses);
		runner = cover.createRunner(MCoverRunnerMock);
		Assert.isNotNull(cover.allClasses);
	}

	@Test
	public function shouldNotReInitializeAllClassesWhenRunnerAdded()
	{
		cover.loadAllClasses();
		var allClasses = cover.allClasses;

		runner = cover.createRunner(MCoverRunnerMock);
		Assert.areEqual(allClasses, cover.allClasses);
	}

	@Test
	public function shouldInitializeRunnerWithCoverAndAllClassesOnRunner()
	{
		runner = cover.createRunner(MCoverRunnerMock);
		Assert.areEqual(cover, runner.cover);
		Assert.areEqual(cover.allClasses, cast(runner, MCoverRunnerMock).allClasses);
	}

	@Test
	public function shouldAddUniqueStatementtoQueue()
	{
		var id = 0;
		cover.loadAllClasses();
		cover.logStatement(id);
		Assert.isTrue(cover.allClasses.statementResultsById.exists(id));
		Assert.areEqual(1, cover.allClasses.statementResultsById.get(id));
		Assert.areEqual(id, cover.getNextStatementFromQueue());
		Assert.isNull(cover.getNextStatementFromQueue());
	}

	@Test
	public function shouldIncrementExistingStatementButNotAddToQueue()
	{
		var id = 0;
		cover.loadAllClasses();
		cover.logStatement(id);
		cover.logStatement(id);
		Assert.isTrue(cover.allClasses.statementResultsById.exists(id));
		Assert.areEqual(2, cover.allClasses.statementResultsById.get(id));
		Assert.areEqual(id, cover.getNextStatementFromQueue());
		Assert.isNull(cover.getNextStatementFromQueue());
	}

	@Test
	public function shouldAddStatementsToQueueInOrder()
	{
		var id1 = 0;
		var id2 = 1;
		cover.logStatement(id1);
		cover.logStatement(id2);
		Assert.areEqual(id1, cover.getNextStatementFromQueue());
		Assert.areEqual(id2, cover.getNextStatementFromQueue());
	}

	@Test
	public function shouldGetNullStatementFromQueue()
	{
		var id = cover.getNextStatementFromQueue();
		Assert.isNull(id);
	}

	@Test
	public function shouldLoadAllClasses()
	{
		Assert.isNull(cover.allClasses);
		cover.loadAllClasses();
		Assert.isNotNull(cover.allClasses);
	}

	@Test
	public function shouldThrowExceptionIfNoMatchingResource()
	{
		try
		{
			cover.loadAllClasses("InvalidMCoverResourceName");
			Assert.fail("Exception expected");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);

		}
	}

	@Test
	public function shouldThrowExceptionForInvalidResource()
	{
		try
		{
			cover.loadAllClasses("MockMCoverResource");
			Assert.fail("Exception expected");
		}
		catch(e:MCoverException)
		{
			Assert.isTrue(true);

		}
	}

	@Test
	public function shouldAddUniqueBranchResultToQueue()
	{
		var id1 = 0;
		cover.loadAllClasses();
		cover.logBranch(id1, true);
		Assert.isTrue(cover.allClasses.branchResultsById.exists(id1));

		var cachedResult = copyBranchResult(cover.allClasses.branchResultsById.get(id1));
		Assert.areEqual(0, cachedResult.id);

		var result1 = cover.getNextBranchResultFromQueue();

		assertBranchResultsAreEqual(cachedResult, result1);

		Assert.isTrue(result1.value);
		Assert.areEqual("10", result1.result);
		Assert.areEqual(1, result1.trueCount);
		Assert.areEqual(0, result1.falseCount);
		Assert.areEqual(1, result1.total);

		var id2 = 1;
		cover.logBranch(id2, false);

		var result2 = cover.getNextBranchResultFromQueue();

		Assert.areEqual(id2, result2.id);
		Assert.isFalse(result2.value);
		Assert.areEqual("01", result2.result);
		Assert.areEqual(0, result2.trueCount);
		Assert.areEqual(1, result2.falseCount);
		Assert.areEqual(1, result2.total);
		result2 = cover.getNextBranchResultFromQueue();
		Assert.isNull(result2);
	}

	@Test
	public function shouldAddBranchesToQueueInOrder()
	{
		var id1 = 0;
		var id2 = 1;
		cover.logBranch(id1, true);
		cover.logBranch(id2, true);

		Assert.areEqual(id1, cover.getNextBranchResultFromQueue().id);
		Assert.areEqual(id2, cover.getNextBranchResultFromQueue().id);
	}

	@Test
	public function shouldIncrementCountButNotAddExistingBranchResultToQueue()
	{
		var id1 = 0;
		cover.logBranch(id1, true);
		var result1 = cover.getNextBranchResultFromQueue();

		cover.logBranch(id1, true);

		var result2 = cover.getNextBranchResultFromQueue();
		Assert.isNull(result2);
	}	

	@Test
	public function shouldAddAlternateBranchResultToQueue()
	{
		var id1 = 0;
		cover.logBranch(id1, true);
		var result1 = cover.getNextBranchResultFromQueue();

		cover.logBranch(id1, false);
		var result2 = cover.getNextBranchResultFromQueue();
		Assert.isNotNull(result2);


		Assert.areEqual(result1.id, result2.id);
		Assert.isFalse(result2.value);
		Assert.areEqual("11", result2.result);
		Assert.areEqual(1, result2.trueCount);
		Assert.areEqual(1, result2.falseCount);
		Assert.areEqual(2, result2.total);
	}

	@Test
	public function getNextBranchResultFromQueue()
	{
		var result = cover.getNextStatementFromQueue();
		Assert.isNull(result);
	}

	//////////////////////////

	function copyBranchResult(r:BranchResult):BranchResult
	{
		if(r == null) return null;

		return {id:r.id, value:r.value, result:r.result.toString(), trueCount:r.trueCount, falseCount:r.falseCount, total:r.total};
	}

	function assertBranchResultsAreEqual(r1:BranchResult, r2:BranchResult, ?includeValue:Bool=false)
	{
		Assert.areEqual(r1.id, r2.id);
		Assert.areEqual(r1.result, r2.result);
		Assert.areEqual(r1.trueCount, r2.trueCount);
		Assert.areEqual(r1.falseCount, r2.falseCount);
		Assert.areEqual(r1.total, r2.total);
		
		if(includeValue)
		{
			Assert.areEqual(r1.value, r2.value);
		}			
	}
	
}