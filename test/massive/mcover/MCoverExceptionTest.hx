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
	public function shouldSetInforAndTypeInConstructor()
	{
		exception = new MCoverException("message");
		Assert.areEqual("message", exception.message);
		Assert.areEqual("massive.mcover.MCoverException", exception.type);
		Assert.areEqual("massive.mcover.MCoverExceptionTest", exception.info.className);
		
	}

	@Test
	public function shouldNotAutoSetInfo()
	{
		exception = new MCoverException("message", null);
		Assert.isNull(exception.info);
	}

	@Test
	public function shouldOutputToString()
	{
		exception = new MCoverException("message");

		var str = exception.toString();

		Assert.isTrue(str.indexOf("massive.mcover.MCoverException: message") == 0);
		Assert.isTrue(str.indexOf( exception.info.className) > -1);

	}

	@Test
	public function shouldOutputToStringWithoutPosInfos()
	{
		exception = new MCoverException("message", null);
		var str = exception.toString();
		Assert.areEqual("massive.mcover.MCoverException: message", str);
	}

	@Test
	public function shouldNotHaveOriginalExceptionByDefault()
	{
		exception = new MCoverException("message");
		Assert.isFalse(exception.hasOriginalException());
	}

		@Test
	public function shouldSetOriginalExceptionStacks()
	{
		exception = new MCoverException("message");
		exception.originalException = "exception";

		Assert.isTrue(exception.hasOriginalException());
		Assert.isNotNull(exception.originalExceptionStack);
		Assert.isNotNull(exception.originalExceptionCallStack);
			
	}
}
