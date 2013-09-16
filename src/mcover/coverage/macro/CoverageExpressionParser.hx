/****
* Copyright 2013 Massive Interactive. All rights reserved.
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

package mcover.coverage.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import mcover.macro.ClassParser;
import mcover.coverage.DataTypes;
import mcover.macro.ClassInfo;
import mcover.macro.ExpressionParser;
import sys.FileSystem;

import haxe.macro.ExprTools;
using haxe.macro.ExprTools;
using mcover.macro.Tools;

@:keep class CoverageExpressionParser implements ExpressionParser
{

	public var ignoreFieldMeta(default, default):String;
	public var includeFieldMeta(default, default):String;
	
	static var statementCount:Int = 0;
	static var branchCount:Int = 0;
	static public var IS_WINDOWS = Sys.systemName() == "Windows"; 

	static var posReg:EReg = ~/([a-zA-z0-9\/].*.hx):([0-9].*): (characters|lines) ([0-9].*)-([0-9].*)/;
	
	var coveredLines:Map<Int,Bool>;
	var exprPos:Position;

	/**
	current expression stack (i.e. hierachial list of ancestors for the current expression)
	*/
	var info:ClassInfo;

	/**
	Current function stack (ususally just the current method field (unless inside inline function))
	*/
	var functionStack:Array<Function>;

	public function new()
	{
		ignoreFieldMeta = "IgnoreCover,:IgnoreCover,:ignore,:macro";
		includeFieldMeta = null;
		coveredLines =  new Map();
		functionStack = [];
	}

	public function parseMethod(func:Function, info:ClassInfo):Function
	{
		this.info = info;
		functionStack = [func];
		func.expr = parseExpr(func.expr);
		return func;
	}

	/**
	Wraps code branches and statement blocks with coverage logs
	@param e 		the current expression
	@return the updated expression
	*/

	function parseExpr(e:Expr):Expr
	{
		exprPos = e.pos;

		return switch(e.expr)
		{
			case EFunction(name, func):
				//e.g. var f = function()
				functionStack.push(func);
				if(func.expr != null)
					func.expr = func.expr.map(parseExpr);
				functionStack.pop();
				EFunction(name, func).at(e.pos);

			case EIf(econd,eif,eelse):
				econd = coverBranch(econd.map(parseExpr));
				eif = eif.map(parseExpr);
				if(eelse != null)
					eelse = eelse.map(parseExpr);
				EIf(econd,eif,eelse).at(e.pos);

			case EWhile(econd, expr, normalWhile):
				expr = expr.map(parseExpr);
				econd = coverBranch(econd);
				EWhile(econd, e, normalWhile).at(e.pos);

			case ETernary(econd, eif, eelse): 
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				econd = coverBranch(econd);
				eif = eif.map(parseExpr);
				eelse = eelse.map(parseExpr);

				ETernary(econd, eif, eelse).at(e.pos);

			case EBlock(exprs): 
				//e.g. {...}
				exprs = exprs.map(parseExpr);
				exprs = coverBlock(e, exprs);
				EBlock(exprs).at(e.pos);

			case EBinop(op, e1, e2):
				//e.g. i<2; a||b, i==b
				e1 = e1.map(parseExpr);
				e2 = e2.map(parseExpr);
				coverBinop(op, e1, e2).at(e.pos);

			case _: e.map(parseExpr);
		}
	}

	/**
	adds coverage log to start of code block
	Excludes empty code blocks that are NOT a top level class method
	*/
	function coverBlock(expr:Expr, exprs:Array<Expr>):Array<Expr>
	{
		if(exprs.length == 0)
		{
			//ensure empty methods are still covered (e.g. empty constructor) 
			if(expr != functionStack[functionStack.length-1].expr) return exprs;
		}


		var startPos:Position = (exprs.length == 0) ? expr.pos : exprs[0].pos;

		var endPos:Position = (exprs.length == 0) ? expr.pos : exprs[exprs.length-1].pos;

		var coverageExpr = createBlockCoverageExpr(expr, startPos, endPos);
		exprs.unshift(coverageExpr);
		
		return exprs;
	}

	//e.g. i<2; a||b, i==b
	function coverBinop(op:Binop, e1:Expr, e2:Expr):ExprDef
	{
		switch(op)
		{
			case OpBoolOr:
				
				e1 = coverBranch(e1);
				e2 = coverBranch(e2);
			
			default: null;//debug(expr);
		}	
		return EBinop(op, e1, e2);
	}


	/////////////

	/**
	* generates a call to the runner to insert into the code block containing a unique id
	*		mcover.MCoverRunner.log(id)
	* @see createCodeBlock for key format
	**/
	function createBlockCoverageExpr(expr:Expr, startPos:Position, endPos:Position):Expr
	{
		var block = createCodeBlockReference(startPos, endPos, false);
		var blockId = macro $v{block.id};
		return macro mcover.coverage.MCoverage.getLogger().logStatement($blockId);
	}

	/**
	* wraps a boolean value within a branch in a call to MCoverage.getLogger().logBranch(id, value, compareValue);
	**/
	function coverBranch(expr:Expr, ?compareExpr:Expr = null):Expr
	{
		var pos = expr.pos;
		var block = createCodeBlockReference(pos, pos, true);
		var blockId = macro $v{block.id}
		
		var args = [blockId, expr];

		if(compareExpr != null)
			args.push(compareExpr);

		return macro mcover.coverage.MCoverage.getLogger().logBranch($a{args});
	}

	function createCodeBlockReference(startPos:Position, endPos:Position, ?isBranch:Bool = false):AbstractBlock
	{
		var posInfo = Context.getPosInfos(startPos);
		var file:String = posInfo.file;
		var strict = true;

		file = FileSystem.fullPath(file);
		

		var posFile:String = null;
		var classFile:String = null;

		try
		{
			posFile = Context.resolvePath(posInfo.file);
		}
		catch(e:Dynamic)
		{
			if(!FileSystem.exists(file))
				throw e;
			else
				posFile = file;
		}

		try
		{
			classFile = FileSystem.fullPath(Context.resolvePath(info.fileName));
		}
		catch(e:Dynamic)
		{
			classFile =  FileSystem.fullPath(info.fileName);
		}

		if(file != classFile)
		{
			strict = false;
		}

		var mpartial = Context.defined("mpartial");

		for (cp in CoverageMacroDelegate.classPathMap)
		{

			if(file.indexOf(cp) == 0)
			{	
				if(strict)
					return createReference(cp, file, startPos, endPos, isBranch, null, classFile);

				if(!mpartial) continue;

				//the current file pos file location doesn't match the class being compiled.
				//this case needs to be handled for mpartial macros
				
				var info = info.clone();

				var slash = IS_WINDOWS ? "\\" : "/";
				var packagePath = info.packageName.split(".").join(slash);

				var alternateLocation:String = null;

				if(file.indexOf(packagePath) != -1)
				{
					var temp = file.split(packagePath);
					
					var fileName = temp.pop();
					var fileClassPath = temp.join(packagePath);//in case package dir repeated in full path


					if(fileName.indexOf("_") != -1)
					{
						var parts = fileName.split("_");

						file = classFile;
						alternateLocation = classFile.split(".").join("_" + parts[1] + ".");
					}

					info = ClassInfo.fromFile(file, cp);

					info.methodName = info.methodName;
				}
				
				return createReference(cp, file, startPos, endPos, isBranch, info, alternateLocation, true);
			}
		}

		//At this point it is likely that the method/block was generated via macros
		//and has different position info to the target class being parsed.
		for (cp in CoverageMacroDelegate.classPathMap)
		{
			if(classFile.indexOf(cp) == 0)
			{
				file = classFile;
				var alternateLocation:String = posFile;

				return createReference(cp, file, startPos, endPos, isBranch, info, alternateLocation, true);
			}
		}

		
		var error = "Unable to find referenced file (" + file + ") or target file (" + classFile + ") in any class paths.";
		error += "\n    Location: " + info.location;
		error += "\n    Referenced pos: " + Std.string(startPos);
		error += "\n    Searched classpaths:";
		for (cp in CoverageMacroDelegate.classPathMap)
		{
			error += "\n      " + cp;
		}
		Context.error(error, Context.currentPos());
		throw new CoverageException(error);
		return null;
	}

	function createReference(cp:String, file:String, startPos:Position, endPos:Position, isBranch:Bool, ?info:ClassInfo, ?alternateLocation:String, ?generatedByMacro:Bool=false):AbstractBlock
	{
		if(info == null) info = this.info;

		var block:AbstractBlock;
		
		if(isBranch)
		{
			block = new Branch();
			block.id = branchCount ++;
		}
		else
		{
			block = new Statement();
			block.id = statementCount++;
		}

		if(cp.charAt(cp.length-1) == "/") cp = cp.substr(0, cp.length-1);
		file = file.substr(cp.length+1,  file.length-cp.length-1);

		block.file = file;

		var filePath = file.substr(0, file.length-3);//remove '.hx'
		var parts:Array<String> = null;

		if(IS_WINDOWS)
		{
			parts = filePath.split("\\");
		}
		else
		{
			parts = filePath.split("/");
		}

		parts.pop();

		block.packageName = (parts.length > 0) ? parts.join(".") : "";
		block.className = info.className;
		block.qualifiedClassName = (block.packageName != "") ? block.packageName + "." + block.className : block.className;
		block.methodName = info.methodName;

		var posInfo = Context.getPosInfos(startPos);

		block.min = posInfo.min;
		block.max = posInfo.max;

		var posString = Std.string(startPos);

		posString = posString.substr(5, posString.length-6);//get path string

		posString = posString.split(" characters ").join(" chars ");

		if(alternateLocation != null)
		{
			if(IS_WINDOWS) alternateLocation = alternateLocation.split("\\").join("\\\\\\\\");

			var p = posString.split(":");
			p.shift();

			block.location = alternateLocation + ":" + p.join(":");

			if(generatedByMacro)
				block.location += " @:macro";
		}
		else
		{
			block.location = posString;
		}

		var lines:Array<Int> = [];
		var startLine = -1;
		var endLine = -1;

		if(posReg.match(posString))
		{
			startLine = Std.parseInt(posReg.matched(2));
		}

		posString = Std.string(endPos);
		posString = posString.substr(5, posString.length-6);

		if(posReg.match(posString))
		{
			if(posReg.matched(3) == "lines")
			{
				endLine = Std.parseInt(posReg.matched(5));
			}
			else
			{
				endLine = Std.parseInt(posReg.matched(2));
			}
		}

		for(i in startLine...endLine+1)
		{
			if(!coveredLines.exists(i))
			{
				coveredLines.set(i, true);
				block.lines.push(i);
			}
		}

		if(isBranch)
		{
			CoverageMacroDelegate.coverage.addBranch(cast(block, Branch));
		}
		else
		{
			CoverageMacroDelegate.coverage.addStatement(cast(block, Statement));
		}
		return block;
	}

}

#end