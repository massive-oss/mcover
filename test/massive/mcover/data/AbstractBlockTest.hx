package massive.mcover.data;

import massive.mcover.data.AbstractBlock;
import massive.mcover.data.Statement;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class AbstractBlockTest extends AbstractNodeTest
{	
	var block:AbstractBlock;

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
		block = createEmptyBlock();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldNotBeCoveredIfEmpty()
	{
		Assert.isFalse(block.isCovered());
	}

	@Test
	public function shouldPrintDetailsToString()
	{
		block = createBlock();
		var target:String = "example.Foo#test | location";
		Assert.areEqual(target, block.toString());
	}

	////////////////////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyBlock();
	}

	function createEmptyBlock():AbstractBlock
	{
		return Type.createEmptyInstance(AbstractBlock);
	}

	function createBlock():AbstractBlock
	{
		var b = createEmptyBlock();
		b.file = "src/example/Foo.hx";
		b.packageName = "example";
		b.className = "Foo";
		b.qualifiedClassName = "example.Foo";
		b.methodName = "test";
		b.min = 50;
		b.max = 60;
		b.location = "location";
		b.lookup = [0,0,0,0,0];

		return b;
	}
}
	