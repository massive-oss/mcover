/****
* Copyright 2011 Massive Interactive. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

package massive.mcover.munit.client;

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