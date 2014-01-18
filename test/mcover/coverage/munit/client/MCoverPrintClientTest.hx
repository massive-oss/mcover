package mcover.coverage.munit.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.coverage.munit.client.MCoverPrintClient;
import massive.munit.TestResult;
import mcover.coverage.CoverageReportClientMock;
import massive.munit.ITestResultClient;
import mcover.coverage.CoverageLoggerMock;
import mcover.coverage.data.Coverage;
import mcover.coverage.data.NodeMock;
/**
	Auto generated MassiveUnit Test Class  for mcover.coverage.munit.client.MCoverPrintClient 
**/
class MCoverPrintClientTest 
{
	var instance:MCoverPrintClient; 
	var munitClient:AdvancedTestResultClientMock;
	var result:TestResult;

	var coverageClient:CoverageReportClientMock;
	var coverageLogger:CoverageLoggerMock;

	var completionCount:Int;

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
		munitClient = new AdvancedTestResultClientMock();
		
		coverageClient = new CoverageReportClientMock();
		coverageLogger = new CoverageLoggerMock();
		coverageLogger.setCoverage(new Coverage());
		result = new TestResult();	
		
		instance = new MCoverPrintClient(munitClient,coverageClient,coverageLogger);
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function shouldSetIdInConstructor():Void
	{
		instance = new MCoverPrintClient(munitClient,coverageClient,coverageLogger);
		Assert.areEqual(MCoverPrintClient.DEFAULT_ID, instance.id);
	}

	@Test
	public function shouldUseCustomClient():Void
	{
		result.passed = true;
		instance.addPass(result);
		Assert.areEqual(1, munitClient.passCount);
	}

	@Test
	public function shouldCallClientAddPass()
	{
		result.passed = true;
		instance.addPass(result);
		Assert.areEqual(1, munitClient.passCount);
	}

	@Test
	public function shouldCallClientAddFail()
	{
		result.passed = false;
		instance.addFail(result);
		Assert.areEqual(1, munitClient.failCount);
	}

	@Test
	public function shouldCallClientAddError()
	{
		result.passed = false;
		result.error = "error";
		instance.addError(result);
		Assert.areEqual(1, munitClient.errorCount);
	}

	@Test
	public function shouldCallClientAddIgnore()
	{
		result.ignore = true;
		instance.addIgnore(result);
		Assert.areEqual(1, munitClient.ignoreCount);
	}

	@Test
	public function shouldUpdateCurrentTestIfTestClassChanges()
	{
		instance.setCurrentTestClass("a");
		Assert.areEqual("a", munitClient.currentTestClass);
		Assert.areEqual(1, munitClient.testClasses.length);

		instance.setCurrentTestClass("a");
		Assert.areEqual("a", munitClient.currentTestClass);
		Assert.areEqual(1, munitClient.testClasses.length);

		instance.setCurrentTestClass("b");
		Assert.areEqual("b", munitClient.currentTestClass);
		Assert.areEqual(2, munitClient.testClasses.length);
	}

	@Test
	public function shouldUpdateLoggerCurrentTestIfTestChanges()
	{
		var logger = coverageLogger;
		logger.currentTest = null;

		instance.setCurrentTestClass("aTest");
		Assert.areEqual(logger.currentTest,"a");

		instance.setCurrentTestClass("a");
		Assert.areEqual(logger.currentTest,null);

		instance.setCurrentTestClass("aTest");
		Assert.areEqual(logger.currentTest,"a");

		instance.setCurrentTestClass("bTest");
		Assert.areEqual(logger.currentTest,"b");
	}

	@Test
	public function shouldCreateCoverageForCurrentTestClass()
	{
		instance.includeMissingBlocks = true;
		
		var coverage = coverageLogger.coverage;
		var branch = NodeMock.createBranch();
		var statement = NodeMock.createStatement();

		coverage.addBranch(branch);
		coverage.addStatement(statement);
		instance.setCurrentTestClass("package.classTest");
		
		branch.trueCount = 1;
		branch.falseCount = 0;
		statement.count = 0;
		instance.setCurrentTestClass("item2Test");

		var lastClassCoverageResult = munitClient.testCoverage;

		Assert.isNotNull(lastClassCoverageResult);
		Assert.areEqual("package.class", lastClassCoverageResult.className);
		Assert.areEqual(25, lastClassCoverageResult.percent);
		Assert.areEqual(2, lastClassCoverageResult.blocks.length);
	}

	@Test
	public function shouldCallClientReportFinalStatistics()
	{
		instance.reportFinalStatistics(3,1,1,1,1,0);
		Assert.areEqual(3, munitClient.finalTestCount);
	}

	@Test
	public function shouldCallCompletionHandler()
	{
		completionCount = 0;
		instance.completionHandler = completionHandler;
		instance.reportFinalStatistics(3,1,1,1,1,0);

		Assert.areEqual(1, completionCount);
	}

	//////
	function completionHandler(client:ITestResultClient)
	{
		 completionCount ++;
	}

	function populateCoverage()
	{
		var coverage = coverageLogger.coverage;

		var item1 = cast(coverage.getItemByName("item1", NodeMock), NodeMock);
		var item2 = cast(coverage.getItemByName("item2", NodeMock), NodeMock);
		var item3 = cast(coverage.getItemByName("item3", NodeMock), NodeMock);
	}
}