package mcover;

import haxe.macro.Expr;
//import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;


/**
* Macro class used to inject calls to MCoverRunner into application classes
*/
class MCover
{
	
	/**
	* Class Macro that inserts code coverage into the specified class.
	* This is injected into each class at runtime via MCover.include
	* Recursively steps through class and inserts calls to MCoverRunner in each code block.
	**/
	@:macro public static function build():Array<Field>
	{
        var fields = haxe.macro.Context.getBuildFields();
        fields = parseFields(fields);
        return fields;
	}

	
	#if !macro

		
	#else

	static var coverCount:Int = 0;
	static var coverHash:Hash<Bool> = new Hash();
	static var COVER_PREFIX:String = "__MCOVER__";


	/** 
	* Includes classes/packages for code coverage.
	* Adds @:build(mcover.MCoverMacro.build()) to all classes/packages referenced
	* 
	* From the command line/hxml add a macro reference:
	*	--macro mcover.MCover.include('package.name', null, ['src'])
	* 
	* @param pack - package name to filter on (e.g. "com.example"). Use empty string to match all classes ('')
	* @param ignore - array of classes to exclude from coverage
	* @param classPaths - zero or more classpaths to include in coverage (defaults to local scope only (''))
	**/
	public static function include( pack : String, ?ignore : Array<String>, ?classPaths : Array<String> )
	{
		includePackage(pack, ignore, classPaths);
		haxe.macro.Context.onGenerate(onGenerate);
	}

	/**
	* Recursively loops through classpaths and appends @:build metadata into each matching class
	* @param pack - package name to filter on (e.g. "com.example"). Use empty string to match all classes ('')
	* @param ignore - array of classes to exclude from coverage
	* @param classPaths - zero or more classpaths to include in coverage (defaults to local scope only (''))
	*/
	static function includePackage(pack : String, ?ignore : Array<String>, ?classPaths : Array<String>)
	{

		var skip = if(null == ignore) {
			function(c) return false;
		} else {
			function(c) return Lambda.has(ignore, c);
		}

		if(null == classPaths)
			classPaths = [""];
		
		//normalize class paths
		for( i in 0...classPaths.length )
		{
			var cp = StringTools.replace(classPaths[i], "\\", "/");
		if(StringTools.endsWith(cp, "/"))
			cp = cp.substr(0, -1);
		
			classPaths[i] = cp;
		}
		
		var prefix = pack == '' ? '' : pack + '.';
		for( cp in classPaths ) {
			var path = pack == '' ? cp : cp + "/" + pack.split(".").join("/");
			if( !neko.FileSystem.exists(path) || !neko.FileSystem.isDirectory(path) )
				continue;
			for( file in neko.FileSystem.readDirectory(path) ) {
				if( StringTools.endsWith(file, ".hx") ) {
					var cl = prefix + file.substr(0, file.length - 3);
					if( skip(cl) )
						continue;
	
					//trace(cl);
					Compiler.addMetadata("@:build(mcover.MCover.build())", cl);
					Context.getModule(cl);

					
				} else if(neko.FileSystem.isDirectory(path + "/" + file) && !skip(prefix + file) )
					includePackage(prefix + file, ignore, classPaths);
			}
		}
	}

	/**
	* Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	* This resource is used by MCoverRunner to determine code coverage results
	*/
	static function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		var output = "";
		var count = 0;
        for(key in coverHash.keys())
        {
        	if(output != "") output += "\n";
        	output += key;
        	count ++;
        }

        trace("\n    " + output.split("\n").join("\n    ") + "\n\n    total:" + count + "\n");

        Context.addResource("MCover", haxe.io.Bytes.ofString(output));
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
		switch(field.kind)
    	{
    		case FFun(f):
    		{
    			if(f.expr != null)
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
			
			default: trace(expr.expr);
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


	static function createCoverageExpr(expr:Expr, pos:Position):Expr
	{
		coverCount ++;

		var posString = Std.string(expr.pos);
		var s:String = posString.substr(5, posString.length-6);

		//trace(s);
		coverHash.set(s, false);

		var posInfo = Context.getPosInfos(pos);


		var cIdent = EConst(CIdent("mcover"));
		var identExpr = {expr:cIdent, pos:Context.makePosition(posInfo)}
		
		posInfo = Context.getPosInfos(identExpr.pos);
		posInfo.min = posInfo.max;
		posInfo.max += 6;


		var eType = EType(identExpr, "MCoverRunner");
		var typeExpr = {expr:eType, pos:Context.makePosition(posInfo)};

		posInfo = Context.getPosInfos(typeExpr.pos);
		posInfo.min = posInfo.max;
		posInfo.max += 6;


		var eField = EField(typeExpr, "cover");
		var fieldExpr = {expr:eField, pos:pos};

		posInfo = Context.getPosInfos(fieldExpr.pos);
		posInfo.min = posInfo.max;
		posInfo.max += 7;
			
		var argsExpr = {expr:EConst(CString(s)), pos: Context.makePosition(posInfo)};

		var coverExpr = {expr:ECall(fieldExpr, [argsExpr]), pos:pos};
		return coverExpr;

	}

	#end


}
