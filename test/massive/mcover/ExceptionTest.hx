package massive.mcover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ExceptionTest
{
	var exception:Exception;

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
		exception = new Exception("message");
		Assert.areEqual("message", exception.message);
		Assert.areEqual("massive.mcover.Exception", exception.type);
		Assert.areEqual("massive.mcover.ExceptionTest", exception.info.className);
		
		Assert.isNull(exception.cause);
		Assert.isNull(exception.causeExceptionStack);
		Assert.isNull(exception.causeCallStack);
		
	}

	@Test
	public function shouldSetCauseStacksInConstructor()
	{
		exception = new Exception("message", "cause");
		Assert.areEqual("cause", exception.cause);
		Assert.isNotNull(exception.causeExceptionStack);
		Assert.isNotNull(exception.causeCallStack);
	}

	@Test
	public function shouldNotSetInfoInConstructor()
	{
		exception = new Exception("message", null, null);
		Assert.isNull(exception.info);
	}

	@Test
	public function shouldOutputToStringWithMessageAndInfo()
	{
		exception = new Exception("message");
		var str = exception.toString();
		Assert.isTrue(str.indexOf("massive.mcover.Exception: message") == 0);
		Assert.isTrue(str.indexOf("at massive.mcover.ExceptionTest") != -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringWithMessageOnly()
	{
		exception = new Exception("message", null, null);
		var str = exception.toString();
		Assert.areEqual("massive.mcover.Exception: message", str);
		Assert.isTrue(str.indexOf("at massive.mcover.ExceptionTest") == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringMessageAndCause()
	{
		exception = new Exception("message", "cause", null);
		var str = exception.toString();
		Assert.isTrue(str.indexOf("massive.mcover.Exception: message") == 0);
		Assert.isTrue(str.indexOf("at massive.mcover.ExceptionTest") == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") != -1);
	}
}
