package mcover.logger.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.logger.data.LogRecording;

/**
* Auto generated MassiveUnit Test Class  for mcover.logger.data.LogRecording 
*/
class LogRecordingTest 
{
	var instance:LogRecording; 
	
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
	public function testConstructor():Void
	{
		instance = new LogRecording();

		Assert.areEqual(0, instance.depth);
		Assert.areEqual(0, instance.maxDepth);
		Assert.areEqual(0, instance.endTime);
		Assert.areEqual(0, instance.duration);
	}
}