package mcover.macro;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.macro.ClassInfo;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;

using StringTools;
#if macro
using haxe.macro.Tools;
#end

class CoverageMacroTest 
{
	
	public function new() 
	{	
	}
	

	// ------------------------------------------------------------------------- functions

	@Test
	public function should_cover_function()
	{
		var result = parseExpr(function(){f();});
		assertCovered(1, 0, result);
	}

	@Test
	public function should_wrap_function()
	{
		var result = parseExpr(function() f());
		assertCovered(1, 0, result);
	}

	// ------------------------------------------------------------------------- if statements


	@Test
	public function should_cover_if()
	{
		var result = parseExpr(if(true){f();});
		assertCovered(0, 1, result);
	}

	@Test
	public function should_cover_if_else()
	{
		var result = parseExpr(if(true){f();} else{f();} );
		assertCovered(1, 1, result);
	}

	@Test
	public function should_wrap_else_in_block()
	{
		var result = parseExpr(if(true){f();} else f() );
		assertCovered(1, 1, result);
	}

	@Test
	public function should_cover_if_elseif()
	{
		var result = parseExpr(if(true){f();} else if(false){f();} );
		assertCovered(0, 2, result);
	}

	@Test
	public function should_cover_if_elseif_else()
	{
		var result = parseExpr(if(true){f();} else if(false){f();} else{f();} );
		assertCovered(1, 2, result);
	}

	// ------------------------------------------------------------------------- while loops

	@Test
	public function should_cover_while()
	{
		var result = parseExpr(while(false){ f();});
		assertCovered(0, 1, result);
	}

	@Test
	public function should_cover_do_while()
	{
		var result = parseExpr(do { f(); } while(false));
		assertCovered(1, 1, result);
	}

	@Test
	public function should_wrap_do_while()
	{
		var result = parseExpr(do f() while(false));
		assertCovered(1, 1, result);
	}

	// ------------------------------------------------------------------------- ternary

	@Test
	public function should_cover_ternary()
	{
		var result = parseExpr(true ? true : false);
		assertCovered(0, 1, result);
	}

	// ------------------------------------------------------------------------- block

	@Test
	public function should_cover_block()
	{
		var result = parseExpr({f();f();});
		assertCovered(1, 0, result);
	}

	// ------------------------------------------------------------------------- binop

	@Test
	public function should_cover_binop_or()
	{
		var result = parseExpr( true || false );
		assertCovered(0, 2, result);
	}

	@Test
	public function should_cover_binop_and()
	{
		var result = parseExpr( true && false );
		assertCovered(0, 2, result);
	}

	// ------------------------------------------------------------------------- meta

	@Test
	public function should_cover_meta()
	{
		var result = parseExpr(@foo { f(); });
		assertCovered(1, 0, result);
	}

	@Test
	public function should_ignore_field_with_ignore_meta()
	{
		var result = parseExpr(@IgnoreCover { f(); });
		assertCovered(0, 0, result);

		var result = parseExpr(@:IgnoreCover { f(); });
		assertCovered(0, 0, result);

		var result = parseExpr(@:ignore { f(); });
		assertCovered(0, 0, result);
	}

	// ------------------------------------------------------------------------- internal


	function f():Bool
	{
		return true;
	}


	function assertCovered(expectedStatements:Int=0, expectedBranches:Int=0, expr:String, debug:Bool=false, ?pos:haxe.PosInfos)
	{
		var parts = expr.split("mcover.coverage.MCoverage.getLogger().logStatement");

		var actualStatements = parts.length -1;

		parts = parts.join("$s").split("mcover.coverage.MCoverage.getLogger().logBranch");
		
		var actualBranches = parts.length - 1;

		expr = parts.join("$b");

		if(debug)
			trace(expr, pos);

		Assert.areEqual(expectedStatements, actualStatements, pos);
		Assert.areEqual(expectedBranches, actualBranches, pos);
	}

	// ------------------------------------------------------------------------- 

	macro static function parseExpr(expr:Expr):Expr
	{
		trace("####");
		var info = createClassInfo();

		var classPaths:Map<String,Bool> = new Map();

		for(cp in Context.getClassPath())
		{
			classPaths.set(cp, true);
		}

		var instance = new CoverageMacro(info, classPaths);
		
		expr = instance.parseExpr(expr);

		var exprStr = expr.toString();
		return macro $v{exprStr};
	}

	// ------------------------------------------------------------------------- 



	#if macro

	static function createClassInfo()
	{
		var info = CoverageMacro.createClassInfo();
		info.fileName = Context.getPosInfos(Context.currentPos()).file;
		return info;
	}
	static function createField(?name:String="field")
	{
		var func = createFunction();
		var pos = Context.currentPos();

		var field:Field = {
			pos:pos,
			name:"field",
			meta:[],
			kind: FieldType.FFun(func),
			doc:null,
			access:[]
		};
		return field;
	}

	static function createMeta(name:String)
	{
		var meta = {
			pos:Context.currentPos(),
			params:[],
			name:name
		}
		return meta;
	}

	static function createFunction(?expr:Expr):Function
	{
		if(expr == null) expr = macro {};

		var func:Function= {
			ret:null,
			params:[],
			expr:expr,
			args:[]
		};
		return func;

	}
	#end

}

class ClassWithFunction
{
	public function test()
	{
		trace("test");
	}
}