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

package m.cover.macro;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.PosInfos;


interface IBuildMacro
{
	var exprStack(default, null):Array<Expr>;
	var functionStack(default, null):Array<Function>;
	var currentClassName(default, null):String;
	var currentPackageName(default, null):String;
	var currentMethodName(default, null):String;
}

class BuildMacro implements IBuildMacro
{

	/**
	Stub build macro that should be redefined in concrete instance.
	This can be used to validate no bugs in recursive expr parsing of class
	
	@return updated array of fields for the class
	*/
	@:macro public static function build(keys:Array<String>):Array<Field>
	{

		var instance = new BuildMacro(keys); 
		var fields = instance.parseFields();
		return fields;
	}

	static var registry:Hash<Class<BuildMacroParser>> = new Hash();


	public static function registerParser(id:String, parser:Class<BuildMacroParser>)
	{
		registry.set(id, parser);
	}

	/////////////////

	public var currentClassName(default, null):String;
	public var currentPackageName(default, null):String;
	public var currentMethodName(default, null):String;

	public var functionStack(default, null):Array<Function>;
	public var exprStack(default, null):Array<Expr>;


	var fields:Array<Field>;
	var type:Null<haxe.macro.Type>;

	

	var generatedFields:Array<Field>;

	

	var parsers:Array<BuildMacroParser>;
	var fieldParsers:Array<BuildMacroParser>;

	public function new(keys:Array<String>)
	{
		fields = Context.getBuildFields();
		type = Context.getLocalType();
		

		switch(type)
		{
			case TInst(t, params):
			{
				var parts = Std.string(t).split(".");
				currentClassName = parts.pop();
				currentPackageName = parts.join(".");
			}
			default: null;
		}


		addInstanceParsers(keys);
		
	}

	function addInstanceParsers(keys:Array<String>)
	{
		parsers = [];

		for(key in registry.keys())
		{
			if(!registry.exists(key)) continue;

			var parser = Type.createInstance(registry.get(key), []);
			parser.target = this;
			parsers.push(parser);
		}

		//trace(currentPackageName + "." + currentClassName + ":" + keys);

	}

	/**
	 * loops through all class fields and interogates contents recursively
	 */
	public function parseFields():Array<Field>
	{
		if(parsers.length == 0) return null;

		functionStack = [];
		exprStack = [];
		generatedFields = [];

		for(field in fields)
        {
        	field = parseField(field);  	
        }

        for(field in generatedFields)
        {
        	fields.push(field);
        }
        return fields;
	}

	function parseField(field:Field):Field
	{
		fieldParsers = [];
		for(parser in parsers)
		{
			if(isFieldParser(parser, field))
			{
				fieldParsers.push(parser);
			}
		}

		if(fieldParsers.length == 0) return field;
		
		switch(field.kind)
    	{
    		case FFun(f): parseMethod(field, f);
    		default: null;
    	}
    	return field;
	}


	function isFieldParser(parser:BuildMacroParser, field:Field):Bool
	{
		if(parser.ignoreFieldMeta != null)
		{
			for(item in field.meta)
			{
				if(item.name == parser.ignoreFieldMeta) return false;
			}
		}
		else if(parser.includeFieldMeta != null)
		{
			for(item in field.meta)
			{
				if(item.name != parser.includeFieldMeta) return false;
			}
		}

		return true;
	}



	function parseMethod(field:Field, f:Function)
	{
		currentMethodName = field.name;
		if(f.expr == null ) return;
		functionStack = [f];
		f.expr = parseExpr(f.expr);
	}


	/**
		recursively steps through expressions and parses accordingly
	*/
	function parseExpr(expr:Expr):Expr
	{
		if(expr == null) return null;
		
		exprStack.push(expr);	

		expr = parse(expr);

		for(parser in fieldParsers)
		{
			expr = parser.parseExpr(expr);
		}

		exprStack.pop();

		return expr;
	}



	function parse(expr:Expr):Expr
	{
		switch(expr.expr)
		{
			case EContinue: null;
			case EBreak: null;
			case EConst(c): null;//i.e. any constant (string, type, int, regex, ident (local var ref))
			case EFunction(name, f): 
			{
				//e.g. var f = function()
				functionStack.push(f);
				f.expr = parseExpr(f.expr);
				expr.expr = EFunction(name, f);
				functionStack.pop();
			}
			case EDisplayNew(t): null;  //no idea what this is??
			case EDisplay(e, isCall):
			{
				//no idea what this is???
				e = parseExpr(e);
				expr.expr = EDisplay(e, isCall);
			}
			case ECast(e, t):
			{
				// cast(foo, Foo);
				e = parseExpr(e);
				expr.expr = ECast(e, t);
			}
			case EIf(econd, eif, eelse):
			{
				//e.g. if(){}else{}
				parseEIf(expr, econd, eif, eelse);
			}
		
			case ESwitch(e, cases, edef):
			{	
				parseESwitch(expr, e, cases, edef);
			}
			case ETry(e, catches):
			{
				//e.g. try{...}catch(){}
				parseExpr(e);
				for(c in catches)
				{
					parseExpr(c.expr);
				}
			}
			case EThrow(e): 
			{
				//e.g. throw "ARRGH!"
				e = parseExpr(e);
				expr.expr = EThrow(e);
			}
			case EWhile(econd, e, normalWhile):
			{
				//e.g. while(i<2){}
				econd = parseExpr(econd);
				e = parseExpr(e);
				expr.expr = EWhile(econd, e, normalWhile);
			}
			case EField(e, field):
			{
				//e.g. isFoo
				e = parseExpr(e);
				expr.expr = EField(e, field);
			}
			case EParenthesis(e): 
			{
				//e.g. (...)
				e = parseExpr(e);
				expr.expr = EParenthesis(e);
			}
			
			case ENew(t, params):
			{
				//e.g. new Foo();
				params = parseExprs(params);
				expr.expr = ENew(t, params);
			}
			
			case EType(e, field):
			{
				//e.g. Foo.bar;
				e = parseExpr(e);
				expr.expr = EType(e, field);

			}
			case ECall(e, params):
			{
				//e.g. method(); 
				e = parseExpr(e);
				params = parseExprs(params);
				expr.expr = ECall(e, params);
			}
			case EReturn(e):
			{
				//e.g. return foo;
				e = parseExpr(e);
				expr.expr = EReturn(e);
			}
			case EVars(vars):
			{
				//e.g. var i = xxx;
				for(v in vars)
				{
					v.expr = parseExpr(v.expr);
				}
			}
			case EBinop(op, e1, e2):
			{
				//e.g. i<2; a||b, i==b
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EBinop(op, e1, e2);
			}
			case EUnop(op,postFix,e):
			{
				//e.g. i++;
				e = parseExpr(e);
				expr.expr = EUnop(op, postFix, e);
			}
			case ETernary(econd, eif, eelse): 
			{
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				parseETernary(expr, econd, eif, eelse);
			}
			case EObjectDecl(fields):
			{
				//e.g. var o = { a:"a", b:"b" }
				for(f in fields)
				{
					parseExpr(f.expr);
				}
			}
			case EFor(it, e):
			{
				//e.g. for(i in 0...5){}
				it = parseExpr(it);
				e = parseExpr(e);
				expr.expr = EFor(it, e);
			}
			case EIn(e1, e2):
			{
				//e.g. for(i in 0...5){}
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EIn(e1, e2);
			}
			case EArrayDecl(values):
			{
				//e.g. a = [1,2,3];
				for(v in values)
				{
					v = parseExpr(v);
				}
			}
			case EArray(e1, e2):
			{
				//not sure dif with EArrayDecl
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EArray(e1, e2);
			}
			case EBlock(exprs): 
			{
				//array of expressions e.g. {...}
				exprs = parseExprs(exprs);
				expr.expr = EBlock(exprs);

			}
			case EUntyped(e1): null;//don't want to mess around with untyped code
			default: debug(expr.expr);
		}

		return expr;
	}


	function parseEIf(expr:Expr, econd:Expr, eif:Expr, eelse:Expr)
	{
		econd = parseExpr(econd);
		eif = parseExpr(eif);
		eelse = parseExpr(eelse);
		expr.expr = EIf(econd, eif, eelse);

	}

	function parseESwitch(expr:Expr, e:Expr, cases: Array<{ values : Array<Expr>, expr : Expr }>, edef:Null<Expr>)
	{
		e = parseExpr(e);

		for(c in cases)
		{
			c.values = parseExprs(c.values);
			c.expr = parseExpr(c.expr);	
		}

		edef = parseExpr(edef);
		expr.expr = ESwitch(e, cases, edef);
	}

	function parseETernary(expr:Expr, econd:Expr, eif:Expr, eelse:Expr)
	{
		econd = parseExpr(econd);
		eif = parseExpr(eif);
		eelse = parseExpr(eelse);
		expr.expr = ETernary(econd, eif, eelse);
	}


	/////////


	/**
	parses an array of expressions

	@return updated array of expressions
	*/
	public function parseExprs(exprs:Array<Expr>):Array<Expr>
	{
		var temp:Array<Expr> = exprs.concat([]);

		for(expr in temp)
		{
			expr = parseExpr(expr);
		}
		return exprs;
	}






	public function debug(value:Dynamic, ?pos:PosInfos)
	{
		#if MACRO_LOGGER_DEBUG
			var msg = pos.className + "(" + pos.lineNumber + "):\n   " + Std.string(value);
			neko.Lib.println(msg);
		#end
	}
}	

#end