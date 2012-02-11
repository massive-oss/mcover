/****
* Copyright 2012 Massive Interactive. All rights reserved.
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

package m.cover.coverage.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import m.cover.macro.BuildMacro;

import m.cover.coverage.DataTypes;

import m.cover.macro.MacroUtil;
import m.cover.macro.BuildMacro;
import m.cover.macro.BuildMacroParser;

@:keep class CoverageBuildMacro implements BuildMacroParser
{
	public var ignoreFieldMeta(default, default):String;
	public var includeFieldMeta(default, default):String;
	
	static var statementCount:Int = 0;
	static var branchCount:Int = 0;


	public var target(default, default):IBuildMacro;
	
	public function new()
	{
		ignoreFieldMeta = "IgnoreCover";
		includeFieldMeta = null;

	}

	/**
	Wraps code branches and statement blocks with coverage logs
	
	@param expr 		the current expression
	@param target 		the current BuildMacro instance
	@return the updated expression
	@see BuildMacro.parseExpr
	*/
	public function parseExpr(expr:Expr):Expr
	{
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
		
		var pos:Position = (exprs.length == 0) ? expr.pos : exprs[0].pos;

		var coverageExpr = createBlockCoverageExpr(expr, pos);
		exprs.unshift(coverageExpr);
		
		expr.expr = EBlock(exprs);
	}

	//e.g. i<2; a||b, i==b
	function parseEBinop(expr:Expr, op:Binop, e1:Expr, e2:Expr)
	{
		switch(op)
		{
			case OpAssignOp(op): null;//
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
	function createBlockCoverageExpr(expr:Expr, pos:Position):Expr
	{
		var block = createCodeBlockReference(pos, false);
		
		var blockId = Std.string(block.id);
		
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
		var block = createCodeBlockReference(pos, true);
	
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

	function createCodeBlockReference(pos:Position, ?isBranch:Bool = false):AbstractBlock
	{
		var posInfo = Context.getPosInfos(pos);
		var file:String = posInfo.file;

		for (cp in CoverageMacro.classPathHash)
		{
			if(file.indexOf(cp) == 0)
			{	
				return  createReference(cp, file, pos, isBranch);
			}
		}
		var error = "Unable to find file in any class paths (" + file + ") " + Std.string(pos);
		error += "\nMay be caused by duplicate classpath where same cp is referenced locally and absolutely.";
		throw new CoverageException(error);
		return null;
	}


	function createReference(cp:String, file:String, pos:Position, isBranch:Bool):AbstractBlock
	{
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

		block.file = file;

		var filePath = file.substr(cp.length+1, file.length-cp.length-4);
		var parts = filePath.split("/");

		parts.pop();

		block.packageName = (parts.length > 0) ? parts.join(".") : "";
		block.className = target.currentClassName;
		block.qualifiedClassName = (block.packageName != "") ? block.packageName + "." + block.className : block.className;
		block.methodName = target.currentMethodName;

		var posInfo = Context.getPosInfos(pos);

		block.min = posInfo.min;
		block.max = posInfo.max;

		var posString = Std.string(pos);

		block.location = posString.substr(5, posString.length-6);
		block.location = block.location.split(" characters ").join(" chars ");

		if(isBranch)
		{
			CoverageMacro.coverage.addBranch(cast(block, Branch));
		}
		else
		{
			CoverageMacro.coverage.addStatement(cast(block, Statement));
		}
		return block;
	}

	/**
	Creates a call to MCoverage.getLogger();

	@param pos - the position to add to
	@return expr matching "m.cover.coverage.MCoverage.getLogger()"
	*/
	function getReferenceToLogger(pos:Position):Expr
	{
		var cIdent = EConst(CIdent("m"));
		pos = MacroUtil.incrementPos(pos, 7);
		var identExpr = {expr:cIdent, pos:pos};

		var eIdentField = EField(identExpr, "cover");
		pos = MacroUtil.incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eIdentField2 = EField(identFieldExpr, "coverage");
		pos = MacroUtil.incrementPos(pos, 7);
		var identFieldExpr2 = {expr:eIdentField2, pos:pos};


		var eType = EType(identFieldExpr2, "MCoverage");
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