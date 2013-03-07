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

class ClassInfo
{
	public var fileName:String;
	public var className:String;
	public var packageName:String;
	public var methodName:String;
	public var location(get_location, null):String;
	public function new()
	{
	}
	
	public function toString()
	{
		if(className != null)
		{
			return fileName + ":" + location;
		}
		else
		{
			return fileName;
		}
	}

	/**
	* Expectes a file path within the corresponding classPath
	* @param file 	path to file
	* @param cp 		classpath path
	*/
	public static function fromFile(file:String, cp:String):ClassInfo
	{
		var slash:String = "/";
		if(cp.indexOf("\\") > cp.indexOf("/"))
		{
			slash = "\\";
		}

		if(cp.charAt(cp.length-1) != slash) cp += slash;
	
	
		var info = new ClassInfo();
		info.fileName = file;

		var path = file.split(cp).pop();

		path = path.substr(0, -3);//remove .hx

		var parts = path.split(slash);

		info.className = parts.pop();
		info.packageName = parts.join(".");

		return info;
	}

	public function clone():ClassInfo
	{
		var info = new ClassInfo();
		info.fileName = fileName;
		info.className = className;
		info.packageName = packageName;
		info.methodName = methodName;

		return info;	
	}

	function get_location()
	{
		var str = "";

		if(className != null)
		{
			if(packageName != null && packageName != "")
				str += packageName + ".";

			str += className;

			if(methodName != null)
				str += "." + methodName;
		}
		
		if(str == "") return null;

		return str;
	}



}
