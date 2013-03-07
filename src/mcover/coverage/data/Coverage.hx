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
import mcover.coverage.data.Branch;

@IgnoreLogging
@:keep class Coverage extends AbstractNodeList
{
	var statements:IntMap<Array<Int>>;
	var branches:IntMap<Array<Int>>;

	/*
	 * total execution count for statements by id
	*/
	public var statementResultsById(default, null):IntMap<Int>;
	
	/*
	 * total execution summary for branches by id
	*/
	public var branchResultsById(default, null):IntMap<BranchResult>;

	public function new()
	{
		super();
		statements = new IntMap();
		branches = new IntMap();		
		statementResultsById = new IntMap();
		branchResultsById = new IntMap();
	}

	public function setStatementResultsMap(map:IntMap<Int>)
	{
		statementResultsById = map;
	}

	public function setBranchResultsMap(map:IntMap<BranchResult>)
	{
		branchResultsById = map;
	}

	public function addStatement(block:Statement)
	{
		verifyBlockData(block);
		if(statements.exists(block.id)) throw new Exception("Statement already exists: " + block.id + " " + block.toString());
		
		var packg = cast(getItemByName(block.packageName, Package), Package);
		var file = cast(packg.getItemByName(block.file, File), File);
		var clazz = cast(file.getItemByName(block.qualifiedClassName, Clazz), Clazz);
		var method = cast(clazz.getItemByName(block.methodName, Method), Method);

		method.addStatement(block);

		block.lookup = [packg.id, file.id, clazz.id,method.id,block.id];
		statements.set(block.id, block.lookup.concat([]));
	}

	public function addBranch(block:Branch)
	{
		verifyBlockData(block);
		if(branches.exists(block.id)) throw new Exception("Branch already exists: " + block.id + " " + block.toString());
		
		var packg = cast(getItemByName(block.packageName, Package), Package);
		var file = cast(packg.getItemByName(block.file, File), File);
		var clazz = cast(file.getItemByName(block.qualifiedClassName, Clazz), Clazz);
		var method = cast(clazz.getItemByName(block.methodName, Method), Method);

		method.addBranch(block);

		block.lookup = [packg.id, file.id, clazz.id,method.id,block.id];
		branches.set(block.id, block.lookup.concat([]));
	}

	function verifyBlockData(block:AbstractBlock)
	{
		if(block.id == null) throw new Exception("id cannot be null");
		if(block.packageName == null) throw new Exception("packageName cannot be null");
		if(block.file == null) throw new Exception("file cannot be null");
		if(block.qualifiedClassName == null) throw new Exception("qualifiedClassName cannot be null");
		if(block.methodName == null) throw new Exception("methodName cannot be null");
	}

	public function getBranchById(id:Int):Branch
	{
		if(!branches.exists(id)) throw new Exception("Branch does not exist: " + id);

		var lookup:Array<Int> = branches.get(id).concat([]);
		return lookupBranch(lookup);
	}


	public function getStatementById(id:Int):Statement
	{
		if(!statements.exists(id)) throw new Exception("Statement does not exist: " + id);
		var lookup:Array<Int> = statements.get(id).concat([]);
		return lookupStatement(lookup);
	}



    override public function getMissingBranches():Array<Branch>
	{
		var a = super.getMissingBranches();
		a.sort(DataUtil.sortOnBlockName);
		return a;
	}

	override public function getMissingStatements():Array<Statement>
	{
		var a = super.getMissingStatements();
		a.sort(DataUtil.sortOnBlockName);
		return a;
	}

	override public function getClasses():Array<Clazz>
	{
		var a = super.getClasses();
		a.sort(DataUtil.sortOnNodeName);
		return a;
	}

	public function getClassByName(name:String):Clazz
	{
		var index = name.lastIndexOf(".");

		var packageName = index > 1 ? name.substr(0, index) : "";

		if(!items.exists(packageName)) return null;

		var pckgId = items.get(packageName);
		
		var pckg = cast(itemsById.get(pckgId), Package);
		
		var classes = pckg.getClasses();

		for(cls in classes)
		{
			if(cls.name == name)
			{
				return cls;
			}
		}

		return null;	
	}

	public function getPackages():Array<Package>
	{
		var a:Array<Package> = [];
		for(item in itemsById)
		{
			a.push(cast(item, Package));
		}
		a.sort(DataUtil.sortOnNodeName);

		return a;
	}

	@IgnoreLogging
	override public function getResults(?cache:Bool=true):CoverageResult
	{
		if(resultCache == null || !cache)
		{
			for(lookup in statements)
			{
				var statement = lookupStatement(lookup.concat([]));
				if(statementResultsById.exists(statement.id))
				{
					statement.count = statementResultsById.get(statement.id);
				}
				else
				{
					statement.count = 0;
				}
			}
			for(lookup in branches)
			{
				var branch = lookupBranch(lookup.concat([]));
				if(branchResultsById.exists(branch.id))
				{
					var result = branchResultsById.get(branch.id);
					branch.trueCount = result.trueCount;
					branch.falseCount = result.falseCount;
				}
				else
				{
					branch.trueCount = 0;
					branch.falseCount = 0;
				}
			}
			super.getResults(cache);
		}
		return resultCache;
	}

	override function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to = super.appendResults(to, from);
		to.pc += (from.sc > 0) ? 1 : 0; 
		to.p += 1;	
		return to;
	}

	///////////////

	@IgnoreLogging
	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(statements);
        s.serialize(branches);
        s.serialize(statementResultsById);
     	s.serialize(branchResultsById);      
    }
    
    @IgnoreLogging
	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        statements = s.unserialize();
        branches = s.unserialize();
       	statementResultsById = s.unserialize();
        branchResultsById = s.unserialize();
    }
}