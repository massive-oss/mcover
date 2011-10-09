package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.AllClasses;
import massive.mcover.CoverageClient;
import massive.mcover.data.NodeMock;
import massive.mcover.data.Branch;


class PrintClientTest extends CoverageClientTest
{
	var printClient:PrintClient;
	

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
		printClient = new PrintClient();
		allClasses = new AllClasses();
		
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldPrintEmptyBlockFrequencyIfIncludeBlockExecutionCountsEqualsTrue()
	{
		allClasses = new AllClasses();
		allClasses.getResults();

		printClient.includeBlockExecutionCounts = false;
		printClient.report(allClasses);

		Assert.isFalse(printClient.output.indexOf("STATEMENTS BY EXECUTION FREQUENCY") != -1);
		Assert.isFalse(printClient.output.indexOf("BRANCHES BY EXECUTION FREQUENCY") != -1);

		printClient.includeBlockExecutionCounts = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf("STATEMENTS BY EXECUTION FREQUENCY") != -1);
		Assert.isTrue(printClient.output.indexOf("BRANCHES BY EXECUTION FREQUENCY") != -1);

		var output = printClient.output.split("STATEMENTS BY EXECUTION FREQUENCY");
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);

		output = printClient.output.split("BRANCHES BY EXECUTION FREQUENCY");
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);
	}

	@Test
	public function shouldPrintEmptyMissingBlocksIfIncludeMissingBlocksEqualsTrue()
	{
		allClasses = new AllClasses();
		allClasses.getResults();

		printClient.includeMissingBlocks = false;
		printClient.report(allClasses);

		Assert.isFalse(printClient.output.indexOf("NON-EXECUTED BRANCHES") != -1);
		Assert.isFalse(printClient.output.indexOf("NON-EXECUTED STATEMENTS") != -1);

		printClient.includeMissingBlocks = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf("NON-EXECUTED BRANCHES") != -1);
		Assert.isTrue(printClient.output.indexOf("NON-EXECUTED STATEMENTS") != -1);

		var output = printClient.output.split("NON-EXECUTED BRANCHES");
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);

		output = printClient.output.split("NON-EXECUTED STATEMENTS");
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);
	}

	@Test
	public function shouldPrintBlockFrequencyIfIncludeBlockExecutionCountsEqualsTrue()
	{
		allClasses = new AllClasses();
		var statement = NodeMock.createStatement();

		allClasses.addStatement(statement);
		allClasses.statementResultsById.set(statement.id, 0);

		statement = NodeMock.createStatement();
		statement.id = 1;
		allClasses.addStatement(statement);
		allClasses.statementResultsById.set(statement.id, 0);


		var branch = NodeMock.createBranch();
		var result = NodeMock.createBranchResult(branch);
		allClasses.addBranch(branch);
		allClasses.branchResultsById.set(branch.id, result);

		branch = NodeMock.createBranch();
		branch.id = 1;
		result = NodeMock.createBranchResult(branch);
		allClasses.addBranch(branch);
		allClasses.branchResultsById.set(branch.id, result);
		
		
		allClasses.getResults();

		printClient.includeBlockExecutionCounts = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf("STATEMENTS BY EXECUTION FREQUENCY") != -1);
		Assert.isTrue(printClient.output.indexOf("BRANCHES BY EXECUTION FREQUENCY") != -1);

		var output = printClient.output.split("STATEMENTS BY EXECUTION FREQUENCY");
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("Total") != -1);

		output = printClient.output.split("BRANCHES BY EXECUTION FREQUENCY");
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("Total") != -1);
	}

	@Test
	public function shouldPrintMissingBlocksIfIncludeMissingBlocksEqualsTrue()
	{
		allClasses = new AllClasses();
		allClasses.addStatement(NodeMock.createStatement());
		allClasses.addBranch(NodeMock.createBranch());
	
		allClasses.getResults();

		printClient.includeMissingBlocks = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf("NON-EXECUTED BRANCHES") != -1);
		Assert.isTrue(printClient.output.indexOf("NON-EXECUTED STATEMENTS") != -1);

		var output = printClient.output.split("NON-EXECUTED BRANCHES");
		var outputLines = output[1].split("\n");
		
		Assert.isTrue(outputLines[2].indexOf("package.class#method | location | t,f") != -1);

		output = printClient.output.split("NON-EXECUTED STATEMENTS");
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("package.class#method | location") != -1);
	}

	///////////

	override function createClient():CoverageClient
	{
		return new PrintClient();
	}
}
