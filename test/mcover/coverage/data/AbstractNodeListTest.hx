package mcover.coverage.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class AbstractNodeListTest extends AbstractNodeTest
{	
	var nodeList:AbstractNodeList;

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
		nodeList = createEmptyNodeList();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldGetUniqueItemByName()
	{
		var item1 = nodeList.getItemByName("item1", NodeMock);
		var item2 = nodeList.getItemByName("item1", NodeMock);

		Assert.areEqual(0, item1.id);
		Assert.areEqual(item1, item2);

		var item3 = nodeList.getItemByName("item2", NodeMock);
		Assert.areEqual(1, item3.id);
		Assert.areNotEqual(item1, item3);
	}

	@Test
	public function shouldLookupBranchInMatchingItem()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		var branch = nodeList.lookupBranch([0]);

		Assert.isNotNull(branch);
		Assert.areEqual(item1.branch, branch);

		branch = nodeList.lookupBranch([1]);
		Assert.isNull(branch);
	}

	@Test
	public function shouldLookupStatementInMatchingItem()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		var statement = nodeList.lookupStatement([0]);

		Assert.isNotNull(statement);
		Assert.areEqual(item1.statement, statement);

		statement = nodeList.lookupStatement([1]);
		Assert.isNull(statement);
	}
	

	@Test
	public function shouldGetMissingBranchesInItems()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		var branches = nodeList.getMissingBranches();

		Assert.areEqual(1, branches.length);
		Assert.areEqual(item1.branch, branches[0]);

		var item2 = cast(nodeList.getItemByName("item2", NodeMock),NodeMock);
		branches = nodeList.getMissingBranches();
		Assert.areEqual(2, branches.length);
	}

	@Test
	public function shouldGetMissingStatementsInItems()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		var statements = nodeList.getMissingStatements();

		Assert.areEqual(1, statements.length);
		Assert.areEqual(item1.statement, statements[0]);

		var item2 = cast(nodeList.getItemByName("item2", NodeMock),NodeMock);
		statements = nodeList.getMissingStatements();
		Assert.areEqual(2, statements.length);
	}

	@Test
	public function shouldGetClassesInItems()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		var classes = nodeList.getClasses();

		Assert.areEqual(1, classes.length);
		Assert.areEqual(item1.clazz, classes[0]);

		var item2 = cast(nodeList.getItemByName("item2", NodeMock),NodeMock);
		classes = nodeList.getClasses();
		Assert.areEqual(2, classes.length);
	}

	@Test
	public function shouldIncludeResultsFromItems()
	{
		var item1 = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		item1.results.sc = 0;

		var r1 = nodeList.getResults();
		Assert.areEqual(0, r1.sc);
		Assert.areEqual(0, r1.s);	

		item1.results.sc = 1;
		var r2 = nodeList.getResults(true);
		Assert.areEqual(0, r2.sc);
		Assert.areEqual(0, r2.s);	

		r2 = nodeList.getResults(false);
		Assert.areEqual(1, r2.sc);
		Assert.areEqual(0, r2.s);

		var item2 = cast(nodeList.getItemByName("item2", NodeMock),NodeMock);
		item2.results.sc = 1;
		r2 = nodeList.getResults(false);
		Assert.areEqual(2, r2.sc);
		Assert.areEqual(0, r2.s);
	}

	@Test
	public function shouldSerializeProperties():Void
	{
		nodeList.id = 0;
		nodeList.name = "nodeList";
		var item1:NodeMock = cast(nodeList.getItemByName("item1", NodeMock),NodeMock);
		item1.id = 0;
		item1.name = "foo";
		var string = haxe.Serializer.run(nodeList);
		var copy:AbstractNodeList = haxe.Unserializer.run(string);

		Assert.areEqual(nodeList.id, copy.id);
		Assert.areEqual(nodeList.name, copy.name);

		Assert.isNotNull(copy.getItemByName("item1", NodeMock));
		var copyItem = cast(copy.getItemByName("item1", NodeMock),NodeMock);
		Assert.areEqual(item1.id, copyItem.id);
		Assert.areEqual(item1.name, copyItem.name);

		var item2 =cast(copy.getItemByName("item2", NodeMock),NodeMock);
		Assert.areEqual(1, item2.id);
	}
	////////////////////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyNodeList();
	}

	function createEmptyNodeList():AbstractNodeList
	{
		return Type.createInstance(AbstractNodeList, []);
	}
}