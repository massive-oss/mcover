package m.cover.logger.macro;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;

import m.cover.macro.BuildMacro;


class LoggerBuildMacro extends BuildMacro
{
	/**
	Inserts code into the specified class.
	
	@return updated array of fields for the class
	*/
	@:macro public static function build():Array<Field>
	{
		var instance = new LoggerBuildMacro(); 
		var fields = instance.parseFields();
		return fields;
	}

	var counter:Int;

	public function new()
	{
		counter = 0;
		ignoreFieldMeta = "IgnoreLogging";
		super();
	}

	/**
	Overrides defauld BuildMacro.parse() to wrap method entry and exit points
	
	@param expr - the current expression
	@return the updated expression
	@see BuildMacro.parse
	*/
	override function parse(expr:Expr):Expr
	{
		switch(expr.expr)
		{
			case EReturn(e):
			{
				super.parse(expr);
				parseEReturn(expr, e);
			}
			case EBlock(exprs): 
			{
				//e.g. {...}
				super.parse(expr);
				parseEBlock(expr, exprs);
			}
			case EThrow(e):
			{
				super.parse(expr);
				parseEThrow(expr, e);
			}
			default: expr = super.parse(expr);
		}
		return expr;
	}

	/**
	Wraps a top level function code block with loging calls.
	- injects entry log at start of code block,
	- injects exit log at end of code block if last expression isn't a return or throw
	@param expr - the current block expr
	@param exprs - the contents of the code block
	*/
	function parseEBlock(expr:Expr, exprs:Array<Expr>)
	{
		if(exprs.length == 0) return;

		if(expr != functionStack[functionStack.length-1].expr) return;//only care about the main block in a function
		
		var pos:Position = exprs[0].pos;

		var entryLogExpr = logEntry(pos, functionStack.length > 1);
		exprs.unshift(entryLogExpr);

		var lastExpr = exprs[exprs.length-1];

		switch(lastExpr.expr)
		{
			case EReturn(e): null;
			case EThrow(e): null;
			default:
			{
				//default exit log
				var exitLogExpr = logExit(lastExpr.pos);
				exprs.push(exitLogExpr);
			}
		}

		expr.expr = EBlock(exprs);
	}

	/**
	Returns a variable containing the value returned from a call to the
	logEntry method.

	i.e.:

		var ___logEntry:Int = MLogger.getLogger().logEntry();

	@param pos 					the position to generate at
	@param isInlineFunction 	flag indicating if current code block is an inline function (EFunction)
	@return call to logEntry along with local var to store returned value
	*/
	function logEntry(pos:Position, isInlineFunction:Bool=false):Expr
	{
		var args:Array<Expr> =
		[{
			expr:EConst(CIdent(isInlineFunction ? "true" : "false")),
			pos:pos		
		}];

		var logCall = createLogExpr(pos, "logEntry", args);

		var logVar = {
				type:TPath({sub:null, name:"Int", pack:[], params:[]}),
				name: "___logEntry",
				expr:logCall
		}

		var expr =  {
			expr:EVars([logVar]),
			pos:pos
		}

		return expr;
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

	@param expr 		the original throw expression
	@param e 			the expression being returned (or null)
	*/
	function parseEReturn(expr:Expr, e:Expr)
	{
		wrapExitExpr(expr, e);
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

	@param expr 		the original throw expression
	@param e 			the expression being thrown
	*/
	function parseEThrow(expr:Expr, e:Expr)
	{
		wrapExitExpr(expr, e);
	}


	/**
	Wraps a EReturn or EThrow with an exit log.
	Evaluates returned/thrown value prior to logging (and returning/throwing)

	Checks the parent expression and appends new values if already a code block (EBlock), otherwise
	replaces throw/return with a code block 

	@param expr 		the original throw expression
	@param e 			the expression being thrown
	*/
	function wrapExitExpr(expr:Expr, e:Expr)
	{
		var exitExprs = createExitExprs(expr, e);	
		var parentExpr = exprStack[exprStack.length-2];

		switch(parentExpr.expr)
		{
			case EBlock(exprs):
			{
				for(i in 0...exprs.length)
				{
					if(exprs[i] == expr)
					{
						exprs.insert(i, exitExprs.eExitLogCall);
						if(exitExprs.eVars != null)
						{
							exprs.insert(i, exitExprs.eVars);
						}
						break;
					}
				}	
				switch(expr.expr)
				{
					case EReturn(e1): expr.expr = EReturn(exitExprs.eReturnValue);
					case EThrow(e1): expr.expr = EThrow(exitExprs.eReturnValue);
					default: throw new LogException("Unexpected exprDef " + expr);
				}

			}
			default:
			{
				var eExit:Expr;
				switch(expr.expr)
				{
					case EReturn(e1): eExit = {expr:EReturn(exitExprs.eReturnValue), pos:expr.pos};
					case EThrow(e1): eExit = {expr:EThrow(exitExprs.eReturnValue), pos:expr.pos};
					default: throw new LogException("Unexpected exprDef " + expr);
				}
				var exprs:Array<Expr> = [exitExprs.eExitLogCall, eExit];
				if(exitExprs.eVars != null) exprs.unshift(exitExprs.eVars);
				expr.expr = EBlock(exprs);
			}
		}
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

		if(e != null)
		{
			macrotools.Print.make(e);
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
			eReturnValue:eReturnValue
		};
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
		var entryId = {
			expr:EConst(CIdent("___logEntry")),
			pos:pos
		}
		return createLogExpr(pos, "logExit", [entryId]);
	}

	/**
	Returns a call to the specified log method.
	Either
		MLog.getLogger().logEntry();
	Or
		MLog.getLogger().logExit(___logEntry);

	@param pos - the position to add to
	@param method - a method in the logger (either "logEntry" or "logExit")
	@param args - optional arguments (used to pass through entry id to logExit)
	@return a ECall expression to one of the methods listed above
	*/
	function createLogExpr(pos:Position, method:String, ?args:Array<Expr>):Expr
	{
		var loggerExpr = getReferenceToLogger(pos);
		
		var eField = EField(loggerExpr, method);
		pos = incrementPos(pos, method.length + 1);
		
		var fieldExpr = {
			expr:eField,
			pos:pos
		};

		if(args == null) args = [];
		
		var expr = {
			expr:ECall(fieldExpr, args),
			pos:pos
		};
		return expr;
	}

	/**
	Creates a call to m.cover.MLogger.getLogger();

	@param pos - the position to add to
	@return expr matching "m.cover.MLogger.getLogger()"
	*/
	function getReferenceToLogger(pos:Position):Expr
	{
		var cIdent = EConst(CIdent("m"));
		pos = incrementPos(pos, 7);
		var identExpr = {expr:cIdent, pos:pos};

		var eIdentField = EField(identExpr, "cover");
		pos = incrementPos(pos, 7);
		var identFieldExpr = {expr:eIdentField, pos:pos};

		var eType = EType(identFieldExpr, "MLogger");
		pos = incrementPos(pos, 5);
		var typeExpr = {expr:eType, pos:pos};

		var eField = EField(typeExpr, "getLogger");
		pos = incrementPos(pos, 9);
		var fieldExpr = {expr:eField, pos:pos};

		pos = incrementPos(pos, 2);
		return {expr:ECall(fieldExpr, []), pos:pos};
	}	
}

typedef ExitExprs = 
{
	eVars:Expr,
	eExitLogCall:Expr,
	eReturnValue:Expr
}
#end