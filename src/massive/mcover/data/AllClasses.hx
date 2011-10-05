package massive.mcover.data;

import massive.mcover.data.CoverageResult;
@:keep class AllClasses extends AbstractNodeList
{
	var statements:IntHash<Array<Int>>;
	var branches:IntHash<Array<Int>>;
	
	public function new()
	{
		super();
		statements = new IntHash();
		branches = new IntHash();		
	}

	public function addStatement(block:Statement)
	{
		if(statements.exists(block.id)) throw "Statement already exists" + block.id + " " + block.toString();
		
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
		if(branches.exists(block.id)) throw "Branch already exists" + block.id + " " + block.toString();
		
		var packg = cast(getItemByName(block.packageName, Package), Package);
		var file = cast(packg.getItemByName(block.file, File), File);
		var clazz = cast(file.getItemByName(block.qualifiedClassName, Clazz), Clazz);
		var method = cast(clazz.getItemByName(block.methodName, Method), Method);

		method.addBranch(block);

		block.lookup = [packg.id, file.id, clazz.id,method.id,block.id];
		branches.set(block.id, block.lookup.concat([]));
	}

	public function getBranchById(id:Int):Branch
	{
		if(!branches.exists(id)) throw "Unexpected branch " + id;

		var lookup:Array<Int> = branches.get(id).concat([]);
		return lookupBranch(lookup);
	}


	public function getStatementById(id:Int):Statement
	{
		if(!statements.exists(id)) throw "Unexpected statement " + id;
		var lookup:Array<Int> = statements.get(id).concat([]);
		return lookupStatement(lookup);
	}

	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(statements);
        s.serialize(branches);
    }
    
    override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        statements = s.unserialize();
        branches = s.unserialize();
    }

    override public function getMissingBranches():Array<Branch>
	{
		var a = super.getMissingBranches();
		a.sort(sortOnNodeId);
		return a;
	}

	override public function getMissingStatements():Array<Statement>
	{
		var a = super.getMissingStatements();
		a.sort(sortOnNodeId);
		return a;
	}

	override public function getClasses():Array<Clazz>
	{
		var a = super.getClasses();
		a.sort(sortOnClazzId);
		return a;
	}

	public function getPackages():Array<Package>
	{
		var a:Array<Package> = [];
		for(item in itemsById)
		{
			a.push(cast(item, Package));
		}
		a.sort(sortOnPackageId);

		return a;
	}

	function sortOnNodeId(a:AbstractNode, b:AbstractNode)
	{
		return a.id-b.id;
	}

	function sortOnClazzId(a:Clazz, b:Clazz)
	{
		return a.id-b.id;
	}

	function sortOnPackageId(a:Package, b:Package)
	{
		return a.id-b.id;
	}

	override function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to = super.appendResults(to, from);
		to.pc += (from.sc > 0) ? 1 : 0; 
		to.p += 1;	
		return to;
	}
}