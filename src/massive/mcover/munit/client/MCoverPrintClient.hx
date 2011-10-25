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

import massive.munit.AssertionException;
import massive.munit.ITestResultClient;
import massive.munit.TestResult;
import massive.munit.util.MathUtil;
import massive.haxe.util.ReflectUtil;
import massive.munit.util.Timer;

import massive.mcover.MCover;
import massive.mcover.CoverageLogger;
import massive.mcover.client.PrintClient;
import massive.mcover.data.Clazz;

import massive.munit.client.PrintClientHelper;

@IgnoreCover
class MCoverPrintClient extends massive.munit.client.PrintClient
{
	/**
	 * Default id of this client.
	 */
	public inline static var DEFAULT_ID:String = "MCoverPrintClient";

	var logger:CoverageLogger;
	var coverClient:massive.mcover.client.PrintClient;
	var coveredClasses:Hash<Clazz>;
	
	var currentCoveredClass:String;

	var classPercentage:Float;


	

	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeMissingBlocks:Bool;

	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeExecutionFrequency:Bool;
	
	/**
	 * 
	 * @param	includeIgnoredReport				flag to pass through to PrintClient
	 */
	public function new(?includeIgnoredReport:Bool = false)
	{
		super(includeIgnoredReport);
		id = DEFAULT_ID;

		includeMissingBlocks = useHTML;
		includeExecutionFrequency = useHTML;
	}

	override function init()
	{
		super.init();
		classPercentage = 0;
		coveredClasses = new Hash();
		try
		{
			logger = MCover.getLogger();
			coverClient = new massive.mcover.client.PrintClient();
			
			//coverClient.includeMissingBlocks = includeMissingBlocks;
			//coverClient.includeExecutionFrequency = includeExecutionFrequency;
			logger.addClient(coverClient);
		}
		catch(e:Dynamic)
		{
			var msg = "ERROR: Unable to initialize MCover Reporter\n" + e;
			
			if(useHTML)
			{
				helper.printLine(msg);
			}
			else
			{
				printLine(msg);
			}
		}
	}

	override function createNewTestClass(result:TestResult)
	{
		super.createNewTestClass(result);
		currentCoveredClass = result.className.substr(0, result.className.length-4);
		logger.currentTest = currentCoveredClass;
	}

	override function updateLastTestResult()
	{
		printTestCoverage();
		super.updateLastTestResult();
	} 

	override function getLastTestResult():TestResultState
	{
		var result = super.getLastTestResult();

		if(result == TestResultState.PASSED && classPercentage != 100)
		{
			result = TestResultState.WARNING;
		}
		return result;
	}


	function printTestCoverage()
	{
		if(logger.currentTest == null) return;

		logger.reportCurrentTest(true);

		var cls = logger.coverage.getClassByName(currentCoveredClass);
		
		if(cls != null)
		{
			classPercentage = cls.getPercentage();

			coveredClasses.set(cls.name, cls);
			

			var summaryStr = " [" + classPercentage + "%]";
			
			if(useHTML)
			{
				helper.updateTestSummary(summaryStr);
			}
			else
			{
				print(summaryStr);
			}
			

			if(classPercentage == 100 || !includeMissingBlocks)  return;

			if(useHTML)
			{
				helper.addTestCoverageClass(cls.name, classPercentage);
				printMissingClassBlocks(cls);
			}
	
			
		}	
	}
	
	function printMissingClassBlocks(cls:Clazz)
	{

		if(cls.getPercentage() == 100 ) return;

		var statements = cls.getMissingStatements();


		var str:String = "";

		if(statements.length > 0)
		{
			for(block in statements)
			{
		
				var blockString =block.methodName + " | " + block.location;
				if(str != "") str += "\n";
				str += blockString;

			}

			if(useHTML)
			{
				helper.addTestCoverageItem(str);
			}
			else
			{
				var lines = str.split("\n");
				for(line in lines)
				{
					printLine(line, 1);
				}
			}
			
		}



		var branches = cls.getMissingBranches();

		if(branches.length > 0)
		{
			str = "";

			for(block in branches)
			{
			
				var blockString =block.methodName + " | " + block.location;
				if(!block.isCovered())
				{
					blockString += " | ";
					if(block.trueCount == 0) blockString += "t";
					if(block.trueCount == 0 && block.falseCount == 0) blockString +=",";
					if(block.falseCount == 0) blockString += "f";
				
				}
				if(str != "") str += "\n";
				str += blockString;

			}

			if(useHTML)
			{
				helper.addTestCoverageItem(str);
			}
			else
			{
				var lines = str.split("\n");
				for(line in lines)
				{
					printLine(line, 1);
				}
			}
		}

	}


	//////////
	override function printFinalReports()
	{
		super.printFinalReports();
		logger.report();

		var percentage = logger.coverage.getPercentage();


		if(useHTML)
		{
			helper.createCoverageReport(percentage);
		}

		if(includeMissingBlocks)
		{
			if(!useHTML)
			{
				printLine("");
				printLine("Code Coverage Results: " + percentage + "%");
				printLine(divider);
			}

			printOutstandingMissingClasses();
		}
			

		if(useHTML)
		{
			helper.addCoverageSummary(coverClient.output);
		}
		else
		{
			printLine(coverClient.output);

		}
	}

	function printOutstandingMissingClasses()
	{
		var classes = logger.coverage.getClasses();
		
		for(cls in classes)
		{
		

			if(cls.getPercentage() == 100) continue;

			if(useHTML)
			{
				helper.addMissingCoverageClass(cls.name, cls.getPercentage() );
			}
			else
			{
				printLine("Coverage: " + cls.name + " [" + cls.getPercentage() + "%]");
			}

			printMissingClassBlocks(cls);

		}
	}
}