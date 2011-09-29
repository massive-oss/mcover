package munit.client;

import massive.munit.ITestResultClient;
import massive.munit.client.PrintClient;

import massive.munit.AssertionException;
import massive.munit.ITestResultClient;
import massive.munit.TestResult;
import massive.munit.util.MathUtil;
import massive.haxe.util.ReflectUtil;
import massive.munit.util.Timer;

import massive.mcover.MCover;

class MCoverPrintClient extends PrintClient
{
	var coverClient:massive.mcover.client.PrintClient;

	public function new(?includeIgnoredReport:Bool = false)
	{
		super(includeIgnoredReport);

		coverClient = new massive.mcover.client.PrintClient();
		
		MCover.createRunner();
		MCover.runner.completionHandler = codeCoverageComplete;
		MCover.addClient(coverClient);
	}

	override public function reportFinalStatistics(testCount:Int, passCount:Int, failCount:Int, errorCount:Int, ignoreCount:Int, time:Float):Dynamic
	{
		printExceptions();
		print(newline + newline);
		if (includeIgnoredReport && ignored != "")
		{
			print("Ignored:" + newline);
			print("------------------------------");
			print(ignored);
		}
		print(newline + newline);
		print((passCount == testCount) ? "PASSED" : "FAILED");
		print(newline + "Tests: " + testCount + "  Passed: " + passCount + "  Failed: " + failCount + " Errors: " + errorCount + " Ignored: " + ignoreCount + " Time: " + MathUtil.round(time, 5) + newline);
		print("==============================" + newline);
			
		MCover.report();

		if (completionHandler != null)
		{
			completionHandler(this);
		}

		return output;	
	}

	function codeCoverageComplete(percent:Float)
	{
		print(coverClient.output + newline);
		haxe.Log.trace = originalTrace;
		if (completionHandler != null) completionHandler(this); 
	}
}