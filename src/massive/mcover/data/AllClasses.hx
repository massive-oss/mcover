package massive.mcover.data;

import massive.mcover.data.CoverageResult;
@:keep class AllClasses extends AbstractNodeList
{
	public var statements:IntHash<Array<Int>>;
	public var branches:IntHash<Array<Int>>;
	
	public function new()
	{
		super();
		statements = new IntHash();
		branches = new IntHash();
			
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