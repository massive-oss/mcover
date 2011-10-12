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
import massive.mcover.data.AllClasses;
import massive.mcover.util.Timer;

class PrintClient implements CoverageReportClient
{
		/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(default, default):CoverageReportClient -> Void;


	public var includeMissingBlocks(default, default):Bool;
	public var includeBlockExecutionCounts(default, default):Bool;
	
		
	/**
	 * Newline delimiter. Defaults to '\n' for all platforms except 'js' where it defaults to '<br/>'.
	 * 
	 * <p>
	 * Should be set before the client is passed to a test runner.
	 * </p>
	 */
	public var newline:String;


	public var output(default, null):String;
	var divider:String;
	var tab:String;

	var packageTotal:Int;
	var packageCompletedCount:Int;
	var packagePartialCount:Int;

	var classTotal:Int;
	var classCompletedCount:Int;
	var classPartialCount:Int;

	public function new()
	{
		includeMissingBlocks = true;
		includeBlockExecutionCounts = false;
		output = "";
		newline = "\n";
		tab = " ";
		divider = "----------------------------------------------------------------";
	}
	
	var allClasses:AllClasses;

	public function report(allClasses:AllClasses):Void
	{
		output = "";
	
		this.allClasses = allClasses;
				
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
		print(divider);
		print("MCover v" + MCover.VERSION + " Coverage Report, generated " + Date.now().toString());
		print(divider);

		if(includeBlockExecutionCounts)
		{
			printBlockFrequency();
		}

		if(includeMissingBlocks)
		{
			printMissingBlocks();
		}

	

		printClassResults();
		printPackageResults();


		printSummary();

	}

	function printSummary()
	{
		var r = allClasses.getResults();

		var columnWidth:Int = 20;
		
		print("");
		print(divider);
		print("");
	
		print("OVERALL STATS SUMMARY:");
		print("");
		printToTabs(["total packages", r.pc + " / " + r.p], columnWidth);
		printToTabs(["total files", r.fc + " / " + r.f], columnWidth);
		printToTabs(["total classes", r.cc + " / " + r.c], columnWidth);
		printToTabs(["total methods", r.mc + " / " + r.m], columnWidth);
		printToTabs(["total statements", r.sc + " / " + r.s], columnWidth);
		printToTabs(["total branches", r.bc + " / " + r.b], columnWidth);
		print("");

		print(divider);
		printToTabs(["RESULT", allClasses.getPercentage() + "%"], columnWidth);
		print(divider);
		print("");
	}


	function printPackageResults()
	{
		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");

		var packages = allClasses.getPackages();

		if(Lambda.count(packages) == 0)
		{
			printToTabs(["", "None"]);
			return;
		}

		printToTabs(["", "Result","Files","Classes", "Package"]);
		
		for(pckg in packages)
		{
			var r = pckg.getResults();
			var packgName = (pckg.name == "")? "[Default]" : pckg.name;
			printToTabs(["", pckg.getPercentage() + "%",r.fc + "/" + r.f, r.cc + "/" + r.c, packgName]);
		}
	}

	function printClassResults()
	{
	
		print("");
		print("COVERAGE BREAKDOWN BY CLASSES:");
		print("");
		

		var classes = allClasses.getClasses();

		if(Lambda.count(classes) == 0)
		{
			printToTabs(["", "None"]);
			return;
		}

		printToTabs(["", "Result","Methods","Statements","Branches", "Class"]);
		
		for(cls in classes)
		{
			var r = cls.getResults();
			printToTabs(["", cls.getPercentage() + "%",r.mc + "/" + r.m, r.sc + "/" + r.s, r.bc + "/" + r.b, cls.name]);
		}
	}

	/**
	* Prints summary of branches and statements that have not been executed
	*/
	function printMissingBlocks()
	{
		print("");
		print("NON-EXECUTED BRANCHES:");
		print("");

		var branches = allClasses.getMissingBranches();

		if(Lambda.count(branches) == 0)
		{
			printToTabs(["", "None"]);
		}
		else
		{
			for(block in branches)
			{
				printToTabs(["",  block.toString()]);
			}
		}

		print("");
		print("NON-EXECUTED STATEMENTS:");
		print("");

		var statements = allClasses.getMissingStatements();

		if(Lambda.count(statements) == 0)
		{
			printToTabs(["", "None"]);
		}
		else
		{
			for(block in statements)
			{
				printToTabs(["",  block.toString()]);
			}
		}
	}


	
	/**
	* Outputs all branch and statement logs sorted by highest frequency.
	* For branches reports also totals for true/false  
	*/

	function printBlockFrequency()
	{
		print("");
		print("STATEMENTS BY EXECUTION FREQUENCY:");
		print("");

		var statements:Array<Statement> = [];

		for(key in allClasses.statementResultsById.keys())
		{
			var statement = allClasses.getStatementById(key);
			if(statement.count > 0)
			{
				statements.push(statement);
			}
		}

		if(Lambda.count(statements) == 0)
		{
			printToTabs(["", "None"]);
		}
		else
		{
			var statementSort = function(a:Statement, b:Statement):Int
			{
				return -a.count+b.count;
			}
			statements.sort(statementSort);

			printToTabs(["", "Total", "Statement"]);

			for(statement in statements)
			{
				printToTabs(["", statement.count, statement.toString()]);
			}
		}

		print("");
		print("BRANCHES BY EXECUTION FREQUENCY:");
		print("");

		var branches:Array<Branch> = [];
		for(key in allClasses.branchResultsById.keys())
		{
			var branch = allClasses.getBranchById(key);
			if(branch.totalCount > 0)
			{
				branches.push(branch);
			}
		}

		if(Lambda.count(branches) == 0)
		{
			printToTabs(["", "None"]);
		}
		else
		{
			var branchSort = function(a:Branch, b:Branch):Int
			{
				return -a.totalCount+b.totalCount;
			}

			branches.sort(branchSort);
		
			printToTabs(["", "Total", "True", "False", "Branch"]);
			for(branch in branches)
			{
				printToTabs(["",
					branch.totalCount,
					branch.trueCount,
					branch.falseCount,
					branch.toString()]);
			}
		}
	}

	///////

	function print(value:Dynamic)
	{
		output += newline + Std.string(value);
	}

	function printToTabs(args:Array<Dynamic>, ?columnWidth:Int=14)
	{
		var s:String = "";
		for(arg in args)
		{
			arg = Std.string(arg);
			// #if js
			// 	while(arg.length < columnWidth)
			// 	{
			// 		arg += "|";
			// 	}
			
			// 	s += arg.split("|").join(tab);
			// #else
				s += StringTools.rpad(arg, tab, columnWidth);
			// #end
		}
		print(s);
	}
}
