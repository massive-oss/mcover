package massive.mcover.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ClazzTest extends AbstractNodeListTest
{	
	var clazz:Clazz;

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
		clazz = createEmptyClazz();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}
	
	@Test
	public function shouldAppendMethodsToResults()
	{
		var r = clazz.getResults();
		assertEmptyResult(r);

		var item1 = cast(clazz.getItemByName("item1", NodeMock), NodeMock);
		r = clazz.getResults(false);

		Assert.areEqual(0, r.mc);
		Assert.areEqual(1, r.m);

		item1.results.sc = 1;

		r = clazz.getResults(false);

		Assert.areEqual(1, r.mc);
		Assert.areEqual(1, r.m);	
	}

	//////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyNodeList();
	}

	override function createEmptyNodeList():AbstractNodeList
	{
		return createEmptyClazz();
	}

	function createEmptyClazz():Clazz
	{
		return new Clazz();
	}


}