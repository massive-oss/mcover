package massive.munit.client;

import massive.munit.ITestResultClient;
import massive.munit.client.PrintClient;

import massive.munit.AssertionException;
import massive.munit.ITestResultClient;
import massive.munit.TestResult;
import massive.munit.util.MathUtil;
import massive.haxe.util.ReflectUtil;
import massive.munit.util.Timer;

import massive.mcover.MCover;
import massive.mcover.CoverageReporter;
import massive.mcover.client.PrintClient;

/**
* Custom MUnit print client that includes coverage in runner output.
*/
class MCoverPrintClient extends PrintClient
{
	var reporter:CoverageReporter;
	var coverClient:massive.mcover.client.PrintClient;

	public function new(?includeIgnoredReport:Bool = false)
	{
		super(includeIgnoredReport);
		
		try
		{
			reporter = MCover.getLogger().createReporter();
			coverClient = new massive.mcover.client.PrintClient();
			reporter.addClient(coverClient);
			reporter.completionHandler = codeCoverageComplete;
		}
		catch(e:Dynamic)
		{
			trace(e);
			throw new massive.mcover.Exception("Unable to initialize MCover", e);
		}
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
			
		reporter.report();
		
		return output;	
	}

	function codeCoverageComplete(percent:Float)
	{
		print(coverClient.output + newline);
		haxe.Log.trace = originalTrace;
		if (completionHandler != null) completionHandler(this); 
	}
}