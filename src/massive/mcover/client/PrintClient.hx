package massive.mcover.client;

import massive.mcover.CoverageClient;
import massive.mcover.CodeBlock;
import massive.mcover.CoverageData;


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

	public function log(block:CodeBlock)
	{
		//null;
	}
	
	var data:CoverageData;

	public function report(data:CoverageData):Dynamic
	{
		output = "";
	
		this.data = data;

		printReport();

		if (completionHandler != null)
		{
			completionHandler(this);
		}
		return output;
	}

	function printReport()
	{

		print("MCover v0 Coverage Report, generated " + Date.now().toString());
		print(divider);

		#if MCOVER_DEBUG
		printCoveredBlocks();
		#end

		if(data.percent != 100)
		{
			printMissingBlocks();
		}

		printClassResults();
		printPackageResults();

		print("");
		print(divider);
		print("");
		print("OVERALL STATS SUMMARY:");
		
		print("");

		printToTabs(["total files", Lambda.count(data.files)], 16);
		printToTabs(["total packages", packagePartialCount + " /" + packageTotal], 16);
		
		printToTabs(["total classes", classPartialCount + " /" + classTotal], 16);
		printToTabs(["total blocks", data.count + " /" + data.total], 16);
		
		print("");
		printToTabs(["RESULT", data.percent + "%"], 16);
		print("");
		print(divider);
	}

	function printMissingBlocks()
	{
		print("");
		print("MISSING CODE BLOCKS:");
		print("");

		for(i in 0...Lambda.count(data.blocks))
		{
			var block = data.blocks.get(i);
			if(!block.hasCount()) printToTabs(["",  block.toString()]);
		}
	}

	function printCoveredBlocks()
	{
		print("");
		print("COVERED CODE BLOCKS:");
		print("");
		for(i in 0...Lambda.count(data.blocks))
		{
			var block = data.blocks.get(i);
			if(block.hasCount()) printToTabs(["", block.toString()]);
		}
	}

	function printPackageResults()
	{
		packageTotal = 0;
		packagePartialCount = 0;
		packageCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");
		printToTabs(["", "result","blocks","package"]);
		for(pckg in data.packages)
		{
			packageTotal += 1;
			if(pckg.count > 0) packagePartialCount += 1;
			if(pckg.percent == 100) packageCompletedCount += 1;

			printToTabs(["", pckg.percent + "%",pckg.count + "/" + pckg.total, pckg.name=="" ? "[Default]": pckg.name]);
		}
	}

	function printClassResults()
	{
		classTotal = 0;
		classPartialCount = 0;
		classCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY CLASSES:");
		print("");
		printToTabs(["", "result","methods","blocks","class"]);

		for(cls in data.classes)
		{
			classTotal += 1;
			if(cls.count > 0) classPartialCount += 1;
			if(cls.percent == 100) classCompletedCount += 1;

			var methodTotals:Hash<Int> = new Hash();
			var methodCounts:Hash<Int> = new Hash();

			for(i in cls.blocks)
			{
				var block = data.blocks.get(i);
		
				var key:String = block.methodName;
				var value:Int = block.hasCount() ? 1 : 0;

				if(!methodTotals.exists(key))
				{
					methodTotals.set(key, 1);
					methodCounts.set(key, value);
				}
				else
				{
					methodTotals.set(key, methodTotals.get(key) + 1);
					methodCounts.set(key, methodCounts.get(key) + value);
				}
			}

			var methodTotal:Int = Lambda.count(methodTotals);
			var methodCount:Int = 0;

			for(key in methodTotals.keys())
			{
				if(methodCounts.get(key) > 0) methodCount += 1;
			}
			
			printToTabs(["", cls.percent + "%",methodCount + "/" + methodTotal, cls.count + "/" + cls.total, cls.name]);
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
