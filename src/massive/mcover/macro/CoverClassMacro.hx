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
	static inline var META_TAG_IGNORE:String = "IgnoreCover";

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
	* Class Macro that inserts code coverage into the specified class.
	* This is injected into each class at runtime via MCover.include
	* Recursively steps through class and inserts calls to MCoverRunner in each code block.
	**/
	@:macro public static function build():Array<Field>
	{
		var fields = haxe.macro.Context.getBuildFields();

		var meta = haxe.macro.Context.getLocalClass().get().meta;

		if(!meta.has(META_TAG_IGNORE))
		{
			fields = parseFields(fields);
		}
        return fields;
	}

	static function parseFields(fields:Array<Field>):Array<Field>
	{
		for(field in fields)
        {
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
		//trace(expr.expr);
		switch(expr.expr)
		{
			case ECall(e, params):null;// trace(expr.expr);
			case EConst(c): null;
			case EReturn(e): null;
			case EBlock(exprs): 
			{
				expr = parseBlock(expr, exprs);
			}
			case EIf(econd, eif, eelse):
			{
				if(eelse != null) eelse = parseExpression(eelse);
				eif = parseExpression(eif);
				//expr = parseIf(expr, econd, eif, eelse);	
			}
			case ESwitch(e, cases, edef):
			{	
				parseSwtich(expr, e, cases, edef);
			}
			
			default: //trace(expr.expr);
		}
		return expr;
	}

	static function parseIf(expr:Expr, econd:Expr, eif:Expr, eelse:Null<Expr>):Expr
	{
		if(eelse != null)
		{
			eelse = parseExpression(eelse);
		}

		eif = parseExpression(eif);
		
		return expr;//{expr:EIf(econd, eif, eelse), pos:expr.pos};
	}

	static function parseSwtich(expr:Expr, e:Expr, cases: Array<{ values : Array<Expr>, expr : Expr }>, edef:Null<Expr>):Expr
	{
		//trace(expr.expr);
		for(c in cases)
		{
			c.expr = parseExpression(c.expr);
		}
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
	*		id|classPath|package|class name|min character|max character|location
	* examples:
	*		1|src||Main|1012|1161|src/Main.hx:72: lines 72-78
	*		2|src|example|Example|160|174|src/example/Example.hx:18: characters 2-16
	**/
	static function createCoverageEntry(pos:Position, ?type:String="")
	{
		var posInfo = Context.getPosInfos(pos);
		var posString = Std.string(pos);
		var location:String = posString.substr(5, posString.length-6);

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

				var clsName = parts.pop();
				var packageName = (parts.length > 0) ? parts.join(".") : "";
	
				entry = count + "|" + cp + "|" + packageName + "|" + clsName + "|" + posInfo.min + "|" + posInfo.max + "|" +location;

				break;
			}
		}
		if(entry == null) throw "Invalid coverage position";

		hash.set(count, entry);
		//trace(entry);
		return entry;
	}
	#end
}