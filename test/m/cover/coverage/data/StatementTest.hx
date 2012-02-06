package m.cover.coverage.data;

import m.cover.coverage.data.AbstractBlock;
import m.cover.coverage.data.Statement;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class StatementTest extends AbstractBlockTest
{	
	var statement:Statement;

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
		statement = createEmptyStatement();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	@Test
	public function shouldBeCoveredIfCountIncrements():Void
	{
		Assert.areEqual(0, statement.count);
		Assert.isFalse(statement.isCovered());
		statement.count ++;
		Assert.isTrue(statement.isCovered());
	}

	////////////////////////////////

	override function createEmptyNode():AbstractNode
	{
		return createEmptyBlock();
	}

	override function createEmptyBlock():AbstractBlock
	{
		return createEmptyStatement();
	}

	function createEmptyStatement():Statement
	{
		return new Statement();
	}
}