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

package massive.mcover.client;

import massive.mcover.CoverageReportClient;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.Coverage;
import massive.mcover.util.Timer;

class PrintClient implements AdvancedCoverageReportClient
{
		/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(default, default):CoverageReportClient -> Void;

	public var includeHeader(default, default):Bool;
	public var includeMissingBlocks(default, default):Bool;
	public var includeExecutionFrequency(default, default):Bool;
	public var includeClassBreakdown(default, default):Bool;
	public var includePackageBreakdown(default, default):Bool;
	public var includeOverallPercentage(default, default):Bool;
	public var includeSummary(default, default):Bool;
	
	public var maxBlockExecutionListSize(default, default):Int;
		
	/**
	 * Newline delimiter. Defaults to '\n' for all platforms except 'js' where it defaults to '<br/>'.
	 * 
	 * <p>
	 * Should be set before the client is passed to a test runner.
	 * </p>
	 */
	public var newline:String;

	public var output(default, null):String;

	public var header(default, null):String;
	public var executionFrequency(default, null):String;
	public var missingBlocks(default, null):String;
	public var classBreakdown(default, null):String;
	public var packageBreakdown(default, null):String;
	public var summary(default, null):String;
	public var overallPercentage(default, null):String;

	var divider:String;
	var tab:String;

	var packageTotal:Int;
	var packageCompletedCount:Int;
	var packagePartialCount:Int;

	var classTotal:Int;
	var classCompletedCount:Int;
	var classPartialCount:Int;

	static inline var DEFAULT_TAB_WIDTH:Int = 11;
	static inline var SHORT_FIRST_TAB_WIDTH:Int = 4;
	static inline var LONG_FIRST_TAB_WIDTH:Int = 20;
			
	public function new()
	{
		includeHeader = true;
		includeMissingBlocks = true;
		includeExecutionFrequency = true;
		includeClassBreakdown = true;
		includePackageBreakdown = true;
		includeSummary = true;
		includeOverallPercentage = true;
		
		maxBlockExecutionListSize = 25;
		newline = "\n";
		tab = " ";
		divider = newline + "----------------------------------------------------------------";
	}
	
	var coverage:Coverage;

	public function report(coverage:Coverage):Void
	{
		output = "";
		header = "";
		executionFrequency = "";
		missingBlocks = "";
		classBreakdown = "";
		packageBreakdown = "";
		summary = "";
		overallPercentage = "";
	
		this.coverage = coverage;
				
		printReport();

		var timer = Timer.delay(reportComplete, 10);
	}

	function reportComplete()
	{
		if(completionHandler != null)
		{
			completionHandler(this);
		}
	}

	function printReport()
	{	
		header = serializeHeader();
		executionFrequency = serializeExecutionFrequency();
		missingBlocks = serializeMissingBlocks();
		classBreakdown = serializeClassResults();
		packageBreakdown = serializePackageResults();
		summary = serializeSummary();
		overallPercentage = serializeOverallPercentage();

		output = serializeFinalOutput();
	}

	function serializeFinalOutput():String
	{
		var output = "";
	
		if(includeHeader)
		{
			output += divider;
			output += newline;
			output += header;
			output += divider;
			output += newline;
		}

		if(includeExecutionFrequency)
		{
			output += executionFrequency;
		}

		if(includeMissingBlocks)
		{
			output += newline;
			output += missingBlocks;
		}
	
		if(includeClassBreakdown)
		{
			output += newline;
			output += classBreakdown;
		}

		if(includePackageBreakdown)
		{
			output += newline;
			output += packageBreakdown;
		}	
		
		if(includeSummary)
		{
			output += newline;
			output += divider;
			output += newline;
			output += summary;
			output += newline;
		}
	
		if(includeOverallPercentage)
		{
			output += divider;
			output += overallPercentage;
			output += divider;
			output += newline;
		}

		return output;
	}

	function serializeHeader():String
	{
		return "MCover v" + MCover.VERSION + " Coverage Report, generated " + Date.now().toString();
	}

	function serializeOverallPercentage():String
	{
		return printTabs(["COVERAGE RESULT", coverage.getPercentage() + "%"], LONG_FIRST_TAB_WIDTH);
	}

	function serializeSummary():String
	{
		var output = "";
		var r = coverage.getResults();

		var w:Int = LONG_FIRST_TAB_WIDTH;

		output = printLine("OVERALL COVERAGE STATS:");
		output += printLine("");
		output += printTabs(["total packages", r.pc + " / " + r.p], w);
		output += printTabs(["total files", r.fc + " / " + r.f], w);
		output += printTabs(["total classes", r.cc + " / " + r.c], w);
		output += printTabs(["total methods", r.mc + " / " + r.m], w);
		output += printTabs(["total statements", r.sc + " / " + r.s], w);
		output += printTabs(["total branches", r.bc + " / " + r.b], w);
		
		return output;
	}

	function serializePackageResults():String
	{
		var output = "";
		output = printLine("COVERAGE BREAKDOWN BY PACKAGE:");
		output += newline;

		var packages = coverage.getPackages();

		if(Lambda.count(packages) == 0)
		{
			output += printTabs(["", "None"]);
			return output;
		}

		output += printTabs(["", "Result","Files","Classes", "Package"]);
		
		for(pckg in packages)
		{
			var r = pckg.getResults();
			var packgName = (pckg.name == "")? "[Default]" : pckg.name;
			output += printTabs(["", pckg.getPercentage() + "%",r.fc + "/" + r.f, r.cc + "/" + r.c, packgName]);
		}

		return output;
	}

	function serializeClassResults():String
	{
		var output = "";
	
		output = printLine("COVERAGE BREAKDOWN BY CLASSES:");
		output += newline;
		
		var classes = coverage.getClasses();

		if(Lambda.count(classes) == 0)
		{
			output += printTabs(["", "None"]);
			return output;
		}

		output += printTabs(["", "Result","Methods","Statements","Branches", "Class"]);
		
		for(cls in classes)
		{
			var r = cls.getResults();
			output += printTabs(["", cls.getPercentage() + "%",r.mc + "/" + r.m, r.sc + "/" + r.s, r.bc + "/" + r.b, cls.name]);
		}

		return output;
	}

	/**
	* Prints summary of branches and statements that have not been executed
	*/
	function serializeMissingBlocks():String
	{
		var output = "";
		
		output = printLine("MISSING STATEMENT COVERAGE:");
		output += newline;

		var statements = coverage.getMissingStatements();

		if(Lambda.count(statements) == 0)
		{
			output += printTabs(["", "None"]);
		}
		else
		{
			var currentClass = null;
			for(block in statements)
			{
				if(currentClass != block.qualifiedClassName)
				{
					currentClass =  block.qualifiedClassName;
					output += printTabs(["",  "Class: " + block.qualifiedClassName]);
				}

				output += printTabs(["", block.toLocalString()], SHORT_FIRST_TAB_WIDTH*2);

			}
		}

		output += newline;
		output += printLine("MISSING BRANCH COVERAGE:");
		output += newline;

		var branches = coverage.getMissingBranches();

		if(Lambda.count(branches) == 0)
		{
			output += printTabs(["", "None"]);
		}
		else
		{
			var currentClass = null;
			for(block in branches)
			{
				if(currentClass != block.qualifiedClassName)
				{
					currentClass =  block.qualifiedClassName;
					output += printTabs(["",  "Class: " + block.qualifiedClassName]);
				}

				output += printTabs(["", block.toLocalString()], SHORT_FIRST_TAB_WIDTH*2);
			}
		}
		return output;
	}



	
	/**
	* Outputs all branch and statement logs sorted by highest frequency.
	* For branches reports also totals for true/false  
	*/

	function serializeExecutionFrequency():String
	{
		var output = "";


		var statements:Array<Statement> = [];

		for(key in coverage.statementResultsById.keys())
		{
			var statement = coverage.getStatementById(key);
			if(statement.count > 0)
			{
				statements.push(statement);
			}
		}

		output = printLine("TOP " + maxBlockExecutionListSize + " STATEMENTS BY EXECUTION FREQUENCY:");
		output += newline;

		if(Lambda.count(statements) == 0)
		{
			output += printTabs(["", "None"]);
		}
		else
		{
			var statementSort = function(a:Statement, b:Statement):Int
			{
				return -a.count+b.count;
			}
			statements.sort(statementSort);

			output += printTabs(["", "Count", "Statement"]);
			
			var count = 0;
			for(statement in statements)
			{
				output += printTabs(["", statement.count, statement.toString()]);
				count ++;
				if(count >= maxBlockExecutionListSize)
				{
					break;
				}
			}
		}

		var branches:Array<Branch> = [];
		for(key in coverage.branchResultsById.keys())
		{
			var branch = coverage.getBranchById(key);
			if(branch.totalCount > 0)
			{
				branches.push(branch);
			}
		}

		output += newline;
		output += printLine("TOP " + maxBlockExecutionListSize + " BRANCHES BY EXECUTION FREQUENCY:");
		
		output += newline;

		if(Lambda.count(branches) == 0)
		{
			output += printTabs(["", "None"]);
		}
		else
		{
			var branchSort = function(a:Branch, b:Branch):Int
			{
				return -a.totalCount+b.totalCount;
			}

			branches.sort(branchSort);
		
			output += printTabs(["", "Count", "True", "False", "Branch"]);

			var count = 0;
			for(branch in branches)
			{
				output += printTabs(["",
					branch.totalCount,
					branch.trueCount,
					branch.falseCount,
					branch.toString()]);
				count ++;
				if(count >= maxBlockExecutionListSize)
				{
					break;
				}
			}
		}
		return output;
	}

	///////

	function printLine(value:Dynamic):String
	{
		return newline + Std.string(value);
	}

	function printTabs(args:Array<Dynamic>,?initialColumnWidth=SHORT_FIRST_TAB_WIDTH, ?columnWidth:Int=DEFAULT_TAB_WIDTH):String
	{
		var s:String = "";
		var isFirst:Bool = true;

		for(arg in args)
		{
			arg = Std.string(arg);
			if(isFirst)
			{
				isFirst = false;
				s += StringTools.rpad(arg, tab, initialColumnWidth);
			}
			else
			{
				s += StringTools.rpad(arg, tab, columnWidth);
			}
			
		}
		return newline + s;
	}
}
