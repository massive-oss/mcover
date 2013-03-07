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
import haxe.ds.IntMap;
#else
private typedef IntMap<T> = IntHash<T>
#end

import mcover.coverage.data.CoverageResult;
import mcover.coverage.data.Statement;
import mcover.coverage.data.Branch;

@IgnoreLogging
@:keep class Method extends AbstractNode
{
	var statementsById:IntMap<Statement>;
	var branchesById:IntMap<Branch>;

	public function new()
	{
		super();

		statementsById = new IntMap();
		branchesById = new IntMap();
	}

	public function addStatement(value:Statement)
	{
		statementsById.set(value.id, value);
	}

	public function addBranch(value:Branch)
	{
		branchesById.set(value.id, value);
	}

	public function getStatementById(id:Int):Statement
	{
		if(statementsById.exists(id)) return statementsById.get(id);
		return null;
	}

	public function getBranchById(id:Int):Branch
	{
		if(branchesById.exists(id)) return branchesById.get(id);
		return null;
	}

	override public function lookupBranch(path:Array<Int>):Branch
	{
		var itemId = path.shift();
		if(itemId == null || !branchesById.exists(itemId)) return null;
		return branchesById.get(itemId);
	}

	override  public function lookupStatement(path:Array<Int>):Statement
	{
		var itemId = path.shift();
		if(itemId == null || !statementsById.exists(itemId)) return null;
		return statementsById.get(itemId);
	}

	override public function getMissingBranches():Array<Branch>
	{
		var a:Array<Branch> = [];
		for(branch in branchesById)
		{
			if(!branch.isCovered()) a.push(branch);
		}
		return a;
	}

	override public function getMissingStatements():Array<Statement>
	{
		var a:Array<Statement> = [];
		for(statement in statementsById)
		{
			if(!statement.isCovered()) a.push(statement);
		}
		return a;
	}

	override public function getResults(?cache:Bool=true):CoverageResult
	{
		if(resultCache == null || !cache)
		{
			resultCache = emptyResult();

			var covered:Bool;

			for(statement in statementsById)
			{
				covered = (statement.count > 0);
				resultCache.sc += covered ? 1 : 0;
				resultCache.s += 1;

				for(line in statement.lines)
				{
					resultCache.lc += covered ? 1: 0;
					resultCache.l += 1;
				}
			}
			for(branch in branchesById)
			{
				covered = branch.isCovered();
				resultCache.bt += (branch.trueCount > 0) ? 1 : 0;
				resultCache.bf += (branch.falseCount > 0) ? 1 : 0;
				resultCache.bc += covered ? 1 : 0;
				resultCache.b += 1;

				var partiallyCovered = branch.isPartiallyCovered();

				for(line in branch.lines)
				{
					if(covered)
					{
						resultCache.lc += 1;
					}
					else if(partiallyCovered)
					{
						resultCache.lp += 1;
					}
					resultCache.l += 1;
				}
			}
		}
		return resultCache;
	}

	///////////
	@IgnoreLogging
	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(statementsById);
        s.serialize(branchesById);
    }
	
	@IgnoreLogging
   	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        statementsById = s.unserialize();
        branchesById = s.unserialize();
    }
}