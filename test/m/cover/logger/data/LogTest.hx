package m.cover.logger.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import m.cover.logger.data.Log;
import haxe.PosInfos;
/**
* Auto generated MassiveUnit Test Class  for m.cover.logger.data.Log 
*/
class LogTest 
{
	var instance:Log; 
	
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
		instance = new Log(0);
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testConstructor():Void
	{
		Assert.areEqual(0, instance.id);
		Assert.isNull(instance.name);
		Assert.areEqual("null (0, 0)", instance.toString());

	}

	@Test
	public function should_include_entry_pos_in_name():Void
	{
		var entryPos = createStubPosInfo();
		var entryTime = 500;
		var depth = 1;

		instance.enter(entryPos, entryTime, depth);

		var name = entryPos.className + "/" + entryPos.methodName;

		Assert.areEqual(name, instance.name);
	}

	@Test
	public function should_include_line_number_if_inlined_function():Void
	{
		var entryPos = createStubPosInfo();
		var entryTime = 500;
		var depth = 1;

		instance.enter(entryPos, entryTime, depth);
		instance.inlined = true;

		var name = entryPos.className + "/" + entryPos.methodName;

		Assert.areEqual(name + "/function_" + entryPos.lineNumber, instance.name);
	}

	@Test
	public function should_cache_name():Void
	{
		var entryPos = createStubPosInfo();
		entryPos.className = "ClassA";

		instance.enter(entryPos, 1, 1);

		Assert.isTrue(instance.name.indexOf("ClassA") > -1);

		entryPos = createStubPosInfo();
		entryPos.className = "ClassB";
		instance.enter(entryPos, 1, 1);

		Assert.isTrue(instance.name.indexOf("ClassA") > -1);

	}


	@Test
	public function should_update_duration_on_exit():Void
	{
		instance = createInstance(500, 2000);

		Assert.areEqual(1500, instance.totalDuration);
		Assert.areEqual(1500, instance.internalDuration);
	}

	@Test
	public function should_remove_children_durations_from_internal_duration():Void
	{
		
		var child = createInstance(1000, 2000);

		instance = createInstance(500, 2000, [child]);

		Assert.areEqual(1500, instance.totalDuration);
		Assert.areEqual(500, instance.internalDuration);
	}

	function createInstance(start:Float, end:Float, ?children:Array<Log>=null):Log
	{
		var instance = new Log(0);

		if(children != null)
			instance.children = children;
		
		var entryPos = createStubPosInfo();
		var entryTime = start;
		var depth = 1;

		var exitPos = createStubPosInfo();
		var exitTime = end;

		instance.enter(entryPos, entryTime, depth);
		instance.exit(exitPos, exitTime);

		return instance;

	}


	function createStubPosInfo():PosInfos
	{
		return {
			fileName:"File.hx",
			className:"Class",
			methodName:"method",
			lineNumber:0,
			customParams:[]
		}
	}
}