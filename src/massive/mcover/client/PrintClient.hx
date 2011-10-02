package massive.mcover.client;

import massive.mcover.CoverageClient;
import massive.mcover.CodeBlock;
import massive.mcover.CodeBlockCollection;

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
	

	var total:Int;
	var count:Int;
	var data:CoverageData;
	
	var packages:Hash<CodeBlockCollection>;
	var files:Hash<CodeBlockCollection>;
	var classes:Hash<CodeBlockCollection>;
	var methods:Hash<CodeBlockCollection>;
		

	public function report(total:Int, count:Int, data:CoverageData):Dynamic
	{
		output = "";
	
		this.total = total;
		this.count = count;
		this.data = data;

		sortBlocks();

		printReport();

		if (completionHandler != null)
		{
			completionHandler(this);
		}
		return output;
	}

	function sortBlocks()
	{
		
		packages = new Hash();
		files = new Hash();
		classes = new Hash();
		methods = new Hash();				


		for(i in 0...Lambda.count(data.blocks))
		{
			var block = data.blocks.get(i);
			addBlockToHashes(block);
		}

	}

	function addBlockToHashes(block:CodeBlock)
	{
		var key:String;
		
		//by package
		key =  block.packageName != "" ?  block.packageName : "[default]";
		if(!packages.exists(key))
		{
			packages.set(key, new CodeBlockCollection(key));
		}
		var pckg = packages.get(key);
		pckg.addBlock(block);

		/// by file
		key = block.filePath;
		if(!files.exists(key))
		{
			files.set(key, new CodeBlockCollection(key));
		}
		var file = files.get(key);
		file.addBlock(block);

		//by class
		key = block.packageName != "" ? block.packageName + "." + block.className : block.className;
		if(!classes.exists(key))
		{
			classes.set(key, new CodeBlockCollection(key));
		}
		var cls = classes.get(key);
		cls.addBlock(block);

	}


	function printReport()
	{
		var percent = Math.round(count/total*1000)/10;

		print("MCover v0 Coverage Report, generated " + Date.now().toString());
		print(divider);

		#if MCOVER_DEBUG
		printCoveredBlocks(data.blocks);
		#end

		if(count != total)
		{
			printMissingBlocks(data.blocks);
		}

		printClassResults(classes);
		printPackageResults(packages);

		print("");
		print(divider);
		print("");
		print("OVERALL STATS SUMMARY:");
		
		print("");

		printToTabs(["total packages", packagePartialCount + " /" + packageTotal], 20);
		printToTabs(["total classes", classPartialCount + " /" + classTotal], 20);
		printToTabs(["total blocks", count + " /" + total], 20);
		
		print("");
		printToTabs(["RESULT", percent + "%"], 20);
		print("");
		print(divider);
	}

	function printMissingBlocks(blocks:IntHash<CodeBlock>)
	{
		print("");
		print("MISSING CODE BLOCKS:");
		print("");

		for(i in 0...Lambda.count(data.blocks))
		{
			var block = blocks.get(i);
			if(!block.result) printToTabs(["", block.qualifiedClassName + "#" + block.methodName + " " + block.location]);
		}
	}

	function printCoveredBlocks(blocks:IntHash<CodeBlock>)
	{
		print("");
		print("COVERED CODE BLOCKS:");
		print("");
		for(i in 0...Lambda.count(data.blocks))
		{
			var block = blocks.get(i);
			if(!block.result) printToTabs(["", block.qualifiedClassName + "#" + block.methodName + " " + block.location]);
			
		}
	}


	function printPackageResults(packages:Hash<CodeBlockCollection>)
	{
		packageTotal = 0;
		packagePartialCount = 0;
		packageCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY PACKAGE:");
		print("");
		printToTabs(["", "result","blocks","package"]);
		for(pckg in packages)
		{
			packageTotal += 1;
			if(pckg.count > 0) packagePartialCount += 1;
			if(pckg.percent == 100) packageCompletedCount += 1;


			printToTabs(["", pckg.percent + "%",pckg.count + "/" + pckg.total, pckg.name]);
		}

	}

	function printClassResults(classes:Hash<CodeBlockCollection>)
	{
		classTotal = 0;
		classPartialCount = 0;
		classCompletedCount = 0;

		print("");
		print("COVERAGE BREAKDOWN BY CLASSES:");
		print("");
		printToTabs(["", "result","blocks","class"]);
		for(cls in classes)
		{
			classTotal += 1;
			if(cls.count > 0) classPartialCount += 1;
			if(cls.percent == 100) classCompletedCount += 1;
			printToTabs(["", cls.percent + "%",cls.count + "/" + cls.total, cls.name]);
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