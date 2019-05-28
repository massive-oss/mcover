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

#if (sys || nodejs)
import sys.io.FileOutput;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.DataTypes;
import mcover.util.Timer;

class LcovPrintClient implements CoverageReportClient {

	public var completionHandler(default, default):CoverageReportClient->Void;
	public var output(default, null):String;

	var testName:String;
	var lcovFileName:String;
	var lastKnownAbsoluteBasePath:String;

	public function new(name:String, ?fileName:String) {
		testName = name;
		if (fileName == null)
		{
			lcovFileName = "lcov.info";
		}
		else
		{
			lcovFileName = fileName;
		}
	}

	public function report(coverage:Coverage) {
		sys.io.File.saveContent(lcovFileName, "\n");

		var fileClassMap:Map<String, Array<Clazz>>=new Map<String, Array<Clazz>>();
		for (cls in coverage.getClasses()) {
			var path = getAbsolutePath(cls);
			if (fileClassMap.exists(path)) {
				fileClassMap.get(path).push(cls);
				continue;
			}
			fileClassMap.set(path, [cls]);
		}
		for (path in fileClassMap.keys()) {
			reportFile(path, fileClassMap.get(path));
		}

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

	@:access(mcover.coverage.data.AbstractNodeList)
	@:access(mcover.coverage.data.Method)
	function getAbsolutePath(cls:Clazz):String {
		for (item in cls.itemsById) {
			if (Type.getClass(item) == Method){
				var method:Method = cast item;
				for (branch in method.branchesById) {
					return locationToPath(branch.location);
				}
				for (stmt in method.statementsById) {
					return locationToPath(stmt.location);
				}
			}
		}
		return StringTools.replace(cls.name, ".", "/") + ".hx";
	}

	function locationToPath(location:String):String {
		var index:Int = location.lastIndexOf(".hx:");
		if (index < 0) {
			return location;
		}
		return location.substr(0, index + 3);
	}

	function reportFile(path:String, classes:Array<Clazz>){

		var text:StringBuf = new StringBuf();

		text.add(makeLine("TN", classes[0].name));
		text.add(makeLine("SF", path));
		text.add("\n");

		var lineCov:Map<Int, Int> = new Map<Int, Int>();
		var branchCov:Map<Int, String> = new Map<Int, String>();
		var maxLineNumber:Int = 0;

		var num:Int = 0;
		for (cls in classes) {
			for (method in cls.getMethods()) {
				text.add(makeLine("FN", '${firstMethodLine(method)},${method.name}'));
			}
		}
		text.add("\n");

		for (cls in classes) {
			for (method in cls.getMethods()) {
				text.add(makeLine("FNDA", '${methodCount(method)},${method.name}'));
			}
		}

		text.add("\n");
		var countF:Int = 0;
		var countH:Int = 0;
		for (cls in classes) {
			var results:CoverageResult = cls.getResults();
			countF += results.m;
			countH += results.mc;
		}
		text.add(makeLine("FNF", '$countF'));
		text.add(makeLine("FNH", '$countH'));
		text.add("\n");

		maxLineNumber = 0;
		for (cls in classes) {
			for (method in cls.getMethods()) {
				var max:Int = reportBranches(text, method, branchCov);
				if (max > maxLineNumber) {
					maxLineNumber = max;
				}
			}
		}
		for (line in 0...maxLineNumber + 1) {
			if (!branchCov.exists(line)) {
				continue;
			}
			var count:String = branchCov.get(line);
			text.add(makeLine("BRDA", '${line},${count}'));
		}

		text.add("\n");
		countF = 0;
		countH = 0;
		for (cls in classes) {
			var results:CoverageResult = cls.getResults();
			countF += results.b;
			countH += results.bt;
		}
		text.add(makeLine("BRF", '$countF'));
		text.add(makeLine("BRH", '$countH'));
		text.add("\n");

		maxLineNumber = 0;
		for (cls in classes) {
			for (method in cls.getMethods()) {
				var max:Int = reportStatements(text, method, lineCov);
				if (max > maxLineNumber) {
					maxLineNumber = max;
				}
			}
		}
		for (line in 0...maxLineNumber + 1) {
			if (!lineCov.exists(line)) {
				continue;
			}
			var count:Int = lineCov.get(line);
			text.add(makeLine("DA", '${line},${count}'));
		}

		text.add("\n");
		countF = 0;
		countH = 0;
		for (cls in classes) {
			var results:CoverageResult = cls.getResults();
			countF += results.l;
			countH += results.lc;
		}
		text.add(makeLine("LF", '$countF'));
		text.add(makeLine("LH", '$countH'));
		text.add("\n");

		text.add("end_of_record\n\n");
		appendCoverageFile(text.toString());
	}

	@:access(mcover.coverage.data.Method)
	function methodCount(method:Method):Int {
		var count:Int = 0;
		var lowest:Int = findLowestId(method.branchesById.keys());
		if (lowest >= 0) {
			var branch:Branch = method.branchesById.get(lowest);
			return branch.totalCount;
		} else {
			var lowest:Int = findLowestId(method.statementsById.keys());
			if (lowest < 0) {
				return 0;
			}
			var statement:Statement = method.statementsById.get(lowest);
			return statement.count;
		}
	}

	@:access(mcover.coverage.data.Method)
	function firstMethodLine(method:Method):Int {
		var firstLine:Int = -1;
		var lowest:Int = findLowestId(method.branchesById.keys());
		if (lowest >= 0) {
			var branch:Branch = method.branchesById.get(lowest);
			if (branch.lines.length > 0) {
				firstLine = branch.lines[0];
			}
		}
		var lowest:Int = findLowestId(method.statementsById.keys());
		if (lowest >= 0) {
			var statement:Statement = method.statementsById.get(lowest);
			if (statement.lines.length > 0) {
				if (firstLine < 0 || statement.lines[0] < firstLine) {
					firstLine = statement.lines[0];
				}
			}
		}
		if (firstLine < 0) {
			return 0;
		}
		return firstLine;
	}

	function findLowestId(keys:Iterator<Int>):Int {
		var lowest:Int = -1;
		for (id in keys) {
			if (lowest < 0) {
				lowest = id;
				continue;
			}
			if (id < lowest) {
				lowest = id;
			}
		}
		return lowest;
	}

	@:access(mcover.coverage.data.Method)
	function reportStatements(text:StringBuf, method:Method, lineCov:Map<Int, Int>):Int {
		var maxLineNumber:Int = 0;

		for (statementId in method.statementsById.keys()) {
			var statement:Statement = method.statementsById.get(statementId);
			for (line in statement.lines) {
				maxLineNumber = addLineCov(line, lineCov, statement.count, maxLineNumber);
			}
		}
		for (branchId in method.branchesById.keys()) {
			var branch:Branch = method.branchesById.get(branchId);
			if (branch.isCovered()) {
				for (line in branch.lines) {
					maxLineNumber = addLineCov(line, lineCov, 1, maxLineNumber);
				}
			} else {
				for (line in branch.lines) {
					maxLineNumber = addLineCov(line, lineCov, branch.totalCount, maxLineNumber);
				}
			}
		}
		return maxLineNumber;
	}

	@:access(mcover.coverage.data.Method)
	function reportBranches(text:StringBuf, method:Method, branchCov:Map<Int, String>):Int {
		var maxLineNumber:Int = 0;

		for (branchId in method.branchesById.keys()) {
			var branch:Branch = method.branchesById.get(branchId);
			var data:String = '${method.id},${branch.id},${branch.totalCount}';
			if (branch.isCovered()) {
				for (line in branch.lines) {
					maxLineNumber = addLineCov(line, branchCov, data, maxLineNumber);
				}
			} else {
				for (line in branch.lines) {
					if (branch.isPartiallyCovered()) {
						data = '${method.id},${branch.id},-';
					}
					maxLineNumber = addLineCov(line, branchCov, data, maxLineNumber);
				}
			}
		}
		return maxLineNumber;
	}

	function addLineCov<T>(line:Int, lineCov:Map<Int, T>, count:T, maxLineNumber:Int):Int {
		if (line > maxLineNumber) {
			maxLineNumber = line;
		}
		lineCov.set(line, count);
		return maxLineNumber;
	}

	function appendCoverageFile(text:String) {
		#if nodejs
			js.node.Fs.appendFileSync(lcovFileName, text);
		#else
			var file:FileOutput = sys.io.File.append(lcovFileName);
			file.writeString(text.toString());
			file.close();
		#end
	}

	inline function makeLine(key:String, value:String):String {
		return '$key:$value\n';
	}
}
#end
