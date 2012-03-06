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

package m.cover.coverage.macro;

#if macro
import haxe.macro.Context;
import m.cover.MCover;
import m.cover.macro.ClassPathFilter;
import m.cover.macro.MacroDelegate;
import m.cover.coverage.data.Coverage;
import m.cover.macro.ExpressionParser;
import m.cover.coverage.macro.CoverageExpressionParser;


/**
@see m.cover.MacroDelegateImpl
@see m.cover.MacroDelegate
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
	static public var classPathHash:IntHash<String> = new IntHash();


	public function new()
	{
		super();
		id = "coverage";
		filter.ignoreClassMeta = "IgnoreCover";
	}

	/**
	Filters classes that dont have @IgnoreCover class metadata

	@see m.cover.MacroDelegate
	*/
	override public function filterClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):Hash<Bool>
	{
		
		for(cp in classPaths)
		{
			classPathHash.set(Lambda.count(classPathHash), cp);
		}

		return super.filterClasses(packages, classPaths, exclusions);
	}

	/**
	@see m.cover.MacroDelegate
	*/
	override public function getExpressionParser():Class<ExpressionParser>
	{
		return CoverageExpressionParser;
	}

	/**
	Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	This resource is used by MCoverRunner to determine code coverage results

	@see m.cover.MacroDelegate
	*/
	override public function generate(types:Array<haxe.macro.Type>):Void
	{
		var serializedData = haxe.Serializer.run(CoverageMacroDelegate.coverage);
       	Context.addResource(MCoverage.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));
	}
}

#end