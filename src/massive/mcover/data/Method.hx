package massive.mcover.data;
import massive.mcover.data.CoverageResult;
import massive.mcover.data.Statement;
import massive.mcover.data.Branch;

@:keep class Method extends AbstractNode
{
	var statementsById:IntHash<Statement>;
	var branchesById:IntHash<Branch>;

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

	override function hxSerialize( s : haxe.Serializer )
	{
		super.hxSerialize(s);
        s.serialize(statementsById);
        s.serialize(branchesById);
    }
    
   	override function hxUnserialize( s : haxe.Unserializer )
    {
    	super.hxUnserialize(s);
        statementsById = s.unserialize();
        branchesById = s.unserialize();
    }
}