package massive.mcover;

import massive.mcover.CoverageEntry;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class CoverageEntryTest 
{	

	static var DEFAULT_KEY:String = "1|src|foo|Main|1|100|location";

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
	public function shouldDeserializeKeyInConstructor():Void
	{
		var entry = new CoverageEntry(DEFAULT_KEY);

		Assert.areEqual(DEFAULT_KEY, entry.key);
		Assert.areEqual(1, entry.id);
		Assert.areEqual("src", entry.classPath);
		Assert.areEqual("foo", entry.packageName);
		Assert.areEqual("Main", entry.className);
		Assert.areEqual(1, entry.min);
		Assert.areEqual(100, entry.max);
		Assert.areEqual("location", entry.location);
		
		Assert.areEqual(0, entry.count);
		
		Assert.isFalse(entry.result);
	}

	@Test
	public function shouldThrowErrorOnInvalidKeyFormat():Void
	{
		try
		{
			var entry = new CoverageEntry("foo");
			Assert.fail("expected exception for invalid key in constructor");
		}
		catch(e:Dynamic)
		{
			Assert.isTrue(true);
		}
	}

	@Test
	public function shouldThrowErrorOnEmptyKey():Void
	{
		try
		{
			var entry = new CoverageEntry("||||||");
			Assert.fail("expected exception for empty key in constructor");
		}
		catch(e:Dynamic)
		{
			Assert.isTrue(true);
		}	
	}

	@Test
	public function shouldSerialiseToKey():Void
	{
		var entry = new CoverageEntry(DEFAULT_KEY);
		Assert.areEqual(DEFAULT_KEY, entry.toString());
	}

	@Test
	public function shouldChangeResultWhenCountChanges():Void
	{
		var entry = new CoverageEntry(DEFAULT_KEY);
		Assert.areEqual(0, entry.count);
		Assert.isFalse(entry.result);

		entry.count ++;

		Assert.areEqual(1, entry.count);
		Assert.isTrue(entry.result);
	}

	

}