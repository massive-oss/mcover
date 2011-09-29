package massive.mcover.client;

import massive.mcover.CoverageClient;
import massive.mcover.CoverageEntry;
import massive.mcover.CoverageEntryCollection;

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


	public function new()
	{
		id = DEFAULT_ID;
		
		output = "";
		newline = "\n";
		tab = " ";
		divider = "----------------------------------------------------------------";
	}

	public function logEntry(entry:CoverageEntry)
	{
		//null;
	}

	var total:Int;
	var count:Int;
	var entries:IntHash<CoverageEntry>;
	var classes:Hash<CoverageEntryCollection>;
	var packages:Hash<CoverageEntryCollection>;
		

	public function report(total:Int, count:Int, entries:IntHash<CoverageEntry>,
		classes:Hash<CoverageEntryCollection>, packages:Hash<CoverageEntryCollection>):Dynamic
	{
		output = "";

		this.total = total;
		this.count = count;
		this.entries = entries;
		this.classes = classes;
		this.packages = packages;

		printReport();

		if (completionHandler != null)
		{
			completionHandler(this);
		}

		return output;
	}

	function printReport()
	{
		var percent = Math.round(count/total*1000)/10;

		print("MCover v0 Coverage Report, generated " + Date.now().toString());
		print(divider);

		printClassResults(classes);
		print(divider);
		printPackageResults(packages);
		print(divider);

		print("");
		print("OVERALL STATS SUMMARY:");
		print("");

		printToTabs(["total packages", packagePartialCount], 20);
		printToTabs(["total classes", classPartialCount], 20);
		printToTabs(["total blocks", count], 20);
		
		print("");
		printToTabs(["RESULT", percent + "%"], 20);
		print("");
		print(divider);
	}

	function printPackageResults(packages:Hash<CoverageEntryCollection>)
	{
		packageTotal = 0;
		packagePartialCount = 0;
		packageCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");
		printToTabs(["result","blocks","package"]);
		for(pckg in packages)
		{
			packageTotal += 1;
			if(pckg.count > 0) packagePartialCount += 1;
			if(pckg.percent == 100) packageCompletedCount += 1;


			printToTabs([pckg.percent + "%",pckg.count + "/" + pckg.total, pckg.name]);
		}
	}

	function printClassResults(classes:Hash<CoverageEntryCollection>)
	{
		classTotal = 0;
		classPartialCount = 0;
		classCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY CLASSES:");
		print("");
		printToTabs(["result","blocks","class"]);
		for(cls in classes)
		{
			classTotal += 1;
			if(cls.count > 0) classPartialCount += 1;
			if(cls.percent == 100) classCompletedCount += 1;
			printToTabs([cls.percent + "%",cls.count + "/" + cls.total, cls.name]);
		}
	}

	function print(value:Dynamic)
	{
		output += newline + Std.string(value);
	}

	function printToTabs(args:Array<Dynamic>, ?columnWidth:Int=10)
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