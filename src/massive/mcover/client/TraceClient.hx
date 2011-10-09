package massive.mcover.client;

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

		#elseif neko
			neko.Lib.print(output);
		#elseif cpp
			cpp.Lib.print(output);
		#elseif php
			php.Lib.print(output);
		#else
			trace(newline + output);
		#end
		*/
	}
}