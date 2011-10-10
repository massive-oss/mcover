package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import massive.mcover.CoverageLogger;
import massive.mcover.CoverageReporter;
import massive.mcover.MCover;
import massive.mcover.data.AllClasses;
import massive.mcover.data.Branch;

class CoverageLoggerImplTest extends CoverageLoggerTest
{
	var instance:CoverageLoggerImpl;
	var reporter:CoverageReporter;
	var reporter2:CoverageReporter;

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
		instance = new CoverageLoggerImpl();
	
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();

		if(reporter != null)
		{
			reporter.destroy();
		}

		if(reporter2 != null)
		{
			reporter2.destroy();
		}
	}


	@Test
	public function shouldCreateDefaultRunnerIfNonExisting()
	{
		reporter = instance.createReporter();
		Assert.isNotNull(reporter);
		Assert.areEqual(CoverageReporterImpl, Type.getClass(reporter));
		
	}

	@Test
	public function shouldThrowExceptionIfOverwritingRunnerWithoutFlag()
	{
		try
		{
			reporter = instance.createReporter(CoverageReporterMock);
			reporter = instance.createReporter(CoverageReporterMock);
			Assert.fail("Expected Exception for overwriting existing reporter instance");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldCreateNewDefaultRunner()
	{
		reporter = instance.createReporter(CoverageReporterMock);
		reporter2 = instance.createReporter(null, true);

		Assert.isNotNull(reporter2);
		Assert.areEqual(CoverageReporterImpl, Type.getClass(reporter2));
		Assert.areNotEqual(reporter, reporter2);
		Assert.isTrue(cast(reporter, CoverageReporterMock).isDestroyed);
	}

	@Test
	public function shouldCreateCustomerRunner()
	{
		reporter = instance.createReporter(CoverageReporterMock);
		Assert.areEqual(CoverageReporterMock,  Type.getClass(reporter));
	}

	@Test
	public function shouldInitializeAllClassesWhenRunnerAdded()
	{
		Assert.isNull(instance.allClasses);
		reporter = instance.createReporter(CoverageReporterMock);
		Assert.isNotNull(instance.allClasses);
	}

	@Test
	public function shouldNotReInitializeAllClassesWhenRunnerAdded()
	{
		instance.loadAllClasses();
		var allClasses = instance.allClasses;

		reporter = instance.createReporter(CoverageReporterMock);
		Assert.areEqual(allClasses, instance.allClasses);
	}

	@Test
	public function shouldInitializeRunnerWithCoverAndAllClassesOnRunner()
	{
		reporter = instance.createReporter(CoverageReporterMock);
		Assert.areEqual(instance, reporter.logger);
		Assert.areEqual(instance.allClasses, cast(reporter, CoverageReporterMock).allClasses);
	}

	@Test
	public function shouldLoadAllClasses()
	{
		Assert.isNull(instance.allClasses);
		instance.loadAllClasses();
		Assert.isNotNull(instance.allClasses);
	}

	@Test
	public function shouldThrowExceptionIfNoMatchingResource()
	{
		try
		{
			instance.loadAllClasses("InvalidMCoverResourceName");
			Assert.fail("Exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);

		}
	}

	@Test
	public function shouldThrowExceptionForInvalidResource()
	{
		try
		{
			instance.loadAllClasses("MockMCoverResource");
			Assert.fail("Exception expected");
		}
		catch(e:Exception)
		{
			Assert.isTrue(true);

		}
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


	/////////////
	override function createLogger():CoverageLogger
	{
		return new CoverageLoggerImpl();
	}
}