package m.cover.coverage.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class PackageTest extends AbstractNodeListTest
{	
	var packg:Package;

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
		packg = createEmptyPackage();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldAppendFilesCountToResults()
	{
		var r = packg.getResults();
		assertEmptyResult(r);

		var item1 = cast(packg.getItemByName("item1", NodeMock), NodeMock);
		r = packg.getResults(false);

		Assert.areEqual(0, r.fc);
		Assert.areEqual(1, r.f);

		item1.results.sc = 1;

		r = packg.getResults(false);

		Assert.areEqual(1, r.fc);
		Assert.areEqual(1, r.f);	
	}

	//////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyNodeList();
	}

	override function createEmptyNodeList():AbstractNodeList
	{
		return createEmptyPackage();
	}

	function createEmptyPackage():Package
	{
		return new Package();
	}


}