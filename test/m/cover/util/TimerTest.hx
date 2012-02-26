package m.cover.util;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class TimerTest
{
	var timer:Timer;
	var timerCount:Int;
	var stamp:Float;
	var originalTrace:Dynamic;
	var traceOutput:String;


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
		timerCount = 0;
		traceOutput = "";
	}
	
	@After
	public function tearDown():Void
	{
		if(timer != null) timer.stop();

		if(originalTrace != null)
		{
			haxe.Log.trace = originalTrace;
		}
		
	}

	@AsyncTest
	public function shouldRunMultipleTimes(factory:AsyncFactory)
	{	
		timer = new Timer(20);
		timer.run = timerTick;
		
		var handler = factory.createHandler(this, assertTimerTickedMoreThanOnce, 700);
		var delay = Timer.delay(handler, 500);
	}

	@AsyncTest
	public function shouldOnlyRunOnce(factory:AsyncFactory)
	{	
		timer = Timer.delay(timerTick, 20);

		var handler = factory.createHandler(this, assertTimerTickedOnce, 400);

		var delay = Timer.delay(handler, 100);
	}


	function timerTick()
	{
		timerCount ++;
	}

	function assertTimerTickedMoreThanOnce()
	{
		timer.stop();
		Assert.isTrue(timerCount > 1);
	}

	function assertTimerTickedOnce()
	{
		Assert.isTrue(timerCount == 1);
	}

	/////

	@AsyncTest
	public function shouldCreateIncrementalTimeStamp(factory:AsyncFactory)
	{	
		stamp = Timer.stamp();

		var handler = factory.createHandler(this, assertStampHasIncremented, 200);
		var delay = Timer.delay(handler, 50);
	}
	
	function assertStampHasIncremented ()
	{	
		var stamp2 = Timer.stamp();
		Assert.isTrue(stamp2 > stamp);
	}


	#if js

	@Test
	public function shouldCleanUpOldIntervalsInJS()
	{	
		for(i in 0...101)
		{
			timer = new Timer(30);
			timer.stop();
		}

		timer = new Timer(30);

		var id = Reflect.field(timer, "id");

		timer.stop();
		Assert.isTrue(id < 100);
	}

	#elseif neko

	
	@AsyncTest
	public function shouldCatchAndTraceExceptionInRunMethod(factory:AsyncFactory)
	{
		originalTrace = haxe.Log.trace;
		haxe.Log.trace = traceToString;
		traceOutput = "";

		timer = Timer.delay(throwException, 10);

		var handler = factory.createHandler(this, assertExceptionWasTraced, 200);
		var delay = Timer.delay(handler, 50);

	}

	function throwException()
	{
		throw "xyz";
	}

	function traceToString(value:Dynamic, ?info:haxe.PosInfos)
	{
		traceOutput += "\n" + Std.string(value);
	}

	function assertExceptionWasTraced()
	{
		timer.stop();
		Assert.isTrue(traceOutput.indexOf("xyz") > -1);
	}

	#end




}