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

#if haxe3
import haxe.ds.StringMap;
import haxe.ds.IntMap;
#else
private typedef StringMap<T> = Hash<T>
private typedef IntMap<T> = IntHash<T>
#end

import mcover.coverage.data.AbstractNode;
import mcover.coverage.data.CoverageResult;

@IgnoreLogging
@:keep class AbstractNodeList extends AbstractNode
{
	var itemsById:IntMap<AbstractNode>;
	var items:StringMap<Int>;
	public var itemCount(default, null):Int;

	public function new()
	{
		super();
		itemCount = 0;
		itemsById = new IntMap();
		items = new StringMap();
	}

	public function getItemByName(name:String, cls:Class<AbstractNode>):AbstractNode
	{
		if(!items.exists(name))
		{
			var item:AbstractNode = Type.createInstance(cls, []);
			item.id = itemCount ++;
			item.name = name;
			items.set(name, item.id);
			itemsById.set(item.id, item);
		}
		return itemsById.get(items.get(name));
	}

	override public function lookupBranch(path:Array<Int>):Branch
	{
		var itemId = path.shift();
		if(itemId == null || !itemsById.exists(itemId)) return null;
		return itemsById.get(itemId).lookupBranch(path);
	}

	override public function lookupStatement(path:Array<Int>):Statement
	{
		var itemId = path.shift();
		if(itemId == null|| !itemsById.exists(itemId)) return null;
		return itemsById.get(itemId).lookupStatement(path);
	}


	override public function getMissingBranches():Array<Branch>
	{
		var a:Array<Branch> = [];
		for(node in itemsById)
		{
			var tmp = node.getMissingBranches();
			a = a.concat(tmp);
		}
		a.sort(DataUtil.sortOnBlockName);
		return a;
	}

	override public function getMissingStatements():Array<Statement>
	{
		var a:Array<Statement> = [];
		for(node in itemsById)
		{
			var tmp = node.getMissingStatements();
			a = a.concat(tmp);
		}

		a.sort(DataUtil.sortOnBlockName);
		return a;
	}

	override public function getClasses():Array<Clazz>
	{
		var a:Array<Clazz> = [];
		for(node in itemsById)
		{
			var tmp = node.getClasses();
			a = a.concat(tmp);
		}
		return a;
	}

	@IgnoreLogging
	override public function getResults(?cache:Bool=true):CoverageResult
	{
		if(resultCache == null || !cache)
		{
			resultCache = emptyResult();
			for(node in itemsById)
			{
				var tmp = node.getResults(cache);
				resultCache = appendResults(resultCache, tmp);
			}
		}

		return resultCache;
	}



	function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to.sc += from.sc;
		to.s += from.s;
		to.bt += from.bt;
		to.bf += from.bf;
		to.bc += from.bc;
		to.b += from.b;
		to.mc += from.mc;
		to.m += from.m;
		to.cc += from.cc;
		to.c += from.c;	
		to.fc += from.fc;
		to.f += from.f;	
		to.pc += from.pc;
		to.p += from.p;	

		to.lc += from.lc;
		to.lp += from.lp;
		to.l += from.l;

		return to;
	}
	
	@IgnoreLogging
	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(itemsById);
        s.serialize(items);
        s.serialize(itemCount);
    }
    
    @IgnoreLogging
	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        itemsById = s.unserialize();
        items = s.unserialize();
        itemCount = s.unserialize();
    }


}
