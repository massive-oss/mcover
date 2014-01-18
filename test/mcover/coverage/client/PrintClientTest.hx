package mcover.coverage.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.coverage.data.Coverage;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.data.NodeMock;
import mcover.coverage.data.Package;
import mcover.coverage.data.Branch;

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
	public function shouldIncludeHeader()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeHeader", "header");
	}

	@Test
	public function shouldIncludeExecutionFrequency()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeExecutionFrequency", "executionFrequency");
	}

	@Test
	public function shouldIncludeMissingBlocks()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeMissingBlocks", "missingBlocks");
	}

	@Test
	public function shouldIncludeClassBreakdown()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeClassBreakdown", "classBreakdown");
	}

	@Test
	public function shouldIncludePackageBreakdown()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includePackageBreakdown", "packageBreakdown");
	}

	@Test
	public function shouldIncludeSummary()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeSummary", "summary");
	}

	@Test
	public function shouldIncludeOverallPercentage()
	{
		coverage.getResults();
		assertPropertyIsIncludedInOutput("includeOverallPercentage", "overallPercentage");
	}



	@Test
	public function shouldPrintEmptyBlockFrequencyIfBlockCountEqualsZero()
	{
		coverage = new Coverage();

		addStatementToCoverage(0, 0);
		addStatementToCoverage(1, 0);

		addBranchToCoverage(0, 0, 0, 0);
		addBranchToCoverage(1, 0, 0, 0);

		coverage.getResults();

		printClient.includeExecutionFrequency = true;
		printClient.report(coverage);

		var result = printClient.executionFrequency;

		assertContainsString(result, statementFrequency);
		assertContainsString(result, branchFrequency);

		var output = result.split(statementFrequency)[1];

		assertContainsString(output, "None");

		output = result.split(branchFrequency)[1];

		assertContainsString(output, "None");
	}

	@Test
	public function shouldPrintBlockFrequencyIfBlockCountGreaterThanZero()
	{
		coverage = new Coverage();

		addStatementToCoverage(0, 1);
		addStatementToCoverage(1, 1);

		addBranchToCoverage(0, 1, 0, 1);
		addBranchToCoverage(1, 0, 1, 1);
	

		coverage.getResults();

		printClient.includeExecutionFrequency = true;
		printClient.report(coverage);

		var result = printClient.executionFrequency;

		assertContainsString(result, statementFrequency);
		assertContainsString(result, branchFrequency);

		var output = result.split(statementFrequency)[1];

		assertContainsString(output, "Count");

		output = result.split(branchFrequency)[1];

		assertContainsString(output, "Count");
	}

	@Test
	public function shouldLimitToMaxBlockExecutionListSize()
	{
		coverage = new Coverage();

		addStatementToCoverage(0, 4);
		addStatementToCoverage(1, 3);
		addStatementToCoverage(2, 2);
		addStatementToCoverage(3, 1);

		addBranchToCoverage(0, 4, 0, 4);
		addBranchToCoverage(1, 3, 0, 3);
		addBranchToCoverage(2, 2, 0, 2);
		addBranchToCoverage(3, 1, 0, 1);
		
		coverage.getResults();

		printClient.maxBlockExecutionListSize = 4;
		printClient.report(coverage);
		
		var result1 = printClient.executionFrequency.split("\n");

		printClient.maxBlockExecutionListSize = 2;
		printClient.report(coverage);

		var result2 = printClient.executionFrequency.split("\n");
	
		Assert.areEqual(result1.length - 4, result2.length);
	}

	@Test
	public function shouldConvertEmptyPackageNamesToDefaultDuringSerialization()
	{
		coverage = new Coverage();
		coverage.getItemByName("package", Package);
		printClient.report(coverage);

		var result = printClient.packageBreakdown;
		Assert.isTrue(result.indexOf("[Default]") == -1);

		coverage.getItemByName("", Package);
		printClient.report(coverage);
		result = printClient.packageBreakdown;
		Assert.isTrue(result.indexOf("[Default]") != -1);
	}

	///////////

	override function createClient():CoverageReportClient
	{
		return new PrintClient();
	}

	function addStatementToCoverage(id:Int, ?count:Int=1)
	{
		var statement = NodeMock.createStatement(id);
		coverage.addStatement(statement);
		coverage.statementResultsById.set(statement.id, count);
			 
	}

	function addBranchToCoverage(id:Int, ?trueCount:Int=0, ?falseCount:Int=0, ?total:Int=0)
	{
		var branch = NodeMock.createBranch(id);
		var result = NodeMock.createBranchResult(branch);
		result.trueCount = trueCount;
		result.falseCount = falseCount;
		result.total = total;

		coverage.addBranch(branch);
		coverage.branchResultsById.set(branch.id, result);
			 
	}

	
	function assertContainsString(source:String, value:String)
	{
		var lines = source.split("\n");

		var hasMatch = false;

		for (line in lines)
		{
			if (line.indexOf(value) != -1)
			{
				hasMatch = true;
				break;
			}
		}

		Assert.isTrue(hasMatch);
	}

	function assertPropertyIsIncludedInOutput(flagProperty:String, outputProperty:String)
	{


		Reflect.setField(printClient, flagProperty, false);
	
		printClient.report(coverage);

		var result = Reflect.field(printClient, outputProperty);

		Assert.isNotNull(result);
		Assert.areNotEqual("", result);
		Assert.isTrue(printClient.output.indexOf(result) == -1);
		


		Reflect.setField(printClient, flagProperty, true);
		printClient.report(coverage);
		result = Reflect.field(printClient, outputProperty);

		
		Assert.isTrue(printClient.output.indexOf(result) > -1);
	}
}
