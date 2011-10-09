package massive.mcover.data;

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
	
	static public function createBranch():Branch
	{
		var branch = createBlock(Branch);
		branch.name = "branch";
		return cast(branch, Branch);
	}

	static public function createStatement():Statement
	{
		var statement = createBlock(Statement);
		statement.name = "statement";
		return cast(statement, Statement);
	}
	static function createBlock(cls:Class<AbstractBlock>):AbstractBlock
	{
		var block = Type.createInstance(cls, []);
		block.id = 0;
		block.name = "block";
		block.packageName = "p";
		block.file = "f";
		block.qualifiedClassName = "c";
		block.methodName = "m";

		return block;
	}

}