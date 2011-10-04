package massive.mcover.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class AbstractNodeTest 
{	
	var node:AbstractNode;

	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		node = createEmptyNode();
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function shouldHaveEmptyResults():Void
	{
		var r = node.getResults();
		assertEmptyResult(r);
	}


	@Test
	public function shouldHaveZeroPercentage():Void
	{
		var p = node.getPercentage();
		Assert.areEqual(0, p);
	}


	@Test
	public function shouldHaveNoClasses():Void
	{
		var a = node.getClasses();
		Assert.areEqual(0, a.length);
	}

	@Test
	public function shouldReturnNullBranch():Void
	{
		var b = node.lookupBranch([]);
		Assert.isNull(b);
	}

	@Test
	public function shouldReturnNullStatement():Void
	{
		var b = node.lookupStatement([]);
		Assert.isNull(b);
	}

	@Test
	public function shouldHaveNoMissingBranches():Void
	{
		var a = node.getMissingBranches();
		Assert.areEqual(0, a.length);
	}


	@Test
	public function shouldHaveNoMissingStatements():Void
	{
		var a = node.getMissingStatements();
		Assert.areEqual(0, a.length);
	}

	

	///////////////////////////

	function createEmptyNode():AbstractNode
	{
		return Type.createEmptyInstance(AbstractNode);
	}

	function assertEmptyResult(r:CoverageResult)
	{
		Assert.areEqual(0, r.sc);
		Assert.areEqual(0, r.s);
		Assert.areEqual(0, r.bt);
		Assert.areEqual(0, r.bf);
		Assert.areEqual(0, r.bc);
		Assert.areEqual(0, r.b);
		Assert.areEqual(0, r.mc);
		Assert.areEqual(0, r.m);
		Assert.areEqual(0, r.cc);
		Assert.areEqual(0, r.c);
		Assert.areEqual(0, r.fc);
		Assert.areEqual(0, r.f);
		Assert.areEqual(0, r.pc);
		Assert.areEqual(0, r.p);
	}


}