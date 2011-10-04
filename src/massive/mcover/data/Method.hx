package massive.mcover.data;
import massive.mcover.data.CoverageResult;
@:keep class Method extends AbstractNode
{
	public var statementsById:IntHash<Statement>;
	public var branchesById:IntHash<Branch>;

	public function new()
	{
		super();

		statementsById = new IntHash();
		branchesById = new IntHash();
	}

	public function addStatement(value:Statement)
	{
		statementsById.set(value.id, value);
	}

	public function addBranch(value:Branch)
	{
		branchesById.set(value.id, value);
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
			for(statement in statementsById)
			{
				resultCache.sc += (statement.count > 0) ? 1 : 0;
				resultCache.s += 1;
			}
			for(branch in branchesById)
			{
				resultCache.bt += (branch.trueCount > 0) ? 1 : 0;
				resultCache.bf += (branch.falseCount > 0) ? 1 : 0;
				resultCache.bc += branch.isCovered() ? 1 : 0;
				resultCache.b += 1;
			}
		}
		return resultCache;
	}
	

	///////////

	function hxSerialize( s : haxe.Serializer )
	{
		s.serialize(id);
        s.serialize(name);
        s.serialize(statementsById);
        s.serialize(branchesById);
    }
    
    function hxUnserialize( s : haxe.Unserializer )
    {
    	id = s.unserialize();
        name = s.unserialize();
        statementsById = s.unserialize();
        branchesById = s.unserialize();
    }
}