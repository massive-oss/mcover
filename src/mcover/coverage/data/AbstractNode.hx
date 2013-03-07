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
@:keep
class AbstractNode
{
	public var id:Null<Int>;
	public var name:String;

	var resultCache:CoverageResult;

	@IgnoreCover
	function new()
	{

	}

	@IgnoreLogging
	public function getResults(?cache:Bool=true):CoverageResult
	{
		if(resultCache == null || !cache)
		{
			resultCache = emptyResult();
		}

		return resultCache;
	}
	
	@IgnoreLogging
	public function getPercentage():Float
	{
		var r = getResults();
		try
		{
			var count = r.bt + r.bf + r.sc + r.mc;
			var total = 2*r.b + r.s + r.m;

			if(count == 0 || total == 0) return 0;

			return Math.round((count/total)*10000)/100;
		}
		catch(e:Dynamic){}
		return 0;
	}
	
	public function getClasses():Array<Clazz>
	{
		return [];
	}

	public function lookupBranch(path:Array<Int>):Branch
	{
		return null;
	}

	public function lookupStatement(path:Array<Int>):Statement
	{
		return null;
	}

	
	public function getMissingBranches():Array<Branch>
	{
		return [];
	}

	public function getMissingStatements():Array<Statement>
	{
		return [];
	}

	//////////////
	
	@IgnoreLogging
	function emptyResult():CoverageResult
	{
		return {lc:0, lp:0, l:0, sc:0, s:0, bt:0, bf:0,bc:0,b:0, mc:0, m:0, cc:0, c:0, fc:0, f:0, pc:0, p:0};
	}

	@IgnoreLogging
	function hxSerialize( s : haxe.Serializer )
	{
		s.serialize(id);
        s.serialize(name);
    }
    
    @IgnoreLogging
	function hxUnserialize( s : haxe.Unserializer )
    {
    	id = s.unserialize();
        name = s.unserialize();
    }
}