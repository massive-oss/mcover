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

package mcover.coverage.data;

/**
* Reprents a unique code block {} within an application
* Contains a number of properties relating to it's location and context.
*/
@IgnoreLogging
@:keep class AbstractBlock extends AbstractNode
{
	public var file:String;
	
	public var packageName:String;
	public var className:String;
	public var qualifiedClassName:String;
	public var methodName:String;

	public var min:Int;
	public var max:Int;

	public var location:String;
	public var lines:Array<Int>;

	public var lookup:Array<Int>;

	function new()
	{
		super();
		lines = [];
	}

	public function isCovered():Bool
	{
		return false;
	}

	public function toString():String
	{
		return qualifiedClassName + "#" + toLocalString();
	}

	public function toLocalString():String
	{
		return methodName + " | " + location;
	}

	@IgnoreLogging
	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(file);
        s.serialize(packageName);
        s.serialize(className);
        s.serialize(qualifiedClassName);
        s.serialize(methodName);
        s.serialize(min);
        s.serialize(max);
        s.serialize(location);
        s.serialize(lookup);
        s.serialize(lines);
    } 
    
    @IgnoreLogging
	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        file = s.unserialize();
        packageName = s.unserialize();
        className = s.unserialize();
        qualifiedClassName = s.unserialize();
        methodName = s.unserialize();
        min = s.unserialize();
        max = s.unserialize();
        location = s.unserialize();
        lookup = s.unserialize();
        lines = s.unserialize();
    }

}