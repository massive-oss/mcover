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
	public function shouldReturnCachedResults()
	{
		var r1 = node.getResults();
	
		var r2 = node.getResults(true);
		Assert.areEqual(r1, r2);

		r2 = node.getResults(false);
		Assert.areNotEqual(r1, r2);
	}

	@Test
	public function shouldHaveZeroPercentage():Void
	{
		var p = node.getPercentage();
		Assert.areEqual(0, p);
	}

	@Test
	public function shouldCalculateAccuratePercentage():Void
	{
		var r = node.getResults();

		r = convertResultStringToResult(r, "0,0,0,0,0,0,0");
		var p = node.getPercentage();
		Assert.areEqual(0, p);

		r = convertResultStringToResult(r, "0,0,1,0,1,0,1");
		p = node.getPercentage();
		Assert.areEqual(0/4, p);

		r = convertResultStringToResult(r, "0,0,1,0,1,1,1");
		p = node.getPercentage();
		Assert.areEqual(25, p);

		r = convertResultStringToResult(r, "0,0,1,1,1,1,1");
		p = node.getPercentage();
		Assert.areEqual(50, p);

		r = convertResultStringToResult(r, "1,1,1,0,1,0,1");
		p = node.getPercentage();
		Assert.areEqual(50, p);

		r = convertResultStringToResult(r, "1,1,1,1,1,0,1");
		p = node.getPercentage();
		Assert.areEqual(75, p);

		r = convertResultStringToResult(r, "1,1,1,1,1,1,1");
		p = node.getPercentage();
		Assert.areEqual(100, p);
	}


	@Test
	public function shouldReturnZeroPercentIfResultContainsNaN()
	{
		var r1 = node.getResults();

		#if flash
			r1.sc = untyped __global__["NaN"];
		#else
			r1.sc = null;
		#end

		var p = node.getPercentage();
		Assert.areEqual(0, p);
	}

	function convertResultStringToResult(r:CoverageResult, ?values:String="0,0,0,0,0,0,0"):CoverageResult
	{
		var a = values.split(",");
		r.bt = Std.parseInt(a[0]);
		r.bf = Std.parseInt(a[1]);
		r.b = Std.parseInt(a[2]);
		r.sc = Std.parseInt(a[3]);
		r.s = Std.parseInt(a[4]);
		r.mc = Std.parseInt(a[5]);
		r.m = Std.parseInt(a[6]);

		return r;
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