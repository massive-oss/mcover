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

#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<T> = Hash<T>
#end

#if macro
interface MacroDelegate
{
	var id(default, null):String;

	/**
	Populates includedClasses and excludedClases based on the provided classpaths and packages. This is called during the compiler macro

	@param packages 	array of package names (defaults to [""])
	@param classpaths 	array of class paths (defaults to [""])
	@param exclusions 	array of excluded classes or wildcard patterns (defaults to [])
	@return Map of class keys with boolean value to indicate include or exclude
	*/
	function filterClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):StringMap<Bool>;

	/**
	@return the type of class to use on class @:build parsing
	*/
	function getExpressionParser():Class<ExpressionParser>;
	

	/**
	Called during Context.onGenerate(). Provides opportunity for any post compilation processing;
	*/
	function generate(types:Array<haxe.macro.Type>):Void;
}

/**
@see mcover.MacroDelegate
*/
class MacroDelegateImpl implements MacroDelegate
{
	public var id(default, null):String;

	var filter:ClassPathFilter;

	public function new()
	{
		filter = new ClassPathFilter();
	}

	public function getExpressionParser():Class<ExpressionParser>
	{
		throw new mcover.Exception("Abstract method.");
		return null;
	}

	public function filterClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):StringMap<Bool>
	{
		if(packages ==  null || packages.length == 0) packages = [""];

		return filter.filter(classPaths, packages, exclusions);
		
	}

	public function generate(types:Array<haxe.macro.Type>):Void
	{
		//empty
	}


}
#end