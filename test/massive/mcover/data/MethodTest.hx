package massive.mcover.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class MethodTest extends AbstractNodeTest
{	
	var method:Method;

	public function new() {super();}
	
	@BeforeClass
	override public function beforeClass():Void
	{
		super.beforeClass();
	}
	
	@AfterClass
	override public function afterClass():Void
	{
		super.afterClass();
	}
	
	@Before
	override public function setup():Void
	{
		super.setup();
		method = createEmptyMethod();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}
	
	@Test
	public function shouldAddStatement()
	{
		var statement = new Statement();
		statement.id = 0;
		method.addStatement(statement);

		Assert.isNotNull(method.getStatementById(0));
		Assert.areEqual(statement, method.getStatementById(0));	

		Assert.isNull(method.getStatementById(1));
	}
	@Test
	public function shouldAddBranch()
	{
		var branch = new Branch();
		branch.id = 0;
		method.addBranch(branch);

		Assert.isNotNull(method.getBranchById(0));
		Assert.areEqual(branch, method.getBranchById(0));	

		Assert.isNull(method.getBranchById(1));
	}

	@Test
	public function shoudLookUpBranch()
	{
		var branch = new Branch();
		branch.id = 0;
		method.addBranch(branch);

		Assert.areEqual(branch, method.lookupBranch([0]));
		Assert.isNull(method.lookupBranch([1]));
	}

	@Test
	public function shoudLookUpStatement()
	{
		var statement = new Statement();
		statement.id = 0;
		method.addStatement(statement);

		Assert.areEqual(statement, method.lookupStatement([0]));
		Assert.isNull(method.lookupStatement([1]));
	}

	@Test
	public function shoudReturnMissingBranches()
	{
		var branch1 = new Branch();
		branch1.id = 0;
		method.addBranch(branch1);

		var branch2 = new Branch();
		branch2.id = 1;
		branch2.trueCount = 1;
		branch2.falseCount = 1;
		method.addBranch(branch2);

		var missing = method.getMissingBranches();

		Assert.areEqual(1, missing.length);
		Assert.areEqual(branch1, missing[0]);
	}

	@Test
	public function shoudReturnMissingStatements()
	{
		var statement1 = new Statement();
		statement1.id = 0;
		method.addStatement(statement1);

		var statement2 = new Statement();
		statement2.id = 1;
		statement2.count = 1;
		method.addStatement(statement2);

		var missing = method.getMissingStatements();

		Assert.areEqual(1, missing.length);
		Assert.areEqual(statement1, missing[0]);
	}

	@Test
	public function shouldAppendBranchesToResults()
	{
		var r = method.getResults();
		assertEmptyResult(r);

		var branch1 = new Branch();
		branch1.id = 0;
		method.addBranch(branch1);

		r = method.getResults(false);
		
		Assert.areEqual(0, r.bt);
		Assert.areEqual(0, r.bf);
		Assert.areEqual(0, r.bc);
		Assert.areEqual(1, r.b);

		branch1.trueCount = 1;
		branch1.falseCount = 1;

		r = method.getResults(false);

		Assert.areEqual(1, r.bt);
		Assert.areEqual(1, r.bf);
		Assert.areEqual(1, r.bc);
		Assert.areEqual(1, r.b);	
	}


	@Test
	public function shouldAppendBranchesAndStatementsToResults()
	{
		var r = method.getResults();
		assertEmptyResult(r);

		var statement1 = new Statement();
		statement1.id = 0;
		method.addStatement(statement1);

		r = method.getResults(false);

		Assert.areEqual(0, r.sc);
		Assert.areEqual(1, r.s);

		statement1.count = 1;

		r = method.getResults(false);

		Assert.areEqual(1, r.sc);
		Assert.areEqual(1, r.s);
	}

	@Test
	public function shouldSerializeProperties():Void
	{
		method.id = 0;
		method.name = "method";

		var statement1 = new Statement();
		statement1.id=0;
		statement1.name = "statement1";
		method.addStatement(statement1);

		var branch1 = new Branch();
		branch1.id = 0;
		branch1.name = "branch1";
		method.addBranch(branch1);

		var string = haxe.Serializer.run(method);
		var copy:Method = haxe.Unserializer.run(string);


		Assert.areEqual(method.id, copy.id);
		Assert.areEqual(method.name, copy.name);

		Assert.isNotNull(method.getStatementById(0));
		Assert.areEqual(statement1.name, method.getStatementById(0).name);

		Assert.isNotNull(method.getBranchById(0));
		Assert.areEqual(branch1.name, method.getBranchById(0).name);
	}

	//////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyMethod();
	}

	function createEmptyMethod():Method
	{
		return new Method();
	}
}