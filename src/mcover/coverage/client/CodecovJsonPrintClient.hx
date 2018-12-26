package mcover.coverage.client;

#if sys
import haxe.Json;
import sys.io.FileOutput;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.DataTypes;
import mcover.util.Timer;

class CodecovJsonPrintClient implements CoverageReportClient {
	public var completionHandler(default, default):CoverageReportClient->Void;
	public var output(default, null):String;

	var coverageFileName:String;

	public function new(?fileName:String) 
	{
		if(fileName == null) 
		{
			coverageFileName = "coverage.json";
		} 
		else
		{
			coverageFileName = fileName;
		}
	}

	public function report(coverage:Coverage) 
	{
		var text:StringBuf = new StringBuf();
		text.add("{\n\t\"coverage\": {\n");

		var first:Bool = true;
		for (cls in coverage.getClasses()) 
		{
			if (!first) 
			{
				text.add(",\n");
			}
			text.add(reportClass(cls));
			first = false;
		}
		text.add("\n\t}\n}\n");

		var file:FileOutput = sys.io.File.write(coverageFileName);
		file.writeString(text.toString());
		file.close();

		#if (php||eval)
			reportComplete();
		#else
			var timer = Timer.delay(reportComplete, 10);
		#end
	}

	function reportComplete()
	{
		if(completionHandler != null)
		{
			completionHandler(this);
		}
	}

	function reportClass(cls:Clazz):String {
		var c = StringTools.replace(cls.name, ".", "/") + ".hx";
		var text:StringBuf = new StringBuf();
		text.add('\t\t"$c": {\n');

		var lineCov:Map<Int, String> = new Map<Int, String>();
		var maxLineNumber:Int = 0;
		for (method in cls.getMethods()) {
			var max:Int = reportMethod(text, method, lineCov);
			if (max > maxLineNumber) {
				maxLineNumber = max;
			}
		}
		var first:Bool = true;
		for (line in 0...maxLineNumber + 1) {
			if (!lineCov.exists(line)) {
				continue;
			}
			if (!first) {
				text.add(",\n");
			}
			first = false;
			var count = lineCov.get(line);
			text.add('\t\t\t"$line": $count');
		}
		text.add("\n\t\t}");
		return text.toString();
	}

	@:access(mcover.coverage.data.Method)
	function reportMethod(text:StringBuf, method:Method, lineCov:Map<Int, String>):Int {
		var maxLineNumber:Int = 0;

		for (statementId in method.statementsById.keys()) {
			var statement:Statement = method.statementsById.get(statementId);
			for (line in statement.lines) {
				maxLineNumber = addLineCov(line, lineCov, '${statement.count}', maxLineNumber);
			}
		}
		for (branchId in method.branchesById.keys()) {
			var branch:Branch = method.branchesById.get(branchId);
			if (branch.isCovered()) {
				for (line in branch.lines) {
					maxLineNumber = addLineCov(line, lineCov, "1", maxLineNumber);
				}
			} else {
				var coverage:String = "\"1/2\"";
				if (branch.totalCount <= 0) {
					coverage = "0";
				}
				for (line in branch.lines) {
					maxLineNumber = addLineCov(line, lineCov, coverage, maxLineNumber);
				}
			}
		}
		return maxLineNumber;
	}

	function addLineCov(line:Int, lineCov:Map<Int, String>, count:String, maxLineNumber:Int):Int {
		if (line > maxLineNumber) {
			maxLineNumber = line;
		}
		lineCov.set(line, count);
		return maxLineNumber;
	}
}
#end