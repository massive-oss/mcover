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
@IgnoreLogging
@:keep class Branch extends AbstractBlock
{
	public var trueCount:Int;
	public var falseCount:Int;

	public var totalCount(get_totalCount, null):Int;

	public function new()
	{
		super();
		trueCount = 0;
		falseCount = 0;
	}

	function get_totalCount():Int
	{
		return trueCount + falseCount;
	}

	override public function isCovered():Bool
	{
		return trueCount > 0 && falseCount > 0;
	}

	public function isPartiallyCovered():Bool
	{
		return !isCovered() && (trueCount > 0 || falseCount > 0);
	}

	override public function toLocalString():String
	{
		var s = super.toLocalString();
		if(!isCovered())
		{
			s += " | ";
			if(trueCount == 0) s += "t";
			if(trueCount == 0 && falseCount == 0) s +=",";
			if(falseCount == 0) s += "f";
		
		}
		return s;
	}

	///////////
	@IgnoreLogging
	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(trueCount);
        s.serialize(falseCount);
    }
    
    @IgnoreLogging
	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        trueCount = s.unserialize();
        falseCount = s.unserialize();
    }
}

typedef BranchResult =
{
	id:Int,
	trueCount:Int,
	falseCount:Int,
	total:Int, //total true and false counts;
}
