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

package m.cover.coverage.client;

#if haxe208
	#if neko
	import neko.Lib;
	#elseif cpp
	import cpp.Lib;
	#elseif php
	import php.Lib;
	#end
#end

@IgnoreLogging
class TraceClient extends PrintClient
{
	public function new()
	{
		super();
		newline = #if js "<br/>" #else "\n" #end;
		tab = #if js "&nbsp;" #else " " #end;
	}

	override function printReport()
	{
		super.printReport();
		output += newline;

		trace(newline + output);
		/*

		#if js
		var textArea = js.Lib.document.getElementById("haxe:trace");
		if (textArea == null) 
		{	
			var error:String = "MissingElementException: 'haxe:trace' element not found in html file";
			js.Lib.alert(error);
			return;
		}
	
		textArea.innerHTML += output;
		js.Lib.window.scrollTo(0,js.Lib.document.body.scrollHeight);
			
		#if (neko || cpp || php)
			#if haxe_208 
				Lib.print(output);
			#else
				Sys.print(output);
			#end
		#else
			trace(newline + output);
		#end
		*/
	}
}