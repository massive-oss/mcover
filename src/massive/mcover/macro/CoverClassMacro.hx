package massive.mcover.macro;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
#end
class CoverClassMacro
{
	#if macro
	
	static public  var hash:IntHash<String> = new IntHash();

	/**
	* Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	* This resource is used by MCoverRunner to determine code coverage results
	*/
	static public function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		var output = "";
		for(i in 0...Lambda.count(hash))
		{
			var entry = hash.get(i);
			if(output != "") output += "\n";
        	output += entry;
		}
       	// trace("\n    " + output.split("\n").join("\n    ") + "\n\n    total:" + Lambda.count(hash) + "\n");
        Context.addResource("MCover", haxe.io.Bytes.ofString(output));
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
			case EBinop(op, e1, e2): tmp = [e1, e2];//e.g. i<2;
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

	static function parseBlock(expr:Expr, exprs:Array<Expr>):Expr
	{
		parseExpressions(exprs);

		var pos:Position = (exprs.length == 0) ? expr.pos : exprs[0].pos;

		var coverageExpr = createCoverageExpr(expr, pos);

		exprs.unshift(coverageExpr);

		return expr;
	}

	static function incrementPos(pos:Position, length:Int):Position
	{
		var posInfos = Context.getPosInfos(pos);
		posInfos.max = posInfos.min + length;
		return Context.makePosition(posInfos);
	}
	/**
	* generates a call to the runner to insert into the code block containing a unique key
	*		mcover.MCoverRunner.log(xxx)
	* @see createCoverageEntry for key format
	**/
	static function createCoverageExpr(expr:Expr, pos:Position):Expr
	{
		var coverageString:String = createCoverageEntry(pos);
		
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

		var eField = EField(typeExpr, "log");
		pos = incrementPos(pos, 4);
		var fieldExpr = {expr:eField, pos:pos};
		

		pos = incrementPos(pos, coverageString.length);
		var argsExpr = {expr:EConst(CString(coverageString)), pos:pos};

		pos = incrementPos(pos, 2);
		var coverExpr = {expr:ECall(fieldExpr, [argsExpr]), pos:pos};

		return coverExpr;
	}

	/**
	* generate a unique key for the entry in the following format:
	*		id|file|package|class name|min character|max character|location
	* examples:
	*		1|src/Main.hx||Main|1012|1161|src/Main.hx:72: lines 72-78
	*		2|src/example/Example.hx|example|Example|160|174|src/example/Example.hx:18: characters 2-16
	**/
	static function createCoverageEntry(pos:Position, ?type:String="")
	{
		var posInfo = Context.getPosInfos(pos);
		var posString = Std.string(pos);
		var summary:String = posString.substr(5, posString.length-6);

		var file:String = posInfo.file;
		var entry:String;

		var count = Lambda.count(hash);

		for (cp in MCover.classPathHash)
		{
			//trace(cp + ", " + file);
			if(file.indexOf(cp) == 0)
			{
				
				var cls = file.substr(cp.length+1, file.length-cp.length-4);
				
				var parts = cls.split("/");

				parts.pop();//remve the default class name for this file;

				var clsName = currentClassName;
				var packageName = (parts.length > 0) ? parts.join(".") : "";
	
				entry = count + "|" + file + "|" + packageName + "|" + clsName + "|" + posInfo.min + "|" + posInfo.max + "|" + summary;

				break;
			}
		}
		if(entry == null) throw "Invalid coverage position";

		hash.set(count, entry);
		//trace(entry);
		return entry;
	}


	static function debug(value:Dynamic, ?posInfos:haxe.PosInfos)
	{
		#if MCOVER_DEBUG
			neko.Lib.println(posInfos.fileName+ ":" + posInfos.lineNumber + ": " + value);
		#end
	}
	#end
}