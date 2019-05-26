/****
* Copyright 2019 Massive Interactive. All rights reserved.
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