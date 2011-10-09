package massive.mcover.client;

import massive.mcover.CoverageClient;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.AllClasses;


class PrintClient implements CoverageClient
{
		/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(default, default):CoverageClient -> Void;


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

	public function logStatement(statement:Statement)
	{
		//null;
	}

	public function logBranch(branch:Branch)
	{
		//null;
	}
	
	var allClasses:AllClasses;

	public function report(allClasses:AllClasses):Void
	{
		output = "";
	
		this.allClasses = allClasses;
				
		printReport();

		if (completionHandler != null)
		{
			completionHandler(this);
		}
	}

	function printReport()
	{
		print(divider);
		print("MCover v0.4 Coverage Report, generated " + Date.now().toString());
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
		printToTabs(["", "Result","Files","Classes", "Package"]);

		var packages = allClasses.getPackages();
		
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
		printToTabs(["", "Result","Methods","Statements","Branches", "Class"]);

		var classes = allClasses.getClasses();
		
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

		if(allClasses.getPercentage() == 100 )
		{
			printToTabs(["",  "None"]);
		}
		else
		{
			var branches = allClasses.getMissingBranches();
			for(block in branches)
			{
				printToTabs(["",  block.toString()]);
			}
		}

		print("");
		print("NON-EXECUTED statements:");
		print("");

		if(allClasses.getPercentage() == 100 )
		{
			printToTabs(["",  "None"]);
		}
		else
		{
			var statements = allClasses.getMissingStatements();
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
			statements.push(allClasses.getStatementById(key));
		}
		statements.sort(function(a, b){return -a.count+b.count;});

		printToTabs(["", "Total", "Statement"]);

		for(statement in statements)
		{
			printToTabs(["", statement.count, statement.toString()]);

		}

		print("");
		print("BRANCHES BY EXECUTION FREQUENCY:");
		print("");

		var branches:Array<Branch> = [];

		for(key in allClasses.branchResultsById.keys())
		{
			branches.push(allClasses.getBranchById(key));
		}
		
		branches.sort(function(a, b){return -a.totalCount+b.totalCount;});

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
			#if js
				while(arg.length < columnWidth)
				{
					arg += "|";
				}
			
				s += arg.split("|").join(tab);
			#else
				s += StringTools.rpad(arg, tab, columnWidth);
			#end
		}
		print(s);
	}
}
