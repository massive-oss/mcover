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

	override public function getResults(?cache:Bool):CoverageResult
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

	public static function createClass():Clazz
	{
		var cls = new Clazz();
		cls.id = 0;
		cls.name = "clazz";
		return cls;
	}
	
	public static function createBranch():Branch
	{
		var branch = new Branch();
		branch.id = 0;
		branch.name = "branch";
		return branch;
	}

	public static function createStatement():Statement
	{
		var statement = new Statement();
		statement.id = 0;
		statement.name = "statement";
		return statement;
	}

}