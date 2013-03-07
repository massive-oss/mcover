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

package mcover.macro;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.PosInfos;

#if haxe3

#else
private typedef Case = { values : Array<Expr>, expr : Expr }
#end

/**
Generic recursive parser of expressions inside a class's fields.
Provides mechanism for adding one or more ExpressionParser instances to take reponsibility for modifying field contents.

For each ExpressionParser
- checks if current field should be included/ignored
- calls parseExpr for each nested expression

*/
interface ClassParser
{
	/**
	current expression stack (i.e. hierachial list of ancestors for the current expression)
	*/
	var exprStack(default, null):Array<Expr>;
	/**
	Current function stack (ususally just the current method field (unless inside inline function))
	*/
	var functionStack(default, null):Array<Function>;

	/**
	current expression stack (i.e. hierachial list of ancestors for the current expression)
	*/
	var info(default, null):ClassInfo;

	/**
	registers an ExpressionParser to handler parse
	*/
	function addExpressionParser(parser:ExpressionParser):Void;
}

class ClassParserImpl implements ClassParser
{
	public var info(default, null):ClassInfo;

	public var functionStack(default, null):Array<Function>;
	public var exprStack(default, null):Array<Expr>;


	var fields:Array<Field>;
	var type:Null<haxe.macro.Type>;

	var generatedFields:Array<Field>;

	var parsers:Array<ExpressionParser>;
	var fieldParsers:Array<ExpressionParser>;

	public function new()
	{
		parsers = [];
		fieldParsers = [];
		fields = Context.getBuildFields();
		type = Context.getLocalType();

		info = new ClassInfo();

		switch(type)
		{
			#if haxe3
			case TInst(t, _):
			#else
			case TInst(t,params):
			#end
			{
				var parts = Std.string(t).split(".");
				info.className = parts.pop();
				info.packageName = parts.join(".");

			}
			default: null;
		}

		if(fields.length > 0)
		{
			info.fileName = Context.getPosInfos(fields[0].pos).file;
		}
	}

	/**
	Registers an instance of an expression parser for a particular feature.
	*/
	public function addExpressionParser(parser:ExpressionParser)
	{
		parser.target = this;
		parsers.push(parser);
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


	function isFieldParser(parser:ExpressionParser, field:Field):Bool
	{
		if(parser.ignoreFieldMeta != null)
		{
			var metas = parser.ignoreFieldMeta.split(",");

			for(item in field.meta)
			{
				for(meta in metas)
				{
					if(item.name == meta) return false;
				}
				
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
		info.methodName = field.name;

		if(f.expr == null ) return;
		functionStack = [f];

		f.expr = parseExpr(f.expr);

		field.kind = FFun(f);

		for(parser in fieldParsers)
		{
			parser.parseMethod(field, f);
		}
	}
		


	/**
		recursively steps through expressions and parses accordingly
	*/
	function parseExpr(expr:Expr):Expr
	{
		if(expr == null) return null;
		if(expr.expr == null && expr.pos == null) return expr;
		
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
			case EFunction(name, f): 
				//e.g. var f = function()
				functionStack.push(f);
				f.expr = parseExpr(f.expr);
				expr.expr = EFunction(name, f);
				functionStack.pop();
			
			case EDisplay(e, isCall):
				//no idea what this is???
				e = parseExpr(e);
				expr.expr = EDisplay(e, isCall);
			
			case ECast(e, t):
				// cast(foo, Foo);
				e = parseExpr(e);
				expr.expr = ECast(e, t);
			
			case EIf(econd, eif, eelse):
				//e.g. if(){}else{}
				parseEIf(expr, econd, eif, eelse);
		
			case ESwitch(e, cases, edef):
				parseESwitch(expr, e, cases, edef);

			case ETry(e, catches):
				//e.g. try{...}catch(){}
				parseExpr(e);
				for(c in catches)
				{
					parseExpr(c.expr);
				}

			case EThrow(e): 
				//e.g. throw "ARRGH!"
				e = parseExpr(e);
				expr.expr = EThrow(e);
			
			case EWhile(econd, e, normalWhile):
				//e.g. while(i<2){}
				econd = parseExpr(econd);
				e = parseExpr(e);
				expr.expr = EWhile(econd, e, normalWhile);
			
			case EField(e, field):
				//e.g. isFoo
				e = parseExpr(e);
				expr.expr = EField(e, field);
			
			case EParenthesis(e): 
				//e.g. (...)
				e = parseExpr(e);
				expr.expr = EParenthesis(e);
			
			case ENew(t, params):
				//e.g. new Foo();
				params = parseExprs(params);
				expr.expr = ENew(t, params);
			
			case ECall(e, params):
				//e.g. method(); 
				e = parseExpr(e);
				params = parseExprs(params);
				expr.expr = ECall(e, params);
			
			case EReturn(e):
				//e.g. return foo;
				e = parseExpr(e);
				expr.expr = EReturn(e);
			
			case EVars(vars):
				//e.g. var i = xxx;
				for(v in vars)
				{
					v.expr = parseExpr(v.expr);
				}
			
			case EBinop(op, e1, e2):
				//e.g. i<2; a||b, i==b
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EBinop(op, e1, e2);
			case EUnop(op,postFix,e):
				//e.g. i++;
				e = parseExpr(e);
				expr.expr = EUnop(op, postFix, e);
			case ETernary(econd, eif, eelse): 
				//e.g. var n = (1 + 1 == 2) ? 4 : 5;
				parseETernary(expr, econd, eif, eelse);
			case EObjectDecl(fields):
				//e.g. var o = { a:"a", b:"b" }
				for(f in fields)
				{
					parseExpr(f.expr);
				}
			case EFor(it, e):
				//e.g. for(i in 0...5){}
				it = parseExpr(it);
				e = parseExpr(e);
				expr.expr = EFor(it, e);
			case EIn(e1, e2):
				//e.g. for(i in 0...5){}
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EIn(e1, e2);
			case EArrayDecl(values):
				//e.g. a = [1,2,3];
				for(v in values)
				{
					v = parseExpr(v);
				}
			case EArray(e1, e2):
				//not sure dif with EArrayDecl
				e1 = parseExpr(e1);
				e2 = parseExpr(e2);
				expr.expr = EArray(e1, e2);
			case EBlock(exprs): 
				//array of expressions e.g. {...}
				exprs = parseExprs(exprs);
				expr.expr = EBlock(exprs);
		
			#if haxe3
				case EUntyped(_): null;//don't want to mess around with untyped code
				case EConst(_): null;//i.e. any constant (string, type, int, regex, ident (local var ref))
				case EDisplayNew(_): null;  //no idea what this is??
			#else
				case EConst(c): null;//i.e. any constant (string, type, int, regex, ident (local var ref))
				case EDisplayNew(r): null;  //no idea what this is??
				case EType(e, field):
					//e.g. Foo.bar;
					e = parseExpr(e);
					expr.expr = EType(e, field);
				case EUntyped(e1): null;//don't want to mess around with untyped code
			#end
			
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

	function parseESwitch(expr:Expr, e:Expr, cases: Array<Case>, edef:Null<Expr>)
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
			Sys.println(msg);
		#end
	}
}	

#end