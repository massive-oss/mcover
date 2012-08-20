package mcover.macro;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.macro.ClassInfo;

/**
* Auto generated MassiveUnit Test Class  for mcover.macro.ClassInfo 
*/
class ClassInfoTest 
{
	var instance:ClassInfo; 
	
	public function new() 
	{	
	}
	
	@Test
	public function should_return_location():Void
	{
		instance = new ClassInfo();
		Assert.isNull(instance.location);

		instance.className = "Class";
		Assert.areEqual("Class", instance.location);

		instance.methodName = "method";
		Assert.areEqual("Class.method", instance.location);

		instance.packageName = "";
		Assert.areEqual("Class.method", instance.location);

		instance.packageName = "package";
		Assert.areEqual("package.Class.method", instance.location);
	}

	@Test
	public function should_clone_properties()
	{
		instance =createInstance();

		var clone =instance.clone();
		Assert.areEqual(instance.fileName, clone.fileName);
		Assert.areEqual(instance.packageName, clone.packageName);
		Assert.areEqual(instance.className, clone.className);
		Assert.areEqual(instance.methodName, clone.methodName);
		Assert.areEqual(instance.location, clone.location);
	}

	@Test
	public function should_populate_from_file()
	{
		instance = createInstance();

		var file = "src/package/Class.hx";
		var cp = "src";

		var fromFile = ClassInfo.fromFile(file, cp);
		assertFromFile(instance, fromFile);

		cp = "src/";
		fromFile = ClassInfo.fromFile(file, cp);
		assertFromFile(instance, fromFile);
	}

	function assertFromFile(instance:ClassInfo, fromFile:ClassInfo)
	{
		Assert.areEqual(instance.fileName, fromFile.fileName);
		Assert.areEqual(instance.packageName, fromFile.packageName);
		Assert.areEqual(instance.className, fromFile.className);
		Assert.isNull(fromFile.methodName);
		Assert.areEqual("package.Class", fromFile.location);
	}

	@Test
	public function toString_should_include_className()
	{
		instance = createInstance();
		Assert.areEqual(instance.fileName + ":" + instance.location, instance.toString());
		instance.className = null;
		Assert.areEqual(instance.fileName, instance.toString());
	}

	function createInstance():ClassInfo
	{
		instance = new ClassInfo();
		instance.packageName = "package";
		instance.className = "Class";
		instance.methodName = "method";
		instance.fileName = "src/package/Class.hx";
		return instance;
	}
}