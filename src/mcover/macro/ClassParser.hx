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

using haxe.macro.Tools;

/**
Generic recursive parser of expressions inside a class's fields.
Provides mechanism for adding one or more ExpressionParser instances to take reponsibility for modifying field contents.

For each ExpressionParser
- checks if current field should be included/ignored

*/
interface ClassParser
{
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
			case TInst(t, _):
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
		parsers.push(parser);
	}

	/**
	 * loops through all class fields and interogates contents recursively
	 */
	public function parseFields():Array<Field>
	{
		if(parsers.length == 0) return null;

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

	function parseMethod(field:Field, func:Function)
	{
		info.methodName = field.name;

		if(func.expr == null ) return;

		for(parser in fieldParsers)
		{
			parser.parseMethod(func, info);

		}
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