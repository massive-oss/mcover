package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.Coverage;
import massive.mcover.CoverageReportClient;
import massive.mcover.data.NodeMock;
import massive.mcover.data.Package;
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
		coverage = new Coverage();
		
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}


	static var statementFrequency = "STATEMENTS BY EXECUTION FREQUENCY";
	static var branchFrequency = "BRANCHES BY EXECUTION FREQUENCY";
	static var statementMissing = "MISSING STATEMENT COVERAGE";
	static var branchMissing = "MISSING BRANCH COVERAGE";
	

	@Test
	public function shouldPrintEmptyBlockFrequencyIfIncludeBlockExecutionCountsEqualsTrue()
	{
		coverage = new Coverage();
		coverage.getResults();

		printClient.includeBlockExecutionCounts = false;
		printClient.report(coverage);

		Assert.isFalse(printClient.output.indexOf(statementFrequency) != -1);
		Assert.isFalse(printClient.output.indexOf(branchFrequency) != -1);

		printClient.includeBlockExecutionCounts = true;
		printClient.report(coverage);

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
		coverage = new Coverage();
		coverage.getResults();

		printClient.includeMissingBlocks = false;
		printClient.report(coverage);

		Assert.isFalse(printClient.output.indexOf(branchMissing) != -1);
		Assert.isFalse(printClient.output.indexOf(statementMissing) != -1);

		printClient.includeMissingBlocks = true;
		printClient.report(coverage);

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
		coverage = new Coverage();
		var statement = NodeMock.createStatement();

		coverage.addStatement(statement);
		coverage.statementResultsById.set(statement.id, 0);

		statement = NodeMock.createStatement();
		statement.id = 1;
		coverage.addStatement(statement);
		coverage.statementResultsById.set(statement.id, 0);


		var branch = NodeMock.createBranch();
		var result = NodeMock.createBranchResult(branch);
		coverage.addBranch(branch);
		coverage.branchResultsById.set(branch.id, result);

		branch = NodeMock.createBranch();
		branch.id = 1;
		result = NodeMock.createBranchResult(branch);
		coverage.addBranch(branch);
		coverage.branchResultsById.set(branch.id, result);
		
		
		coverage.getResults();

		printClient.includeBlockExecutionCounts = true;
		printClient.report(coverage);

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
		coverage = new Coverage();
		var statement = NodeMock.createStatement();

		coverage.addStatement(statement);
		coverage.statementResultsById.set(statement.id, 1);

		statement = NodeMock.createStatement();
		statement.id = 1;
		coverage.addStatement(statement);
		coverage.statementResultsById.set(statement.id, 1);


		var branch = NodeMock.createBranch();
		var result = NodeMock.createBranchResult(branch);
		result.trueCount = 1;
		result.total = 1;
		
		coverage.addBranch(branch);
		coverage.branchResultsById.set(branch.id, result);

		branch = NodeMock.createBranch();
		branch.id = 1;
		result = NodeMock.createBranchResult(branch);
		result.falseCount = 1;
		result.total = 1;
		coverage.addBranch(branch);
		coverage.branchResultsById.set(branch.id, result);
		
		
		coverage.getResults();

		printClient.includeBlockExecutionCounts = true;
		printClient.report(coverage);

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
		coverage = new Coverage();
		coverage.addStatement(NodeMock.createStatement());
		coverage.addBranch(NodeMock.createBranch());
	
		coverage.getResults();

		printClient.includeMissingBlocks = true;
		printClient.report(coverage);

		Assert.isTrue(printClient.output.indexOf(branchMissing) != -1);
		Assert.isTrue(printClient.output.indexOf(statementMissing) != -1);

		var output = printClient.output.split(branchMissing);
		var outputLines = output[1].split("\n");
		
		Assert.isTrue(outputLines[2].indexOf("package.class#method | location | t,f") != -1);

		output = printClient.output.split(statementMissing);
		outputLines = output[1].split("\n");

		Assert.isTrue(outputLines[2].indexOf("package.class#method | location") != -1);
	}

	@Test
	public function shouldConvertEmptyPackageNamesToDefault()
	{
		coverage = new Coverage();
		coverage.getItemByName("package", Package);
		printClient.report(coverage);
		Assert.isTrue(printClient.output.indexOf("[Default]") == -1);

		coverage.getItemByName("", Package);
		printClient.report(coverage);
		Assert.isTrue(printClient.output.indexOf("[Default]") != -1);
	}

	///////////

	override function createClient():CoverageReportClient
	{
		return new PrintClient();
	}
}
