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

package mcover.coverage.macro;

#if haxe3
import haxe.ds.StringMap;
import haxe.ds.IntMap;
#else
private typedef StringMap<T> = Hash<T>
private typedef IntMap<T> = IntHash<T>
#end

#if macro
import haxe.macro.Context;
import mcover.MCover;
import mcover.macro.ClassPathFilter;
import mcover.macro.MacroDelegate;
import mcover.coverage.data.Coverage;
import mcover.macro.ExpressionParser;
import mcover.coverage.macro.CoverageExpressionParser;


/**
@see mcover.MacroDelegateImpl
@see mcover.MacroDelegate
*/
class CoverageMacroDelegate extends MacroDelegateImpl
{
	/**
	Used by CoverageExpressionParser to store generated coverage data classes that will be compiled into application.
	*/
	static public var coverage = new Coverage();
	
	/**
	Used by CoverageExpressionParser to lookup valid class paths
	*/
	static public var classPathMap:IntMap<String> = new IntMap();


	public function new()
	{
		super();
		id = "coverage";
		filter.ignoreClassMeta = "IgnoreCover,:IgnoreCover,:ignore";
	}

	/**
	Filters classes that dont have @IgnoreCover class metadata

	@see mcover.MacroDelegate
	*/
	override public function filterClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):StringMap<Bool>
	{
		
		for(cp in classPaths)
		{
			classPathMap.set(Lambda.count(classPathMap), cp);
		}

		return super.filterClasses(packages, classPaths, exclusions);
	}

	/**
	@see mcover.MacroDelegate
	*/
	override public function getExpressionParser():Class<ExpressionParser>
	{
		return CoverageExpressionParser;
	}

	/**
	Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	This resource is used by MCoverRunner to determine code coverage results

	@see mcover.MacroDelegate
	*/
	override public function generate(types:Array<haxe.macro.Type>):Void
	{
		var serializedData = haxe.Serializer.run(CoverageMacroDelegate.coverage);
       	Context.addResource(MCoverage.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));
	}
}

#end