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

package mcover.logger.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import mcover.macro.ClassParser;
import mcover.macro.ClassInfo;
import mcover.macro.ExpressionParser;

using haxe.macro.Tools;
using mcover.macro.Tools;

class LoggerExpressionParser implements ExpressionParser
{
	public var ignoreFieldMeta(default, default):String;
	public var includeFieldMeta(default, default):String;

	var counter:Int;

	var methodReturnCount:Int;
	var functionReturnCount:Map<Int,Int>;
	var voidType:ComplexType;

	/**
	current expression stack (i.e. hierachial list of ancestors for the current expression)
	*/
	var info:ClassInfo;

	/**
	Current function stack (ususally just the current method field (unless inside inline function))
	*/
	var functionStack:Array<Function>;
	
	/**
	current expression stack (i.e. hierachial list of ancestors for the current expression)
	*/
	var exprStack:Array<Expr>;


	var currentExpr:Expr;


	public function new()
	{
		counter = 0;
		ignoreFieldMeta = "IgnoreLogging,:IgnoreLogging,:ignore,:macro";
		includeFieldMeta = null;
		
		voidType = TPath({ name:"Void", pack:[], params:[], sub:null });

		methodReturnCount = 0;
		functionReturnCount = new Map();
	}

	public function parseMethod(func:Function, info:ClassInfo):Function
	{
		this.info = info;
		exprStack = [];
		functionStack = [func];
		methodReturnCount = 0;
		functionReturnCount = new Map();
		func.expr = parseExpr(func.expr);
		return func;
	}

	/**
	Overrides defauld ClassParser.parse() to wrap method entry and exit points
	
	@param expr 		the current expression
	@param target 		the current ClassParser instance
	@return the updated expression
	@see ClassParser.parseExpr
	*/
	function parseExpr(e:Expr):Expr
	{
		if(e == null || e.expr == null) return e;

		currentExpr = e;
		exprStack.push(e);	

		var result = switch(e.expr)
		{
			case EFunction(name, func):
				//e.g. var f = function()
				functionStack.push(func);
				func.expr = func.expr.map(parseExpr);
				functionStack.pop();
				functionReturnCount.set(functionStack.length, 0);
				EFunction(name, func).at(e.pos);

			case EReturn(e1):

				e1 = e1.map(parseExpr);
				var exprs = logReturn(e1);

				if(exprs.length == 1)
					EReturn(exprs[0]).at(e.pos);
				else
					EBlock(exprs).at(e.pos);

			case EThrow(e1):
				e1 = e1.map(parseExpr);
				var exprs = logThrow(e1);

				if(exprs.length == 1)
					EThrow(exprs[0]).at(e.pos);
				else
					EBlock(exprs).at(e.pos);

			case EBlock(exprs): 
				exprs = exprs.map(parseExpr);
				exprs = logBlock(exprs);
				EBlock(exprs).at(e.pos);

			case _: e.map(parseExpr);
		}

		exprStack.pop();

		return result;

	}

	/**
	Wraps a top level function code block with loging calls.
	- injects entry log at start of code block,
	- injects exit log at end of code block if last expression isn't a return or throw
	@param exprs - the contents of the code block
	*/
	function logBlock(exprs:Array<Expr>)
	{
		if (exprs.length == 0) return exprs;
		

		var f = functionStack[functionStack.length-1];
		if (currentExpr != f.expr) return exprs;//only care about the main block in a function
		
		var pos:Position = exprs[0].pos;

		var entryLogExpr = logEntry(functionStack.length > 1);
		exprs.unshift(entryLogExpr);

		var lastExpr = exprs[exprs.length-1];
		
		switch (lastExpr.expr)
		{
			case EReturn(_): null;//already handled
			case EThrow(_): null;//already handled
			default:
			{
				var count = 0;

				if (functionStack.length == 1) 
				{
					count = methodReturnCount;
				}
				else
				{
					count = functionReturnCount.get(functionStack.length-1);
				}

				if (count == 0)
				{
					//default exit log
					var exitLogExpr = logExit(lastExpr.pos);
					exprs.push(exitLogExpr);
				}
				else
				{
					trace("ignoring " + info.location);
				}
				
			}
		}

		return exprs;
	}


	/**
	Injects exit log around a return expression.
	To achieve this, the original value is evaluated in a local var,
	then after logging the exit, the local var is returned.

	E.g.:
		return value;
	Becomes:

		var ____m1 = value;
		logExit(...);
		return ____m1;

	For null returns, the local var is skipped - e.g.:

		return;

	Becomes:

		logExit(...);
		return;

	@param e 			the expression being returned (or null)
	*/
	function logReturn(e:Expr):Array<Expr>
	{
		var exprs = wrapExitExpr(e);
		incrementReturnCount();
		return exprs;
	}


	/**
	Injects exit log around a thrown exception.

	To achieve this, the original value is evaluated in a local var,
	then after logging the exit, the var is thrown.

	E.g.:
		throw value;

	Becomes:

		var ____m1 = value;
		logExit(...);
		throw ____m1;

	@param e 			the expression being thrown
	*/
	function logThrow(e:Expr):Array<Expr>
	{
		return wrapExitExpr(e);
	}


	function incrementReturnCount()
	{
		if (functionStack.length == 1)
		{
			methodReturnCount ++;
		}

		var key = functionStack.length-1;
		var count = 1;
		if (functionReturnCount.exists(key) && functionReturnCount.get(key) > 0)
		{
			count = functionReturnCount.get(key) + 1;
		}
		functionReturnCount.set(key, count);
	}



	/**
	Wraps a EReturn or EThrow with an exit log.
	Evaluates returned/thrown value prior to logging (and returning/throwing)

	Checks the parent expression and appends new values if already a code block (EBlock), otherwise
	replaces throw/return with a code block 

	@param e 			the expression being thrown
	*/
	function wrapExitExpr(e:Expr):Array<Expr>
	{

		var pos = currentExpr.pos;
		var exitExprs = createExitExprs(currentExpr, e);	
		var parentExpr = exprStack[exprStack.length-2];


		
		var isMethodWithoutBrackets = false;
		var parentExprDef:ExprDef;

		try
		{
			parentExprDef = parentExpr.expr;
		}
		catch(e:Dynamic)
		{
			//this is a method with no curly braces... yuck!
			isMethodWithoutBrackets = true;
			parentExprDef = EContinue;//a placeholder to allow following logic to proceed
		}
		
		switch (parentExprDef)
		{
			case EBlock(exprs):
			{
				for (i in 0...exprs.length)
				{
					if (exprs[i] == currentExpr)
					{
						exprs.insert(i, exitExprs.eExitLogCall);
						if (exitExprs.eVars != null)
							exprs.insert(i, exitExprs.eVars);
						break;
					}
				}	
				switch (currentExpr.expr)
				{
					case EReturn(_): return [EReturn(exitExprs.eReturnValue).at(pos)];
					case EThrow(_): return [EThrow(exitExprs.eReturnValue).at(pos)];
					default: throw new LoggerException("Unexpected exprDef " + currentExpr);
				}
			}
			default:
			{
				var eExit:Expr;
				switch (currentExpr.expr)
				{
					case EReturn(_): eExit = EReturn(exitExprs.eReturnValue).at(pos);
					case EThrow(_): eExit = EThrow(exitExprs.eReturnValue).at(pos);
					default : throw new LoggerException("Unexpected exprDef " + currentExpr);
				}

				var exprs:Array<Expr> = [exitExprs.eExitLogCall, eExit];
				if (exitExprs.eVars != null) exprs.unshift(exitExprs.eVars);

				if (isMethodWithoutBrackets)
				{
					var entryLogExpr = logEntry(functionStack.length > 1);
					exprs.unshift(entryLogExpr);
				}

				return exprs;
			}
		}
	}

	/**
	Returns a variable containing the value returned from a call to the
	logEntry method.

	i.e.:

		var ___logEntry:Int = MCoverLogger.getLogger().logEntry();

	@param isInlineFunction 	flag indicating if current code block is an inline function (EFunction)
	@return call to logEntry along with local var to store returned value
	*/
	function logEntry(isInlineFunction:Bool=false):Expr
	{
		return macro var ___logEntry = mcover.logger.MCoverLogger.getLogger().logEntry($v{isInlineFunction});
	}

	/**
	Returns a call to the logExit method, including the generated entry id as an argument
	i.e.:

		MLog.getLogger().logExit(___logEntry);

	@param pos - the position to generate at
	@return call to logExit method
	*/
	function logExit(pos:Position):Expr
	{
		var entryVarName = "___logEntry";
		return macro mcover.logger.MCoverLogger.getLogger().logExit($i{entryVarName});
	}


	/**
	Generic helper for EReturns and EThrows that converts a value into three parts
	- A local var to store the original expression
	- An call to the logExit method
	- a reference to the local var to replace in the original EReturn or EThrow
	
	var ____m1 = value;
	logExit(...);
	____m1;

	@param expr 		the original throw expression
	@param e 			the expression being thrown
	@return ExitExprs containing a var, log call and return/throw value;
	*/
	function createExitExprs(expr:Expr, e:Expr):ExitExprs
	{
		var pos:Position = expr.pos;
		var eVars:Expr = null;
		var eReturnValue:Expr = null;
		var eExitLogCall = logExit(pos);


		if (e != null)
		{
			var tempVarName = "____m" + counter++;
			var eVar = {
				type:null,
				name: tempVarName,
				expr:e
			}
			
			eVars = {
				expr:EVars([eVar]),
				pos:pos
			}

			eReturnValue ={
				expr:EConst(CIdent(tempVarName)),
				pos:pos
			}

			
		}
		return {
			eVars:eVars,
			eExitLogCall:eExitLogCall,
			eReturnValue:eReturnValue,
		};
	}
}

typedef ExitExprs = 
{
	eVars:Expr,
	eExitLogCall:Expr,
	eReturnValue:Expr,
}
#end