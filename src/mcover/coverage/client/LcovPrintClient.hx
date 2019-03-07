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

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

#if (sys || nodejs)
import haxe.io.Path;
import sys.io.FileOutput;
import sys.FileSystem;
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
		for (cls in coverage.getClasses()) {
			reportClass(cls);
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

    macro public static function getClassPaths():Expr
    {
		var classPaths:Array<String> = Context.getClassPath();
        return macro $v{classPaths};
    }

    macro public static function getCompileCwd():Expr
    {
		var cwd:String = Sys.getCwd();
		return macro $v{cwd};
    }

	function makeAbsolutePath(path:String):String {
		if (Path.isAbsolute(path)) {
			return path;
		}
		var classPaths:Array<String> = getClassPaths();
		var cwd:String = getCompileCwd();
		var fullPath:String;
		var lastKnown:String;
		for (cp in classPaths) {
			if (Path.isAbsolute(cp)) {
				fullPath = Path.join([cp, path]);
				lastKnown= cp;
			} else {
				fullPath = Path.join([cwd, cp, path]);
				lastKnown = Path.join([cwd, cp]);
			}
			if (FileSystem.exists(fullPath)) {
				lastKnownAbsoluteBasePath = lastKnown;
				return fullPath;
			}
		}
		fullPath = Path.join([cwd, path]);
		if (FileSystem.exists(fullPath)) {
			return fullPath;
		}
		if (lastKnownAbsoluteBasePath != null) {
			// multiple types inside a single file will not match a simple class -> file mapping
			return Path.join([lastKnownAbsoluteBasePath, path]);
		}
		return path;
	}

	function reportClass(cls:Clazz) {
		var results:CoverageResult = cls.getResults();
		// TODO find a better solution to get absolute file path
		var c = makeAbsolutePath(StringTools.replace(cls.name, ".", "/") + ".hx");
		var text:StringBuf = new StringBuf();

		text.add(makeLine("TN", cls.name));
		text.add(makeLine("SF", c));
		text.add("\n");

		var lineCov:Map<Int, Int> = new Map<Int, Int>();
		var branchCov:Map<Int, String> = new Map<Int, String>();
		var maxLineNumber:Int = 0;

		var num:Int = 0;
		for (method in cls.getMethods()) {
			text.add(makeLine("FN", '${firstMethodLine(method)},${method.name}'));
		}
		text.add("\n");

		for (method in cls.getMethods()) {
			text.add(makeLine("FNDA", '${methodCount(method)},${method.name}'));
		}
		text.add("\n");
		text.add(makeLine("FNF", '${results.m}'));
		text.add(makeLine("FNH", '${results.mc}'));
		text.add("\n");

		maxLineNumber = 0;
		for (method in cls.getMethods()) {
			var max:Int = reportBranches(text, method, branchCov);
			if (max > maxLineNumber) {
				maxLineNumber = max;
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
		text.add(makeLine("BRF", '${results.b}'));
		text.add(makeLine("BRH", '${results.bt}'));
		text.add("\n");

		maxLineNumber = 0;
		for (method in cls.getMethods()) {
			var max:Int = reportStatements(text, method, lineCov);
			if (max > maxLineNumber) {
				maxLineNumber = max;
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

		text.add(makeLine("LF", '${results.l}'));
		text.add(makeLine("LH", '${results.lc}'));
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
			var content:String = sys.io.File.getContent(lcovFileName);
			content += text;
			sys.io.File.saveContent(lcovFileName, content);
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
