package massive.mcover.client;

import massive.mcover.CoverageClient;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.AllClasses;


class PrintClient implements CoverageClient
{
	/**
	 * Default id of this client.
	 */
	public static inline var DEFAULT_ID:String = "print";

	/**
	 * The unique identifier for the client.
	 */
	public var id(default, null):String;

	/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(get_completeHandler, set_completeHandler):CoverageClient -> Void;
	function get_completeHandler():CoverageClient -> Void 
	{
		return completionHandler;
	}
	function set_completeHandler(value:CoverageClient -> Void):CoverageClient -> Void
	{
		return completionHandler = value;
	}

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

	public function new(?id:String=null)
	{
		if(id == null) id = DEFAULT_ID;
		this.id = id;
		
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

	public function report(allClasses:AllClasses):Dynamic
	{
		output = "";
	
		this.allClasses = allClasses;


		printReport();

		if (completionHandler != null)
		{
			completionHandler(this);
		}
		return output;
	}

	function printReport()
	{
		print(divider);
		print("MCover v0.2 Coverage Report, generated " + Date.now().toString());
		print(divider);

		// #if MCOVER_DEBUG
		// printCoveredBlocks();
		// #end

		if(allClasses.getPercentage() != 100)
		{
			printMissingBlocks();
		}

		printClassResults();
		printPackageResults();

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
		return;
	}

	function printMissingBlocks()
	{
		print("");
		print("MISSING BRANCH BLOCKS:");
		print("");

		var branches = allClasses.getMissingBranches();

		for(block in branches)
		{
			printToTabs(["",  block.toString()]);
		}

		print("");
		print("MISSING STATEMENT BLOCKS:");
		print("");

		var statements = allClasses.getMissingStatements();

		for(block in statements)
		{
			printToTabs(["",  block.toString()]);
		}

	
	}

	function printPackageResults()
	{
		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");
		printToTabs(["", "result","files","classes", "package"]);

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
		printToTabs(["", "result","methods","statements","branches", "class"]);

		var classes = allClasses.getClasses();
		
		for(cls in classes)
		{
			var r = cls.getResults();
			printToTabs(["", cls.getPercentage() + "%",r.mc + "/" + r.m, r.sc + "/" + r.s, r.bc + "/" + r.b, cls.name]);
		}
	}

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
