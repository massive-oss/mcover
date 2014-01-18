package mcover.coverage.munit.client;

import massive.munit.ITestResultClient;
import massive.munit.TestResult;

class TestResultClientStub implements IAdvancedTestResultClient
{
	public static inline var DEFAULT_ID:String = "stub";

	public var id(default, null):String;
	
	public var testCount:Int;
	public var passCount:Int;
	public var failCount:Int;
	public var errorCount:Int;
	public var ignoreCount:Int;
	public var time:Float;
	
	public var finalTestCount:Int;
	public var finalPassCount:Int;
	public var finalFailCount:Int;
	public var finalErrorCount:Int;
	public var finalIgnoreCount:Int;

	public var currentTestClass:String;
	public var testClasses:Array<String>;

	@:isVar 
	#if haxe3
	public var completionHandler(get, set):ITestResultClient -> Void;
	#else
	public var completionHandler(get_completionHandler, set_completionHandler):ITestResultClient -> Void;
	#end
	
	private function get_completionHandler():ITestResultClient -> Void 
	{
		return completionHandler;
	}
	
	private function set_completionHandler(value:ITestResultClient -> Void):ITestResultClient -> Void
	{
		return completionHandler = value;
	}

	public function new()
	{
		id = DEFAULT_ID;
		testCount = 0;
		passCount = 0;
		failCount = 0;
		errorCount = 0;
		ignoreCount = 0;
		time = 0.0;
		testClasses = [];
	}

	public function setCurrentTestClass(className:String):Void
	{
		if (currentTestClass == className) return;
		
		testClasses.push(className);
		currentTestClass = className;
	}

	public function addPass(result:TestResult):Void
	{
		testCount++;
		passCount++;
	}
	
	public function addFail(result:TestResult):Void
	{
		testCount++;
		failCount++;
	
	}

	public function addError(result:TestResult):Void
	{
		testCount++;
		errorCount++;
	}
	
	public function addIgnore(result:TestResult):Void
	{
		ignoreCount++;
	}

	public function reportFinalStatistics(testCount:Int, passCount:Int, failCount:Int, errorCount:Int, ignoreCount:Int, time:Float):Dynamic
	{
		finalTestCount = testCount;
		finalPassCount = passCount;
		finalFailCount = failCount;
		finalErrorCount = errorCount;
		finalIgnoreCount = ignoreCount;
		this.time = time;
		if (completionHandler != null) 
			completionHandler(this);
	}
	
	public function toString():String
	{
		var str = "";
		str += "finalTestCount: " + finalTestCount + "\n";
		str += "testCount: " + testCount + "\n";
		str += "finalPassCount: " + finalPassCount + "\n";
		str += "passCount: " + passCount + "\n";
		str += "finalFailCount: " + finalFailCount + "\n";
		str += "failCount: " + failCount + "\n";
		str += "finalErrorCount: " + finalErrorCount + "\n";
		str += "errorCount: " + errorCount + "\n";
		return str;
	}
}
