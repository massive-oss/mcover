package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.MCoverRunner;
import massive.mcover.MCover;
import massive.mcover.data.AllClasses;

class MCoverExceptionTest
{
	var exception:MCoverException;

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
		
	}
	
	@After
	public function tearDown():Void
	{
		
	}

	@Test
	public function shouldDefineInfoAndTypeInConstructor()
	{
		exception = new MCoverException("message");
		Assert.areEqual("message", exception.message);
		Assert.areEqual("massive.mcover.MCoverException", exception.type);
		Assert.areEqual("massive.mcover.MCoverExceptionTest", exception.info.className);
		
		Assert.isNull(exception.cause);
		Assert.isNull(exception.causeExceptionStack);
		Assert.isNull(exception.causeCallStack);
		
	}

	@Test
	public function shouldSetCauseStacksInConstructor()
	{
		exception = new MCoverException("message", "cause");
		Assert.areEqual("cause", exception.cause);
		Assert.isNotNull(exception.causeExceptionStack);
		Assert.isNotNull(exception.causeCallStack);
	}

	@Test
	public function shouldNotSetInfoInConstructor()
	{
		exception = new MCoverException("message", null, null);
		Assert.isNull(exception.info);
	}

	@Test
	public function shouldOutputToStringWithMessageAndInfo()
	{
		exception = new MCoverException("message");
		var str = exception.toString();
		Assert.isTrue(str.indexOf("massive.mcover.MCoverException: message") == 0);
		Assert.isTrue(str.indexOf("at massive.mcover.MCoverExceptionTest") != -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringWithMessageOnly()
	{
		exception = new MCoverException("message", null, null);
		var str = exception.toString();
		Assert.areEqual("massive.mcover.MCoverException: message", str);
		Assert.isTrue(str.indexOf("at massive.mcover.MCoverExceptionTest") == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringMessageAndCause()
	{
		exception = new MCoverException("message", "cause", null);
		var str = exception.toString();
		Assert.isTrue(str.indexOf("massive.mcover.MCoverException: message") == 0);
		Assert.isTrue(str.indexOf("at massive.mcover.MCoverExceptionTest") == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") != -1);
	}
}
