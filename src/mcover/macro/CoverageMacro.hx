/**
	Copyright 2013 Massive Interactive. All rights reserved.
	
	Redistribution and use in source and binary forms, with or without modification, are
	permitted provided that the following conditions are met:
	
	   1. Redistributions of source code must retain the above copyright notice, this list of
	      conditions and the following disclaimer.
	
	   2. Redistributions in binary form must reproduce the above copyright notice, this list
	      of conditions and the following disclaimer in the documentation and/or other materials
	      provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
	WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
	FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	
	The views and conclusions contained in the software and documentation are those of the
	authors and should not be interpreted as representing official policies, either expressed
	or implied, of Massive Interactive.
**/

package mcover.macro;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.PosInfos;
import sys.io.File;
import sys.FileSystem;
import mcover.coverage.DataTypes;

using haxe.macro.Tools;
using mcover.macro.Tools;

class CoverageMacro
{
	static public function createClassInfo():ClassInfo
	{
		var info = new ClassInfo();

		switch (Context.getLocalType())
		{
			case TInst(t, _):
			{
				var parts = Std.string(t).split(".");
				info.className = parts.pop();
				info.packageName = parts.join(".");
				info.packagePath = parts.join(SLASH);
			}
			default: null;
		}

		return info;
	}
	static public function parseBuildFields(classPaths:Map<String,Bool>):Array<Field>
	{
		var info = createClassInfo();

		var fields = Context.getBuildFields();

		if (fields.length > 0)
			info.fileName = Context.getPosInfos(fields[0].pos).file;

		var instance = new CoverageMacro(info);

		var fields = instance.parseFields(fields, classPaths);

		for(branch in instance.branches)
			MCover.coverageData.addBranch(branch);

		for(statement in instance.statements)
			MCover.coverageData.addStatement(statement);


		return fields;
	}

	static var ignoreFieldMeta:Map<String,Bool> = createIgnoreMeta();

	static function createIgnoreMeta():Map<String,Bool>
	{
		var map = new Map<String,Bool>();
		var values = ["IgnoreCover",":IgnoreCover",":ignore"];

		for (v in values)
		{
			map.set(v, true);
		}
		return map;
	}

	static var IS_WINDOWS = Sys.systemName() == "Windows"; 
	static var SLASH = IS_WINDOWS ? "\\" : "/";
	static var USING_MPARTIAL:Bool = Context.defined("mpartial");

	static var statementCount:Int = 0;
	static var branchCount:Int = 0;
	
	static var posReg:EReg = ~/([a-zA-z0-9\/].*.hx):([0-9].*): (characters|lines) ([0-9].*)-([0-9].*)/;

	var classPaths:Map<String,Bool>;
	var fields:Array<Field>;
	
	public var info(default, null):ClassInfo;

	/**
		Current function stack (ususally just the current method field (unless inside inline function))
	**/
	var functionStack:Array<Function>;
	
	var coveredLines:Map<Int,Bool>;

	var statements:Array<Statement>;
	var branches:Array<Branch>;

	public function new(info:ClassInfo, ?classPaths:Map<String,Bool>)
	{
		this.info = info;
		this.classPaths = classPaths;
		coveredLines = new Map();
		branches = [];
		statements = [];
		functionStack = [];
	}

	/**
		loops through all class fields and interogates contents recursively
	**/
	public function parseFields(fields:Array<Field>, classPaths:Map<String,Bool>):Array<Field>
	{
		this.classPaths = classPaths;

		for (field in fields)
        {
        	if (ignoreField(field)) continue;

        	switch (field.kind)
			{
				case FFun(func): 
					info.methodName = field.name;

					if (func.expr != null )
					{
						functionStack = [func];
						func.expr = parseExpr(func.expr);
					}

				case _://null;
			}
        }
        return fields;
	}

	public function ignoreField(field:Field):Bool
	{
		for (item in field.meta)
		{
			if (ignoreFieldMeta.exists(item.name)) return true;
		}
		return false;
	}

	/**
		Wraps code branches and statement blocks with coverage logs
		@param e 		the current expression
		@return the updated expression
	**/
	public function parseExpr(e:Expr):Expr
	{
		return switch (e.expr)
		{
			case EFunction(name, func):
				//e.g. var f = function()
				
				if (func.expr == null)
					e;
				else
				{
					functionStack.push(func);
					func.expr = parseExpr(wrapExpr(func.expr));
					functionStack.pop();
					EFunction(name, func).at(e.pos);
				}

			case EIf(econd,eif,eelse):
				econd = coverBranch(parseExpr(econd));
				eif = eif.map(parseExpr);

				if (eelse != null)
					eelse = parseExpr(wrapExpr(eelse));
				
				EIf(econd,eif,eelse).at(e.pos);

			case EWhile(econd, expr, normalWhile):
				econd = coverBranch(parseExpr(econd));

				if(normalWhile)
					expr = expr.map(parseExpr);
				else
					expr = parseExpr(wrapExpr(expr)); // a do while
				
				EWhile(econd, expr, normalWhile).at(e.pos);

			case ETernary(econd, eif, eelse): 
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				econd = coverBranch(parseExpr(econd));
				eif = parseExpr(eif);
				eelse = parseExpr(eelse);

				ETernary(econd, eif, eelse).at(e.pos);

			case EBlock(exprs): 
				//e.g. {...}
				exprs = exprs.map(parseExpr);
				exprs = coverBlock(e, exprs);
				EBlock(exprs).at(e.pos);

			case EBinop(op, e1, e2):
				//e.g. i<2; a||b, i==b
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				coverBinop(op, e1, e2).at(e.pos);

			case EMeta(s, expr):
			{
				if (ignoreFieldMeta.exists(s.name))
					e;
				else
					EMeta(s, parseExpr(expr)).at(e.pos);
			}
			case _: 
				e.map(parseExpr);
		}
	}

	/**
		Utility to wrap an expr in an EBlock if required for coverage.
		Primarily cases where developer has ommited the block {} around a
		single expr.

		In the following examples, the expr for `f()` is wrapped in a block:

		Before

			if(true) f()
			function() f()

		After

			if(true) { f(); }
			function() { f(); }
	**/
	function wrapExpr(e:Expr):Expr
	{
		return switch(e.expr)
		{
			case EBlock(exprs): e;
			case EIf(econd,eif,eelse): e;
			case _: EBlock([e]).at(e.pos);
		}
	}

	/**
		adds coverage log to start of code block
		Excludes empty code blocks that are NOT a top level class method
	**/
	function coverBlock(expr:Expr, exprs:Array<Expr>):Array<Expr>
	{
		var length = exprs.length;

		var startPos:Position;
		var endPos:Position;

		if (length == 0)
		{
			//ensure empty methods are still covered (e.g. empty constructor) 
			if (expr != functionStack[functionStack.length-1].expr) return exprs;
			startPos = endPos = expr.pos;
		}
		else
		{
			startPos = exprs[0].pos;
			endPos = exprs[length-1].pos;
		}

		var coverageExpr = createBlockCoverageExpr(expr, startPos, endPos);
		exprs.unshift(coverageExpr);
		
		return exprs;
	}

	//e.g. i<2; a||b, i==b
	function coverBinop(op:Binop, e1:Expr, e2:Expr):ExprDef
	{
		switch (op)
		{
			case OpBoolOr, OpBoolAnd:
				
				e1 = coverBranch(e1);
				e2 = coverBranch(e2);
			
			case _://debug(expr);
		}	
		return EBinop(op, e1, e2);
	}

	/////////////

	/**
		generates a call to the runner to insert into the code block containing a unique id
		mcover.MCoverRunner.log(id)
		@see createCodeBlock for key format
	**/
	function createBlockCoverageExpr(expr:Expr, startPos:Position, endPos:Position):Expr
	{
		var block = createCodeBlockReference(startPos, endPos, false);
		var blockId = macro $v{block.id};
		return macro mcover.coverage.MCoverage.getLogger().logStatement($blockId);
	}

	/**
		wraps a boolean value within a branch in a call to MCoverage.getLogger().logBranch(id, value, compareValue);
	**/
	function coverBranch(expr:Expr, ?compareExpr:Expr = null):Expr
	{
		var block = createCodeBlockReference(expr.pos, expr.pos, true);
		var blockId = macro $v{block.id}
		
		var args = [blockId, expr];

		if (compareExpr != null)
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
			if (!FileSystem.exists(file))
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

		if (file != classFile)
			strict = false;

		for (cp in classPaths.keys())
		{
			if (file.indexOf(cp) == 0)
			{	
				if (strict)
					return createReference(cp, file, startPos, endPos, isBranch, null, classFile);

				if (!USING_MPARTIAL) continue;

				//the current file pos file location doesn't match the class being compiled.
				//this case needs to be handled for mpartial macros
				
				var alternateLocation:String = null;

				if (file.indexOf(info.packagePath) != -1)
				{
					var temp = file.split(info.packagePath);
					
					var fileName = temp.pop();
					var fileClassPath = temp.join(info.packagePath);//in case package dir repeated in full path

					if (fileName.indexOf("_") != -1)
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
		for (cp in classPaths.keys())
		{
			if (classFile.indexOf(cp) == 0)
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
		
		for (cp in classPaths.keys())
		{
			error += "\n      " + cp;
		}

		Context.error(error, Context.currentPos());
		throw new mcover.coverage.CoverageException(error);
		return null;
	}

	function createReference(cp:String, file:String, startPos:Position, endPos:Position, isBranch:Bool, ?info:ClassInfo, ?alternateLocation:String, ?generatedByMacro:Bool=false):AbstractBlock
	{
		if (info == null) info = this.info;

		var block:AbstractBlock;
		
		if (isBranch)
		{
			block = new Branch();
			block.id = branchCount ++;
		}
		else
		{
			block = new Statement();
			block.id = statementCount++;
		}

		if (cp.charAt(cp.length-1) == "/") cp = cp.substr(0, cp.length-1);
		file = file.substr(cp.length+1,  file.length-cp.length-1);

		block.file = file;

		var filePath = file.substr(0, file.length-3);//remove '.hx'
		var parts:Array<String> = null;

		if (IS_WINDOWS)
			parts = filePath.split("\\");
		else
			parts = filePath.split("/");

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

		if (alternateLocation != null)
		{
			if (IS_WINDOWS)
				alternateLocation = alternateLocation.split("\\").join("\\\\\\\\");

			var p = posString.split(":");
			p.shift();

			block.location = alternateLocation + ":" + p.join(":");

			if (generatedByMacro)
				block.location += " @:macro";
		}
		else
			block.location = posString;

		var lines:Array<Int> = [];
		var startLine = -1;
		var endLine = -1;

		if (posReg.match(posString))
			startLine = Std.parseInt(posReg.matched(2));

		posString = Std.string(endPos);
		posString = posString.substr(5, posString.length-6);

		if (posReg.match(posString))
		{
			if (posReg.matched(3) == "lines")
				endLine = Std.parseInt(posReg.matched(5));
			else
				endLine = Std.parseInt(posReg.matched(2));
		}

		for (i in startLine...endLine+1)
		{
			if (!coveredLines.exists(i))
			{
				coveredLines.set(i, true);
				block.lines.push(i);
			}
		}

		if (isBranch)
			branches.push(cast block);
		else
			statements.push(cast block);

		return block;
	}
}	

#end