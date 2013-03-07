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


import massive.munit.client.RichPrintClient;
import massive.munit.TestResult;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.MCoverage;

#if haxe3
import mcover.coverage.DataTypes;
import massive.munit.ITestResultClient;
import haxe.ds.StringMap;
#else
import massive.munit.ITestResultClient;
import mcover.coverage.DataTypes;
private typedef StringMap<T> = Hash<T>
#end

/**
Addes coverage percentage to each test class as well as coverage summary once tests have finished
*/
class MCoverPrintClient implements IAdvancedTestResultClient
{
	/**
	 * Default id of this client.
	 */
	@:extern public static inline var DEFAULT_ID:String = "MCoverPrintClient";

	/**
	 * The unique identifier for the client.
	 */
	public var id(default, null):String;
	
	/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	@:isVar 
	#if haxe3
	public var completionHandler(get, set):ITestResultClient -> Void;
	#else
	public var completionHandler(get_completionHandler, set_completionHandler):ITestResultClient -> Void;
	#end
	function get_completionHandler():ITestResultClient -> Void {return completionHandler;}
	function set_completionHandler(value:ITestResultClient -> Void):ITestResultClient -> Void {return completionHandler = value;}
	
	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeMissingBlocks:Bool;

	/**
	* includes detailed missing class blocks (statements/branches) in output
	*/
	public var includeExecutionFrequency:Bool;


	/**
	* includes detailed coverage data for classes and packages
	*/
	public var includeClassAndPackageBreakdowns:Bool;

	var client:ICoverageTestResultClient;

	var mcoverLogger:CoverageLogger;
	var mcoverClient:mcover.coverage.AdvancedCoverageReportClient;

	var coveredClasses:StringMap<Clazz>;
	var currentCoveredClass:String;
	var classPercentage:Float;

	public function new(
		?munitClient:ICoverageTestResultClient=null,
		?mcoverClient:AdvancedCoverageReportClient=null,
		?mcoverLogger:mcover.coverage.CoverageLogger=null)
	{
		id = DEFAULT_ID;

		if(munitClient == null) munitClient = new RichPrintClient();
		this.client = munitClient;

		if(mcoverClient == null) mcoverClient = new mcover.coverage.client.PrintClient();
		this.mcoverClient = mcoverClient;

		if(mcoverLogger == null) mcoverLogger = initializeMCoverLogger();

		this.mcoverLogger = mcoverLogger;
		
		init();
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



	@IgnoreCover
	function initializeMCoverLogger()
	{
		try
		{
			return MCoverage.getLogger();	
		}
		catch(e:Dynamic)
		{
			var msg = "ERROR: Unable to initialize MCover Logger\n" + e;

			trace(msg);
		}

		return null;
	}

	function init()
	{
		#if (neko||cpp||php)
			var VERBOSE:Bool = false;
		#else
			var VERBOSE:Bool = Std.is(client, RichPrintClient);
		#end
		
		includeMissingBlocks = VERBOSE;
		includeExecutionFrequency = VERBOSE;
		includeClassAndPackageBreakdowns = VERBOSE;
		
		currentCoveredClass = null;
		classPercentage = 0;
		coveredClasses = new StringMap();

		mcoverClient.includeMissingBlocks = includeMissingBlocks;
		mcoverClient.includeExecutionFrequency = includeExecutionFrequency;
		mcoverLogger.addClient(mcoverClient);	
	}

	public function setCurrentTestClass(className:String):Void
	{
		var hasMatch = className != null && className.lastIndexOf("Test") == className.length-4;

		var coveredClassName :String = hasMatch ? className.substr(0, className.length-4) : null;
	
		var hasChanged = currentCoveredClass != coveredClassName;

		if(hasChanged && currentCoveredClass != null)
		{
			if(mcoverLogger.currentTest != null)
			{
				updateTestClassCoverage();
			}	
		}

		client.setCurrentTestClass(className);

		if(hasChanged)
		{
			currentCoveredClass = coveredClassName;
			mcoverLogger.currentTest = currentCoveredClass;
		}
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
		updateFinalCoverageReport();

		var result = client.reportFinalStatistics(testCount, passCount, failCount, errorCount, ignoreCount, time);
		
		if (completionHandler != null) completionHandler(this); 

		return result;
	}

	function updateTestClassCoverage()
	{
		mcoverLogger.reportCurrentTest(true);

		var cls = mcoverLogger.coverage.getClassByName(currentCoveredClass);

		if(cls == null) return;

		coveredClasses.set(cls.name, cls);
		
		classPercentage = cls.getPercentage();

		var coverageResult = createCoverageResultForClass(cls);

		client.setCurrentTestClassCoverage(coverageResult);	
	}

	//////////
	function updateFinalCoverageReport()
	{
		mcoverLogger.report(false);

		var percent = mcoverLogger.coverage.getPercentage();

		var coverageResults:Array<CoverageResult> = null;
		var executionFrequencies:String = null;
		var classBreakdown:String = null;
		var packageBreakdown:String = null;

		if(includeMissingBlocks)
		{
			coverageResults = createOutstandingCoverageResults();
		}
		
		if(includeClassAndPackageBreakdowns)
		{
			classBreakdown = mcoverClient.classBreakdown;
			packageBreakdown = mcoverClient.packageBreakdown;	
		}

		if(includeExecutionFrequency)
		{
			executionFrequencies = mcoverClient.executionFrequency;
		}

		var summary = mcoverClient.summary + "\n" + mcoverClient.overallPercentage;
		
		client.reportFinalCoverage(
				percent,
				coverageResults,
				summary,
				classBreakdown,
				packageBreakdown,
				executionFrequencies
			);
	}

	function createOutstandingCoverageResults():Array<CoverageResult>
	{
		var classes = mcoverLogger.coverage.getClasses();
		var results:Array<CoverageResult> = [];
		for(cls in classes)
		{
			if(cls.getPercentage() == 100) continue;
			//if(coveredClasses.exists(cls.name)) continue;

			var result = createCoverageResultForClass(cls);
			results.push(result);
		}
		return results;
	}
	////
	function createCoverageResultForClass(cls:Clazz):CoverageResult
	{
		var percent = cls.getPercentage();
		var blocks:Array<String> = [];

		if(percent != 100 && includeMissingBlocks)
		{
			var str:String = "";
			var statements = cls.getMissingStatements();

			if(statements.length > 0)
			{
				for(block in statements)
				{
					var blockString = block.methodName + " (" + block.location + ")";
					if(str != "") str += "\n";

					str += blockString;
				}
				blocks.push(str);
			}

			var branches = cls.getMissingBranches();
			if(branches.length > 0)
			{
				str = "";
				for(block in branches)
				{
					var blockString =block.methodName + " (" + block.location + ")";
					if(!block.isCovered())
					{
						blockString += " ";
						if(block.trueCount == 0) blockString += "t";
						if(block.trueCount == 0 && block.falseCount == 0) blockString +=",";
						if(block.falseCount == 0) blockString += "f";
					
					}
					if(str != "") str += "\n";
					str += blockString;
				}
				blocks.push(str);
			}
		}

		
		return {className:cls.name, percent:percent, blocks:blocks};
	}
}