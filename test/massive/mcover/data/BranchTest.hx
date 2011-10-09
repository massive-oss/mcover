package massive.mcover.data;

import massive.mcover.data.AbstractBlock;
import massive.mcover.data.Statement;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class BranchTest extends AbstractBlockTest
{	
	var branch:Branch;

	public function new() 
	{
		super();
	}

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
		branch = createEmptyBranch();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldBeCoveredIfTrueAndFalseCountIncrements():Void
	{
		Assert.areEqual(0, branch.trueCount);
		Assert.areEqual(0, branch.falseCount);
		Assert.isFalse(branch.isCovered());
		branch.trueCount = 1;
		Assert.isFalse(branch.isCovered());
		branch.trueCount = 0;
		branch.falseCount = 1;
		Assert.isFalse(branch.isCovered());
		branch.trueCount = 1;
		branch.falseCount = 1;
		Assert.isTrue(branch.isCovered());
	}

		@Test
	public function shouldHaveTotalCount():Void
	{
		Assert.areEqual(0, branch.totalCount);
		branch.trueCount = 1;
		Assert.areEqual(1, branch.totalCount);

		branch.falseCount = 1;
		Assert.areEqual(2, branch.totalCount);
	}

	@Test
	override public function shouldPrintDetailsToString()
	{
		branch = cast(createBlock(), Branch);

		var str:String = "example.Foo#test | location";

		branch.trueCount = 0;
		branch.falseCount = 0;
		Assert.areEqual(str + " | t,f", branch.toString());
		
		branch.trueCount = 0;
		branch.falseCount = 1;
		Assert.areEqual(str + " | t", branch.toString());

		branch.trueCount = 1;
		branch.falseCount = 0;
		Assert.areEqual(str + " | f", branch.toString());

		branch.trueCount = 1;
		branch.falseCount = 1;
		Assert.areEqual(str, branch.toString());
	}

	////////////////////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyBlock();
	}

	override function createEmptyBlock():AbstractBlock
	{
		return createEmptyBranch();
	}

	function createEmptyBranch():Branch
	{
		return new Branch();
	}
}