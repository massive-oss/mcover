package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.MCoverRunner;
import massive.mcover.MCover;
@Ignore
class MCoverTest
{
	var cover:MCover;

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
	}


	@Test
	public function shouldGetDefaultInstance()
	{
		cover = MCover.getInstance();
		Assert.areEqual(MCover.instance, cover);
	}
/*
	@Test
	@Ignore("Breaks coverage")
	public function shouldCreateDefaultRunnerIfNonExisting()
	{
		var runner = cover.createRunner();
		Assert.isNotNull(runner);
		Assert.areEqual(MCoverRunnerImpc, Type.getClass(runner));
	}

	@Test
	@Ignore("Breaks coverage")
	public function shouldThrowExceptionIfOverwritingRunnerWithoutFlag()
	{
		try
		{
			var runner = cover.createRunner();
			runner = cover.createRunner();
			Assert.fail("Expected exception for overwriting existing runner cover");
		}
		catch(e:String)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	@Ignore("Breaks coverage")
	public function shouldCreateNewDefaultRunner()
	{
		var runner = cover.createRunner();
		var runner2 = cover.createRunner(null, true);

		Assert.isNotNull(runner2);
		Assert.areEqual(MCoverRunnerImpc, Type.getClass(runner2));
		Assert.areNotEqual(runner, runner2);
	}

	@Test
	@Ignore("Breaks coverage")
	public function shouldCreateCustomerRunner()
	{
		var runner = new MCoverRunnerImpc();
		var runner2 = cover.createRunner(runner);
		Assert.areEqual(runner, runner2);
	}
*/
	@Test
	public function shouldAddUniqueStatementtoQueue()
	{
		var id = 0;
		cover.logStatement(id);
		Assert.isTrue(cover.statementById.exists(id));
		Assert.areEqual(1, cover.statementById.get(id));
		Assert.areEqual(id, cover.getNextStatementFromQueue());
		Assert.isNull(cover.getNextStatementFromQueue());
	}

	@Test
	public function shouldIncrementExistingStatementButNotAddToQueue()
	{
		var id = 0;
		cover.logStatement(id);
		cover.logStatement(id);
		Assert.isTrue(cover.statementById.exists(id));
		Assert.areEqual(2, cover.statementById.get(id));
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
	public function shouldAddUniqueBranchResultToQueue()
	{
		var id1 = 0;
		cover.logBranch(id1, true);
		Assert.isTrue(cover.branchById.exists(id1));
		

		var cachedResult = copyResult(cover.branchById.get(id1));
		Assert.areEqual(0, cachedResult.id);

		var result1 = cover.getNextBranchResultFromQueue();

		Assert.areEqual(cachedResult.id, result1.id);
		Assert.areEqual(id1, result1.id);
		Assert.areEqual("10", result1.result);
		Assert.areEqual(1, result1.trueCount);
		Assert.areEqual(0, result1.falseCount);
		Assert.areEqual(1, result1.total);

		var id2 = 1;
		cover.logBranch(id2, false);

		var result2 = cover.getNextBranchResultFromQueue();
		Assert.areEqual(id2, result2.id);
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
		Assert.areEqual("11", result2.result);
		Assert.areEqual(1, result2.trueCount);
		Assert.areEqual(1, result2.falseCount);
		Assert.areEqual(2, result2.total);
	}

	@Test
	public function shouldReturnCopyOfStatements()
	{
		var id = 0;
		cover.logStatement(id);
		var hash = cover.getCopyOfStatements();

		Assert.isTrue(hash.exists(id));
		Assert.areEqual(1, hash.get(id));	
	}

	@Test
	public function shouldReturnCopyOfBranchResults()
	{
		var id = 0;
		cover.logBranch(id, true);
		var hash = cover.getCopyOfBranches();

		Assert.isTrue(hash.exists(id));
		var result = hash.get(id);
		Assert.areEqual(id, result.id);	
	}

	//////////////////////////

	function copyResult(r:BranchResult):BranchResult
	{
		if(r == null) return null;

		return {id:r.id, result:r.result.toString(), trueCount:r.trueCount, falseCount:r.falseCount, total:r.total};
	}

	
}