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
import massive.munit.client.RichPrintClient;
import massive.munit.TestResult;
import massive.mcover.CoverageReportClient;
import massive.mcover.data.Clazz;


class MCoverPrintClient implements IAdvancedTestResultClient
{
	/**
	 * Default id of this client.
	 */
	public static inline var DEFAULT_ID:String = "MCoverPrintClient";

	/**
	 * The unique identifier for the client.
	 */
	public var id(default, null):String;
	
	/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(get_completeHandler, set_completeHandler):ITestResultClient -> Void;
	function get_completeHandler():ITestResultClient -> Void {return completionHandler;}
	function set_completeHandler(value:ITestResultClient -> Void):ITestResultClient -> Void {return completionHandler = value;}
	

	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeMissingBlocks:Bool;

	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeExecutionFrequency:Bool;

	var client:IAdvancedTestResultClient;
	var logger:CoverageLogger;

	var coverClient:massive.mcover.AdvancedCoverageReportClient;
	var coveredClasses:Hash<Clazz>;
	var currentCoveredClass:String;
	var classPercentage:Float;

	var helper:RichPrintClientHelper;
	var isRichClient:Bool;
	var divider:String;

	public function new(
		?munitClient:IAdvancedTestResultClient=null,
		?helper:RichPrintClientHelper=null,
		?mcoverClient:AdvancedCoverageReportClient=null,
		?logger:massive.mcover.CoverageLogger=null)
	{
		id = DEFAULT_ID;

		if(munitClient == null) munitClient = new RichPrintClient(true);
		this.client = munitClient;

		if(helper == null) helper = new RichPrintClientHelper();
		this.helper = helper;


		if(mcoverClient == null) mcoverClient = new massive.mcover.client.PrintClient();
		this.coverClient = mcoverClient;

		if(logger == null) logger = createDefaultLogger();

		this.logger = logger;
		
		init();
	}

	@IgnoreCover
	function createDefaultLogger()
	{
		try
		{
			return MCover.getLogger();	
		}
		catch(e:Dynamic)
		{
			var msg = "ERROR: Unable to initialize MCover Reporter\n" + e;
			
			printLine(msg);
		}

		return null;
	}


	function init()
	{
		divider = "------------------------------";
		if(Std.is(client, massive.munit.client.RichPrintClient))
		{
			#if (js || flash)
				isRichClient = true;
			#else
				isRichClient = false;
			#end
		}
		else
		{
			isRichClient = false;
		}


		includeMissingBlocks = isRichClient;
		includeExecutionFrequency = isRichClient;
		
		currentCoveredClass = null;
		classPercentage = 0;
		coveredClasses = new Hash();

		coverClient.includeMissingBlocks = true;
		coverClient.includeExecutionFrequency = true;
		logger.addClient(coverClient);
		
		
	}


	public function setCurrentTestClass(className:String):Void
	{

		var endsWithTest = className != null && className.lastIndexOf("Test") == className.length-4;

		var coveredClassName :String = null;

		if(endsWithTest)
		{
			coveredClassName = className.substr(0, className.length-4);
		}
	
		var hasChanged = currentCoveredClass != coveredClassName;

		if(hasChanged && currentCoveredClass != null)
		{
			printTestCoverage();
		}

		client.setCurrentTestClass(className);

		if(hasChanged)
		{
			currentCoveredClass = coveredClassName;
			logger.currentTest = currentCoveredClass;
		}
	}

	/**
	 * Called when a test passes.
	 *  
	 * @param	result			a passed test result
	 */
	public function addPass(result:TestResult):Void
	{
		client.addPass(result);
	}

	/**
	 * Called when a test fails.
	 *  
	 * @param	result			a failed test result
	 */
	public function addFail(result:TestResult):Void
	{
		client.addFail(result);
	}

	/**
	 * Called when a test triggers an unexpected exception.
	 *  
	 * @param	result			an erroneous test result
	 */
	public function addError(result:TestResult):Void
	{
		client.addError(result);
	}
	
	/**
	 * Called when a test has been ignored.
	 *
	 * @param	result			an ignored test
	 */
	public function addIgnore(result:TestResult):Void
	{
		client.addIgnore(result);	
	}

	/**
	 * Called when all tests are complete.
	 *  
	 * @param	testCount		total number of tests run
	 * @param	passCount		total number of tests which passed
	 * @param	failCount		total number of tests which failed
	 * @param	errorCount		total number of tests which were erroneous
	 * @param	ignoreCount		total number of ignored tests
	 * @param	time			number of milliseconds taken for all tests to be executed
	 * @return	collated test result data if any
	 */
	public function reportFinalStatistics(testCount:Int, passCount:Int, failCount:Int, errorCount:Int, ignoreCount:Int, time:Float):Dynamic
	{
		printFinalCoverageReports();

		var result = client.reportFinalStatistics(testCount, passCount, failCount, errorCount, ignoreCount, time);
		
		if (completionHandler != null) completionHandler(this); 

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
			
			if(isRichClient)
			{
				helper.updateTestSummary(summaryStr);
			}
			else
			{
				print(summaryStr);
			}
			

			if(classPercentage == 100 || !includeMissingBlocks)  return;

			if(isRichClient)
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

			if(isRichClient)
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

			if(isRichClient)
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
	function printFinalCoverageReports()
	{
		logger.report();

		var percentage = logger.coverage.getPercentage();

		if(isRichClient)
		{
			helper.createCoverageReport(percentage);
		}

		if(includeMissingBlocks)
		{
			if(!isRichClient)
			{
				printLine("");
				printLine("Code Coverage Results: " + percentage + "%");
				printLine(divider);
			}
			printOutstandingMissingClasses();
		}
			
		if(isRichClient)
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
			if(coveredClasses.exists(cls.name)) continue;

			if(isRichClient)
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



	////////

	function print(value:Dynamic)
	{
		helper.print(value);
	}

	function printLine(value, ?indent:Int = 0)
	{
		if(indent > 0)
		{
			value = StringTools.lpad("", " ", indent*4) + value;
		}
		helper.printLine(value);
	}
}