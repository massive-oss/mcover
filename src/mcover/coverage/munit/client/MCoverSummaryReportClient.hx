/****
* Copyright 2013 Massive Interactive. All rights reserved.
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

package mcover.coverage.munit.client;

import massive.munit.ITestResultClient;
import massive.munit.TestResult;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.DataTypes;
import mcover.coverage.MCoverage;
import massive.munit.client.SummaryReportClient;

/**
Appends high level coverage stats to summary report

e.g.

	#coverage:percent,count/total
	coverage:68%
	packages:44%,16/17
	files:14%,30/358
	classes:10%,37/425
	methods:10%,79/2068
	statements:2%,107/3750
	branches:2%,7/1773
	lines:2%,130/1234566
*/

class MCoverSummaryReportClient extends SummaryReportClient
{
	var mcoverLogger:CoverageLogger;
	var coverage:Coverage;

	public function new()
	{
		super();
		initializeLogger();
	}

	@IgnoreCover
	function initializeLogger()
	{
		try
		{
			mcoverLogger = MCoverage.getLogger();	
		}
		catch(e:Dynamic)
		{
			var msg = "ERROR: Unable to initialize MCover Logger\n" + e;

			trace(msg);
		}
		return null;
	}

	override function printFinalStatistics(result:Bool, testCount:Int, passCount:Int, failCount:Int, errorCount:Int, ignoreCount:Int, time:Float)
	{
		super.printFinalStatistics(result, testCount, passCount, failCount, errorCount, ignoreCount, time);

		mcoverLogger.report(false);

		coverage = mcoverLogger.coverage;
		
		output += "\n#coverage:percent,count/total";
		output += "\ncoverage:" + coverage.getPercentage() + "%";

		var r = coverage.getResults();

		output += "\n" + appendResult("packages", r.pc, r.p);
		output += "\n" + appendResult("files", r.fc, r.f);
		output += "\n" + appendResult("classes", r.cc, r.c);
		output += "\n" + appendResult("methods", r.mc, r.m);
		output += "\n" + appendResult("statements", r.sc, r.s);
		output += "\n" + appendResult("branches", r.bc, r.b);
		output += "\n" + appendResult("lines", r.lc, r.l);

		output += "\n";
	}

	function appendResult(name:String, count:Int, total:Int)
	{
		var percent = (count == 0 ? 0 : mcover.util.NumberUtil.round((count/total)*100, 2));
		return name + ":" + percent + "%," + count + "/" + total;
	}
}