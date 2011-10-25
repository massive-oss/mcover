package massive.mcover.data;
import massive.mcover.data.Branch;

class NodeMock extends AbstractNode
{
	public var clazz:Clazz;
	public var branch:Branch;
	public var statement:Statement;
	public var results:CoverageResult;

	public function new()
	{
		super();
		id = 0;
		name = "nodeMock";

		clazz = createClass();
		branch = createBranch();
		statement = createStatement();
		results = emptyResult();
	}

	override public function getResults(?cache:Bool=true):CoverageResult
	{
		return results;
	}

	override public function getClasses():Array<Clazz>
	{
		return [clazz];
	}

	override public function lookupBranch(path:Array<Int>):Branch
	{
		return branch;
	}
	override public function lookupStatement(path:Array<Int>):Statement
	{
		return statement;
	}
	override public function getMissingBranches():Array<Branch>
	{
		return [branch];
	}
	override public function getMissingStatements():Array<Statement>
	{
		return [statement];
	}

	///////////////////

	static public function createClass():Clazz
	{
		var cls = new Clazz();
		cls.id = 0;
		cls.name = "clazz";
		return cls;
	}
	
	static public function createBranch(?id:Int=0):Branch
	{
		var branch = createBlock(Branch, id);
		branch.name = "branch";
		return cast(branch, Branch);
	}

	static public function createStatement(?id:Int=0):Statement
	{
		var statement = createBlock(Statement, id);
		statement.name = "statement";
		return cast(statement, Statement);
	}
	static function createBlock(cls:Class<AbstractBlock>, ?id:Int=0):AbstractBlock
	{
		var block = Type.createInstance(cls, []);
		block.id = id;
		block.name = "block";
		block.packageName = "package";
		block.file = "file";
		block.qualifiedClassName = "package.class";
		block.methodName = "method";
		block.location = "location";
		return block;
	}

	static public function createBranchResult(?branch:Branch):BranchResult
	{
		if(branch == null) branch = createBranch();
		
		return {id:branch.id,trueCount:branch.trueCount, falseCount:branch.falseCount, total:branch.totalCount};
	}

}