package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.AllClasses;
import massive.mcover.CoverageReportClient;
import massive.mcover.data.NodeMock;
import massive.mcover.data.Branch;


class PrintClientTest extends CoverageReportClientTest
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


	static var statementFrequency = "STATEMENTS BY EXECUTION FREQUENCY";
	static var branchFrequency = "BRANCHES BY EXECUTION FREQUENCY";
	static var statementMissing = "NON-EXECUTED STATEMENTS";
	static var branchMissing = "NON-EXECUTED BRANCHES";
	

	@Test
	public function shouldPrintEmptyBlockFrequencyIfIncludeBlockExecutionCountsEqualsTrue()
	{
		allClasses = new AllClasses();
		allClasses.getResults();

		printClient.includeBlockExecutionCounts = false;
		printClient.report(allClasses);

		Assert.isFalse(printClient.output.indexOf(statementFrequency) != -1);
		Assert.isFalse(printClient.output.indexOf(branchFrequency) != -1);

		printClient.includeBlockExecutionCounts = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf(statementFrequency) != -1);
		Assert.isTrue(printClient.output.indexOf(branchFrequency) != -1);

		var output = printClient.output.split(statementFrequency);
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);

		output = printClient.output.split(branchFrequency);
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

		Assert.isFalse(printClient.output.indexOf(branchMissing) != -1);
		Assert.isFalse(printClient.output.indexOf(statementMissing) != -1);

		printClient.includeMissingBlocks = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf(branchMissing) != -1);
		Assert.isTrue(printClient.output.indexOf(statementMissing) != -1);

		var output = printClient.output.split(branchMissing);
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);

		output = printClient.output.split(statementMissing);
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);
	}

	@Test
	public function shouldPrintEmptyBlockFrequencyIfBlockCountEqualsZero()
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

		Assert.isTrue(printClient.output.indexOf(statementFrequency) != -1);
		Assert.isTrue(printClient.output.indexOf(branchFrequency) != -1);

		var output = printClient.output.split(statementFrequency);
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);

		output = printClient.output.split(branchFrequency);
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("None") != -1);
	}


	@Test
	public function shouldPrintBlockFrequencyIfBlockCountGreaterThanZero()
	{
		allClasses = new AllClasses();
		var statement = NodeMock.createStatement();

		allClasses.addStatement(statement);
		allClasses.statementResultsById.set(statement.id, 1);

		statement = NodeMock.createStatement();
		statement.id = 1;
		allClasses.addStatement(statement);
		allClasses.statementResultsById.set(statement.id, 1);


		var branch = NodeMock.createBranch();
		var result = NodeMock.createBranchResult(branch);
		result.trueCount = 1;
		result.total = 1;
		
		allClasses.addBranch(branch);
		allClasses.branchResultsById.set(branch.id, result);

		branch = NodeMock.createBranch();
		branch.id = 1;
		result = NodeMock.createBranchResult(branch);
		result.falseCount = 1;
		result.total = 1;
		allClasses.addBranch(branch);
		allClasses.branchResultsById.set(branch.id, result);
		
		
		allClasses.getResults();

		printClient.includeBlockExecutionCounts = true;
		printClient.report(allClasses);

		Assert.isTrue(printClient.output.indexOf(statementFrequency) != -1);
		Assert.isTrue(printClient.output.indexOf(branchFrequency) != -1);

		var output = printClient.output.split(statementFrequency);
		var outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("Total") != -1);

		output = printClient.output.split(branchFrequency);
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

		Assert.isTrue(printClient.output.indexOf(branchMissing) != -1);
		Assert.isTrue(printClient.output.indexOf(statementMissing) != -1);

		var output = printClient.output.split(branchMissing);
		var outputLines = output[1].split("\n");
		
		Assert.isTrue(outputLines[2].indexOf("package.class#method | location | t,f") != -1);

		output = printClient.output.split(statementMissing);
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("package.class#method | location") != -1);
	}

	///////////

	override function createClient():CoverageReportClient
	{
		return new PrintClient();
	}
}
