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

#if haxe3
import haxe.ds.IntMap;
#else
private typedef IntMap<T> = IntHash<T>
#end

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import mcover.macro.ClassParser;
import mcover.coverage.DataTypes;
import mcover.macro.MacroUtil;
import mcover.macro.ClassInfo;
import mcover.macro.ExpressionParser;
import sys.FileSystem;

@:keep class CoverageExpressionParser implements ExpressionParser
{

	public var ignoreFieldMeta(default, default):String;
	public var includeFieldMeta(default, default):String;
	
	static var statementCount:Int = 0;
	static var branchCount:Int = 0;
	static public var IS_WINDOWS = Sys.systemName() == "Windows"; 

	public var target(default, default):ClassParser;

	static var posReg:EReg = ~/([a-zA-z0-9\/].*.hx):([0-9].*): (characters|lines) ([0-9].*)-([0-9].*)/;
	
	var coveredLines:IntMap<Bool>;
	var exprPos:Position;

	public function new()
	{
		ignoreFieldMeta = "IgnoreCover,:IgnoreCover,:ignore,:macro";
		includeFieldMeta = null;
		coveredLines =  new IntMap();
	}

	public function parseMethod(field:Field, f:Function):Void
	{

	}

	/**
	Wraps code branches and statement blocks with coverage logs
	
	@param expr 		the current expression
	@param target 		the current ClassParser instance
	@return the updated expression
	@see ClassParser.parseExpr
	*/
	public function parseExpr(expr:Expr):Expr
	{
		exprPos = expr.pos;

		switch(expr.expr)
		{
			case EIf(econd, eif, eelse):
			{
				econd = createBranchCoverageExpr(econd);
				expr.expr = EIf(econd, eif, eelse);
			}
			case EWhile(econd, e, normalWhile):
			{
				econd = createBranchCoverageExpr(econd);
				expr.expr = EWhile(econd, e, normalWhile);
			}
			case ETernary(econd, eif, eelse): 
			{
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				econd = createBranchCoverageExpr(econd);
				expr.expr = ETernary(econd, eif, eelse);
			}
			case EBlock(exprs): 
			{
				//e.g. {...}
				parseEBlock(expr, exprs);
			}
			case EBinop(op, e1, e2):
			{
				//e.g. i<2; a||b, i==b
				parseEBinop(expr, op, e1, e2);
			}
			default: null;
		}
		return expr;
	}

	/**
	adds coverage log to start of code block
	Excludes empty code blocks that are NOT a top level class method
	*/
	function parseEBlock(expr:Expr, exprs:Array<Expr>)
	{
		if(exprs.length == 0)
		{
			//ensure empty methods are still covered (e.g. empty constructor) 
			if(expr != target.functionStack[target.functionStack.length-1].expr) return;
		}


		var startPos:Position = (exprs.length == 0) ? expr.pos : exprs[0].pos;

		var endPos:Position = (exprs.length == 0) ? expr.pos : exprs[exprs.length-1].pos;

		var coverageExpr = createBlockCoverageExpr(expr, startPos, endPos);
		exprs.unshift(coverageExpr);
		
		expr.expr = EBlock(exprs);
	}

	//e.g. i<2; a||b, i==b
	function parseEBinop(expr:Expr, op:Binop, e1:Expr, e2:Expr)
	{
		switch(op)
		{
			case OpBoolOr:
				
				e1 = createBranchCoverageExpr(e1);
				e2 = createBranchCoverageExpr(e2);
			
			default: null;//debug(expr);
		}	
		expr.expr = EBinop(op, e1, e2);
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
		
		var blockId = Std.string(block.id);

		var pos = startPos;
		
		var baseExpr = getReferenceToLogger(pos);
		pos = baseExpr.pos;

		var eField = EField(baseExpr, "logStatement");
		pos = MacroUtil.incrementPos(pos, 13);
		var fieldExpr = {expr:eField, pos:pos};
		
		pos = MacroUtil.incrementPos(pos, blockId.length);
		var arg1 = {expr:EConst(CInt(blockId)), pos:pos};

		pos = MacroUtil.incrementPos(pos, 2);
		
		return {expr:ECall(fieldExpr, [arg1]), pos:pos};
	}

	/**
	* wraps a boolean value within a branch in a call to MCoverage.getLogger().logBranch(id, value, compareValue);
	**/
	function createBranchCoverageExpr(expr:Expr, ?compareExpr:Expr = null):Expr
	{
		var pos = expr.pos;
		var block = createCodeBlockReference(pos, pos, true);
	
		var blockId = Std.string(block.id);

		var baseExpr = getReferenceToLogger(pos);
		pos = baseExpr.pos;

		var eField = EField(baseExpr, "logBranch");
		pos = MacroUtil.incrementPos(pos, 4);
		var fieldExpr = {expr:eField, pos:pos};
		
		var args:Array<Expr> = [];

		pos = MacroUtil.incrementPos(pos, blockId.length);
	
		args.push({expr:EConst(CInt(blockId)), pos:pos});

		pos = MacroUtil.incrementPos(pos, 5);
		args.push({expr:expr.expr, pos:pos});

		if(compareExpr != null)
		{
			pos = MacroUtil.incrementPos(pos, 5);
			args.push({expr:compareExpr.expr, pos:pos});
		}
		
		expr.expr = ECall(fieldExpr, args);
		return expr;
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
			classFile = FileSystem.fullPath(Context.resolvePath(target.info.fileName));
		}
		catch(e:Dynamic)
		{
			classFile =  FileSystem.fullPath(target.info.fileName);
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
				
				var info = target.info.clone();

				var slash = IS_WINDOWS ? "\\" : "/";
				var packagePath = target.info.packageName.split(".").join(slash);

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

					info.methodName = target.info.methodName;
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

				return createReference(cp, file, startPos, endPos, isBranch, target.info, alternateLocation, true);
			}
		}

		
		var error = "Unable to find referenced file (" + file + ") or target file (" + classFile + ") in any class paths.";
		error += "\n    Location: " + target.info.location;
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
		if(info == null) info = target.info;

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


	/**
	Creates a call to MCoverage.getLogger();

	@param pos - the position to add to
	@return expr matching "mcover.coverage.MCoverage.getLogger()"
	*/
	function getReferenceToLogger(pos:Position):Expr
	{
		var eIdentField = EConst(CIdent("mcover"));
		pos = MacroUtil.incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eIdentField2 = EField(identFieldExpr, "coverage");
		pos = MacroUtil.incrementPos(pos, 7);
		var identFieldExpr2 = {expr:eIdentField2, pos:pos};


		#if haxe3
		var eType = EField(identFieldExpr2, "MCoverage");
		#else
		var eType = EType(identFieldExpr2, "MCoverage");
		#end
		
		pos = MacroUtil.incrementPos(pos, 5);
		var typeExpr = {expr:eType, pos:pos};

		var eField = EField(typeExpr, "getLogger");
		pos = MacroUtil.incrementPos(pos, 9);
		var fieldExpr = {expr:eField, pos:pos};

		pos = MacroUtil.incrementPos(pos, 2);
		return {expr:ECall(fieldExpr, []), pos:pos};
	}

}

#end