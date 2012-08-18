package m.cover;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.PosInfos;

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
		exception = createInstance("message");
		Assert.areEqual("message", exception.message);	
		Assert.areEqual(getTypeString(), exception.type);
		Assert.areEqual(getTestName(), exception.info.className);
		
		Assert.isNull(exception.cause);
		Assert.isNull(exception.causeExceptionStack);
		Assert.isNull(exception.causeCallStack);
		
	}

	

	@Test
	public function shouldSetCauseStacksInConstructor()
	{
		exception = createInstance("message", "cause");
		Assert.areEqual("cause", exception.cause);
		Assert.isNotNull(exception.causeExceptionStack);
		Assert.isNotNull(exception.causeCallStack);
	}

	@Test
	public function shouldNotSetInfoInConstructor()
	{
		exception = createInstance("message", null, null);
		Assert.isNull(exception.info);
	}

	

	@Test
	public function shouldOutputToStringWithMessageAndInfo()
	{
		exception = createInstance("message");
		var str = exception.toString();
		Assert.isTrue(str.indexOf(getTypeString() + ": message") == 0);
		trace(str);
		Assert.isTrue(str.indexOf("at " + getTestName()) != -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringWithMessageOnly()
	{
		exception = createInstance("message", null, null);
		var str = exception.toString();
		Assert.areEqual(getTypeString() + ": message", str);
		Assert.isTrue(str.indexOf("at " + getTestName()) == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") == -1);
	}

	@Test
	public function shouldOutputToStringMessageAndCause()
	{
		exception = createInstance("message", "cause", null);
		var str = exception.toString();
		Assert.isTrue(str.indexOf(getTypeString() + ": message") == 0);
		Assert.isTrue(str.indexOf("at " + getTestName()) == -1);
		Assert.isTrue(str.indexOf("Caused by: cause") != -1);
	}

	function createInstance(msg:String="message", ?cause:Dynamic=null, ?info:PosInfos):Exception
	{
		return new Exception(msg, cause, info);
	}

	function getTypeString():String
	{
		return "m.cover.Exception";
	}

	function getTestName():String
	{
		return here().className;
	}

	function here(?pos:PosInfos):PosInfos
	{
		return pos;
	}
}
