package mcover.client;

import mcover.CoverageClient;
import mcover.CoverageEntry;
import mcover.CoverageEntryCollection;


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

	var originalTrace:Dynamic;
	var currentEntry:CoverageEntry;
	var output(default, null):String;
	var divider:String;
	var tab:String;

	public function new()
	{
		id = DEFAULT_ID;
		
	
		output = "";
		newline = "\n";
		divider = "----------------------------------------------------------------";
		tab = " ";

		
	}

	public function logEntry(entry:CoverageEntry)
	{
		//null;
	}



	var packageTotal:Int;
	var packageCount:Int;
	var packagePartialCount:Int;

	var classTotal:Int;
	var classCount:Int;
	var classPartialCount:Int;


	public function report(total:Int, count:Int, entries:IntHash<CoverageEntry>,
		classes:Hash<CoverageEntryCollection>, packages:Hash<CoverageEntryCollection>):Dynamic
	{
		output = "";

		var percent = Math.round(count/total*1000)/10;


		print("MCover v0 Coverage Report, generated " + Date.now().toString());
		print(divider);

		printClassResults(classes);

		print(divider);

		printPackageResults(packages);

		print(divider);


		print("");
		print("OVERALL COVERAGE SUMMARY:");
		print("");

		printToTabs(["result","blocks","name"]);
		printToTabs([percent + "%",count + "/" + total,"all classes"]);

		print(divider);

		print("");
		print("OVERALL STATS SUMMARY:");
		print("");
		print("total packages: " + packageCount);
		print("total classes: " + classCount);
		print("total blocks: " + count);
		
		print("");
		print(divider);


		trace(newline + output);

		return output;
	}


	



	function printPackageResults(packages:Hash<CoverageEntryCollection>)
	{
		packageTotal = 0;
		packagePartialCount = 0;
		packageCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");
		printToTabs(["result","blocks","name"]);
		for(pckg in packages)
		{
			packageTotal ++;
			if(pckg.count > 0) packagePartialCount ++;
			if(pckg.percent == 100) packageCount++;


			printToTabs([pckg.percent + "%",pckg.count + "/" + pckg.total, pckg.name]);
			
		}
		
	}



	function printClassResults(classes:Hash<CoverageEntryCollection>)
	{
		classTotal = 0;
		classPartialCount = 0;
		classCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY CLASSES:");
		print("");
		printToTabs(["result","blocks","name"]);
		for(cls in classes)
		{
			classTotal ++;
			if(cls.count > 0) classPartialCount ++;
			if(cls.percent == 100) classCount++;
			printToTabs([cls.percent + "%",cls.count + "/" + cls.total, cls.name]);
	
		}
		
	}

	function generateDetailedResults()
	{
		/*if(VERBOSE_OUTPUT)
		{
			result += "\n" + divider + "\n" + "MCOVER RESULTS" + "\n" + divider + "\nMissing Blocks: \n	" + missing.join("\n	") + "\n";
		}*/

	}


	function print(value:Dynamic)
	{
		output += newline + Std.string(value);
		
	}


	function printToTabs(args:Array<String>)
	{
		var s:String = "";
		for(arg in args)
		{
			s += StringTools.rpad(arg, tab, 16);
		}
		print(s);
	}
	




	

}