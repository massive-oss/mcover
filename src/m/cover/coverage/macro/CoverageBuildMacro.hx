package m.cover.coverage.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import m.cover.macro.BuildMacro;

import m.cover.coverage.DataTypes;

@:keep class CoverageBuildMacro extends BuildMacro
{

	static var statementCount:Int = 0;
	static var branchCount:Int = 0;
	static var coverage = new Coverage();

	/**
	* Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	* This resource is used by MCoverRunner to determine code coverage results
	*/
	static public function onGenerate(types:Array<haxe.macro.Type>):Void
	{
       	var serializedData = haxe.Serializer.run(coverage);
        Context.addResource(MCover.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));
	}

	/**
	Inserts coverage code into the specified class.
	
	@return updated array of fields for the class
	*/
	@:macro public static function build():Array<Field>
	{
		var instance = new CoverageBuildMacro(); 
		var fields = instance.parseFields();
		return fields;
	}

	var counter:Int;

	public function new()
	{
		ignoreFieldMeta = "IgnoreCover";
		counter = 0;
		super();
	}

	/**
	Overrides defauld BuildMacro.parse() to wrap branches and statement blocks
	
	@param expr - the current expression
	@return the updated expression
	@see BuildMacro.parse
	*/
	override function parse(expr:Expr):Expr
	{
		switch(expr.expr)
		{
			case EIf(econd, eif, eelse):
			{
				expr = super.parse(expr);
				econd = createBranchCoverageExpr(econd);
				expr.expr = EIf(econd, eif, eelse);
			}
			case EWhile(econd, e, normalWhile):
			{
				expr = super.parse(expr);
				econd = createBranchCoverageExpr(econd);
				expr.expr = EWhile(econd, e, normalWhile);
			}
			case ETernary(econd, eif, eelse): 
			{
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				expr = super.parse(expr);
				econd = createBranchCoverageExpr(econd);
				expr.expr = ETernary(econd, eif, eelse);
			}
			case EBlock(exprs): 
			{
				//e.g. {...}
				super.parse(expr);
				parseEBlock(expr, exprs);
			}
			case EBinop(op, e1, e2):
			{
				//e.g. i<2; a||b, i==b
				super.parse(expr);
				parseEBinop(expr, op, e1, e2);
			}
			default: expr = super.parse(expr);
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
			if(expr != functionStack[functionStack.length-1].expr) return;
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
		pos = incrementPos(pos, 13);
		var fieldExpr = {expr:eField, pos:pos};
		
		pos = incrementPos(pos, blockId.length);
		var arg1 = {expr:EConst(CInt(blockId)), pos:pos};

		pos = incrementPos(pos, 2);
		
		return {expr:ECall(fieldExpr, [arg1]), pos:pos};
	}

	/**
	* wraps a boolean value within a branch in a call to MCover.getLogger().logBranch(id, value, compareValue);
	**/
	function createBranchCoverageExpr(expr:Expr, ?compareExpr:Expr = null):Expr
	{
		var pos = expr.pos;
		var block = createCodeBlockReference(pos, true);
	
		var blockId = Std.string(block.id);

		var baseExpr = getReferenceToLogger(pos);
		pos = baseExpr.pos;

		var eField = EField(baseExpr, "logBranch");
		pos = incrementPos(pos, 4);
		var fieldExpr = {expr:eField, pos:pos};
		
		var args:Array<Expr> = [];

		pos = incrementPos(pos, blockId.length);
	
		args.push({expr:EConst(CInt(blockId)), pos:pos});

		pos = incrementPos(pos, 5);
		args.push({expr:expr.expr, pos:pos});

		if(compareExpr != null)
		{
			pos = incrementPos(pos, 5);
			args.push({expr:compareExpr.expr, pos:pos});
		}
		
		expr.expr = ECall(fieldExpr, args);
		
		return expr;
	}

	function createCodeBlockReference(pos:Position, ?isBranch:Bool = false):AbstractBlock
	{
		var posInfo = Context.getPosInfos(pos);
		var file:String = posInfo.file;

		for (cp in MCover.classPathHash)
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
		block.className = currentClassName;
		block.qualifiedClassName = (block.packageName != "") ? block.packageName + "." + block.className : block.className;
		block.methodName = currentMethodName;

		var posInfo = Context.getPosInfos(pos);

		block.min = posInfo.min;
		block.max = posInfo.max;

		var posString = Std.string(pos);

		block.location = posString.substr(5, posString.length-6);
		block.location = block.location.split(" characters ").join(" chars ");

		if(isBranch)
		{
			coverage.addBranch(cast(block, Branch));
		}
		else
		{
			coverage.addStatement(cast(block, Statement));
		}
		return block;
	}

	/**
	Creates a call to MCover.getLogger();

	@param pos - the position to add to
	@return expr matching "m.cover.MCover.getLogger()"
	*/
	function getReferenceToLogger(pos:Position):Expr
	{
		var cIdent = EConst(CIdent("m"));
		pos = incrementPos(pos, 7);
		var identExpr = {expr:cIdent, pos:pos};

		var eIdentField = EField(identExpr, "cover");
		pos = incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eType = EType(identFieldExpr, "MCover");
		pos = incrementPos(pos, 5);
		var typeExpr = {expr:eType, pos:pos};

		var eField = EField(typeExpr, "getLogger");
		pos = incrementPos(pos, 9);
		var fieldExpr = {expr:eField, pos:pos};

		pos = incrementPos(pos, 2);
		return {expr:ECall(fieldExpr, []), pos:pos};
	}

}

#end