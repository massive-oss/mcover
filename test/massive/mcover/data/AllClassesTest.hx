package massive.mcover.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class AllClassesTest extends AbstractNodeListTest
{	
	var allClasses:AllClasses;

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
		allClasses = createEmptyAllClasses();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldSortMissingBranchesById()
	{
		var item1 = cast(allClasses.getItemByName("item1", NodeMock), NodeMock);
		var item2 = cast(allClasses.getItemByName("item2", NodeMock), NodeMock);
		var item3 = cast(allClasses.getItemByName("item3", NodeMock), NodeMock);
		
		var item1a = cast(allClasses.getItemByName("item1a", NodeMock), NodeMock);
		
		item2.branch.id = 2;
		item3.branch.id = 4;

		var missing = allClasses.getMissingBranches();

		Assert.areEqual(0, missing[0].id);
		Assert.areEqual(0, missing[1].id);
		
		Assert.areEqual(2, missing[2].id);
		Assert.areEqual(4, missing[3].id);
	}

	@Test
	public function shouldSortMissingStatementsById()
	{
		var item1 = cast(allClasses.getItemByName("item1", NodeMock), NodeMock);
		var item2 = cast(allClasses.getItemByName("item2", NodeMock), NodeMock);
		var item3 = cast(allClasses.getItemByName("item3", NodeMock), NodeMock);
		
		var item1a = cast(allClasses.getItemByName("item1a", NodeMock), NodeMock);
		
		item2.statement.id = 2;
		item3.statement.id = 4;

		var missing = allClasses.getMissingStatements();

		Assert.areEqual(0, missing[0].id);
		Assert.areEqual(0, missing[1].id);
		
		Assert.areEqual(2, missing[2].id);
		Assert.areEqual(4, missing[3].id);
	}
	
	@Test
	public function shouldSortClassesById()
	{
		var item1 = cast(allClasses.getItemByName("item1", NodeMock), NodeMock);
		var item2 = cast(allClasses.getItemByName("item2", NodeMock), NodeMock);
		var item3 = cast(allClasses.getItemByName("item3", NodeMock), NodeMock);
		
		var item1a = cast(allClasses.getItemByName("item1a", NodeMock), NodeMock);
		
		item2.clazz.id = 2;
		item3.clazz.id = 4;

		var classes = allClasses.getClasses();

		Assert.areEqual(0, classes[0].id);
		Assert.areEqual(0, classes[1].id);
		
		Assert.areEqual(2, classes[2].id);
		Assert.areEqual(4, classes[3].id);
	}

	@Test
	public function shouldSortPackagesById()
	{

		var item1 = cast(allClasses.getItemByName("item1", Package), Package);
		var item2 = cast(allClasses.getItemByName("item2", Package), Package);
		var item3 = cast(allClasses.getItemByName("item3", Package), Package);
		
		var item1a = cast(allClasses.getItemByName("item1", Package), Package);
		
		item2.id = 2;
		item3.id = 4;
		

		var packages = allClasses.getPackages();

		Assert.areEqual(0, packages[0].id);
		Assert.areEqual(2, packages[1].id);
		Assert.areEqual(4, packages[2].id);
	}

	@Test
	public function shouldAppendFilesCountToResults()
	{
		var r = allClasses.getResults();
		assertEmptyResult(r);

		var item1 = cast(allClasses.getItemByName("item1", NodeMock), NodeMock);
		r = allClasses.getResults(false);

		Assert.areEqual(0, r.pc);
		Assert.areEqual(1, r.p);

		item1.results.sc = 1;

		r = allClasses.getResults(false);

		Assert.areEqual(1, r.pc);
		Assert.areEqual(1, r.p);	
	}

	//////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyNodeList();
	}

	override function createEmptyNodeList():AbstractNodeList
	{
		return createEmptyAllClasses();
	}

	function createEmptyAllClasses():AllClasses
	{
		return new AllClasses();
	}


}