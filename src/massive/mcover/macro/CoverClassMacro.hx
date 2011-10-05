package massive.mcover.macro;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;

import massive.mcover.data.AllClasses;
import massive.mcover.data.Package;
import massive.mcover.data.File;
import massive.mcover.data.Clazz;
import massive.mcover.data.Method;
import massive.mcover.data.AbstractBlock;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;

#end
class CoverClassMacro
{
	#if macro
	

	static var statementCount:Int = 0;
	static var branchCount:Int = 0;
	static var allClasses = new AllClasses();
	
	
	/**
	* Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	* This resource is used by MCoverRunner to determine code coverage results
	*/
	static public function onGenerate(types:Array<haxe.macro.Type>):Void
	{

       	var serializedData = haxe.Serializer.run(allClasses);
       
        Context.addResource(MCover.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));

	}

	/**
	* Inserts code coverage into the specified class.
	* This is injected into each class at runtime via MCover.include
	* Recursively steps through class and inserts calls to MCoverRunner in each code block.
	**/
	@:macro public static function build():Array<Field>
	{

		var classType = Context.getLocalClass().get();
		var fields = Context.getBuildFields();


		currentClassName = classType.name;
		
		var meta = classType.meta;

		if(!meta.has(META_TAG_IGNORE))
		{
			fields = parseFields(fields);
		}
        return fields;
	}


	static inline var META_TAG_IGNORE:String = "IgnoreCover";
	static var currentClassName:String;
	static var currentMethodName:String;

	static function parseFields(fields:Array<Field>):Array<Field>
	{
		for(field in fields)
        {
        	//debug(field);
        	field = parseField(field);  	
        }
        return fields;
	}

	static function parseField(field:Field):Field
	{
		for(item in field.meta)
		{
			if(item.name == META_TAG_IGNORE)
			{	
				return field;
			}
		}

		switch(field.kind)
    	{
    		case FFun(f):
    		{	
    			currentMethodName = field.name == "new" ? "constructor" : field.name;
    			if(f.expr != null )
				{
					f.expr = parseExpression(f.expr);
				}
    		}
    		default: null;
    	}

    	return field;
	}

	static function parseExpressions(exprs:Array<Expr>)
	{
		for(expr in exprs)
		{
			expr = parseExpression(expr);
		}
		return exprs;
	}

	static function parseExpression(expr:Expr):Expr
	{
		var tmp:Array<Expr> = [];
		//debug(expr.expr);
		
		switch(expr.expr)
		{
			case EContinue: null;
			case EBreak: null;
			case EConst(c): null;
			case EFunction(name, f): 
			{
				tmp = [f.expr];
				//e.g. var f = function()
			}
			case EDisplayNew(t): null;  //no idea what this is??
			case EDisplay(e, isCall): tmp = [e];//no idea what this is???
			

			case ECast(e, t): tmp = [e];// case(foo, Foo);
			case EIf(econd, eif, eelse):
			{
				//e.g. if(){}else{}
				tmp = [econd, eif];
				if(eelse!=null) tmp.push(eelse);
			}
		
			case ESwitch(e, cases, edef):
			{	
				parseSwtich(expr, e, cases, edef);
			}
			case ETry(e, catches):
			{
				//e.g. try{...}catch(){}
				tmp = [e];
				for(c in catches)
				{
					tmp.push(c.expr);
				}
			}
			case EThrow(e): tmp = [e];//e.g. throw "foo";
			case EWhile(econd, e, normalWhile): tmp = [econd, e];//e.g. while(i<2){}
			case EField(e, field):tmp = [e];//e.g. Sdt.string()
			case EParenthesis(e):tmp = [e];//e.g. {}
			case ENew(t, params): tmp = params;
			case EType(e, field):tmp = [e];
			case ECall(e, params):
			{
				//e.g. method(); 
				tmp = [e];
				tmp = tmp.concat(params);
			}
			case EReturn(e): tmp = [e];//e.g. return foo;
			case EVars(vars):
			{
				//e.g. var i=0;
				for(v in vars)
				{
					if(v.expr != null) tmp.push(v.expr);
				}
			}
			case EBinop(op, e1, e2):
			{
				//e.g. i<2; a||b, i==b
				expr = parseBinop(expr, op, e1, e2);
			}
			case EUnop(op,postFix,e): tmp = [e];//e.g. i++;
			case ETernary(econd, eif, eelse): 
			{
				tmp = [econd, eif, eelse];
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
			}
			case EObjectDecl(fields):
			{
				//e.g. var o = { a:"a", b:"b" }
				for(f in fields)
				{
					tmp.push(f.expr);
				}
			}

			case EFor(it, e): tmp = [it, e];//e.g. for(i in 0...5){}
			case EIn(e1, e2): tmp = [e1, e2];//e.g. for(i in 0...5){}
			case EArrayDecl(values):
			{
				//e.g. a = [1,2,3];
				for(v in values)
				{
					tmp.push(v);
				}
			}
			case EArray(e1, e2):
			{
				tmp = [e1,e2];//not sure
			}
			case EBlock(exprs): 
			{
				expr = parseBlock(expr, exprs);//e.g. {...}
			}
			default: debug(expr.expr);
		}

		if(tmp.length > 0)
		{
			expr = parseGenericExprDef(expr, tmp);
		}
		return expr;
	}


	static function parseGenericExprDef(expr:Expr, exprs:Array<Expr>):Expr
	{
		for(e in exprs)
		{
			if(e == null) continue;
			e = parseExpression(e);
		}
		return expr;
	}

	
	static function parseSwtich(expr:Expr, e:Expr, cases: Array<{ values : Array<Expr>, expr : Expr }>, edef:Null<Expr>):Expr
	{
		e = parseExpression(e);

		for(c in cases)
		{
			c.expr = parseExpression(c.expr);
		}

		return expr;
	}

	/*static function parseTry(expr:Expr, e:Expr, catches:Array<{ type : ComplexType, name : String, expr : Expr }>):Expr
	{
		e = parseExpression(e);
		for(ctch in catches)
		{
			ctch.expr = parseExpression(ctch.expr);	
		}
		return expr;
	}*/


	static function parseWhile(expr:Expr, econd:Expr, e:Expr, normalWhile:Bool)
	{
		econd = parseExpression(econd);
		e = parseExpression(e);
		return expr;
	}


	//e.g. i<2; a||b, i==b
	static function parseBinop(expr:Expr, op:Binop, e1:Expr, e2:Expr):Expr
	{
		//debug(expr);
		
		switch(op)
		{
			case OpBoolOr:
				e1 = createBranchCoverageExpr(e1);
				e2 = createBranchCoverageExpr(e2);
			default: null;//debug(expr);
		}

		//expr.expr = EBinop(op, e1, e2);

		//debug(expr);

		//expr = parseGenericExprDef(expr, [e1, e2]);
		return expr;
	}



	static function parseBlock(expr:Expr, exprs:Array<Expr>):Expr
	{
		parseExpressions(exprs);

		var pos:Position = (exprs.length == 0) ? expr.pos : exprs[0].pos;

		var coverageExpr = createBlockCoverageExpr(expr, pos);

		exprs.unshift(coverageExpr);

		return expr;
	}





	/**
	* generates a call to the runner to insert into the code block containing a unique id
	*		mcover.MCoverRunner.log(id)
	* @see createCodeBlock for key format
	**/
	static function createBlockCoverageExpr(expr:Expr, pos:Position):Expr
	{
		var block = createCodeBlockReference(pos);
		var blockId = Std.string(block.id);
			
		//EField({ expr => EConst(CIdent(massive)), pos => #pos(src/Main.hx:9: characters 2-9) },mcover)

		var cIdent = EConst(CIdent("massive"));
		pos = incrementPos(pos, 7);
		var identExpr = {expr:cIdent, pos:pos};

		var eIdentField = EField(identExpr, "mcover");
		pos = incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eType = EType(identFieldExpr, "MCover");
		pos = incrementPos(pos, 13);
		var typeExpr = {expr:eType, pos:pos};

		var eField = EField(typeExpr, "statement");
		pos = incrementPos(pos, 4);
		var fieldExpr = {expr:eField, pos:pos};
		
		pos = incrementPos(pos, blockId.length);
		var arg1 = {expr:EConst(CInt(blockId)), pos:pos};

		pos = incrementPos(pos, 2);
		var coverExpr = {expr:ECall(fieldExpr, [arg1]), pos:pos};

		return coverExpr;
	}

	/**
	* wraps a boolean value within a branch in a call to MCover.logBranch(id, value);
	**/
	static function createBranchCoverageExpr(expr:Expr):Expr
	{
		
		var pos = expr.pos;
		var block = createCodeBlockReference(pos, true);
		var blockId = Std.string(block.id);
			
		var cIdent = EConst(CIdent("massive"));
		pos = incrementPos(pos, 7);
		var identExpr = {expr:cIdent, pos:pos};

		var eIdentField = EField(identExpr, "mcover");
		pos = incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eType = EType(identFieldExpr, "MCover");
		pos = incrementPos(pos, 13);
		var typeExpr = {expr:eType, pos:pos};

		var eField = EField(typeExpr, "branch");
		pos = incrementPos(pos, 4);
		var fieldExpr = {expr:eField, pos:pos};
		
		pos = incrementPos(pos, blockId.length);
		var arg1 = {expr:EConst(CInt(blockId)), pos:pos};

		pos = incrementPos(pos, 5);
		var arg2 = {expr:expr.expr, pos:pos};

		expr.expr = ECall(fieldExpr, [arg1, arg2]);
		return expr;
	}
	
	static function createCodeBlockReference(pos:Position, ?isBranch:Bool = false):AbstractBlock
	{
		var posInfo = Context.getPosInfos(pos);
		var file:String = posInfo.file;

		for (cp in MCover.classPathHash)
		{
			//trace(cp + ", " + file);
			if(file.indexOf(cp) == 0)
			{	
				return createReference(cp, file, pos, isBranch);
			}
		}
		throw "Invalid coverage position " + Std.string(pos);
		return null;
	}


	static function createReference(cp:String, file:String, pos:Position, isBranch:Bool):AbstractBlock
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

		if(isBranch)
		{
			allClasses.addBranch(cast(block, Branch));
		}
		else
		{
			allClasses.addStatement(cast(block, Statement));
		}
		return block;
	}

	static function incrementPos(pos:Position, length:Int):Position
	{
		var posInfos = Context.getPosInfos(pos);
		posInfos.max = posInfos.min + length;
		return Context.makePosition(posInfos);
	}

	static function debug(value:Dynamic, ?posInfos:haxe.PosInfos)
	{
		#if MCOVER_DEBUG
			neko.Lib.println(posInfos.fileName+ ":" + posInfos.lineNumber + ": " + value);
		#end
	}
	#end
}