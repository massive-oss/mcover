package mcover.coverage.data;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.coverage.data.DataUtil;

/**
* Auto generated MassiveUnit Test Class  for mcover.coverage.data.DataUtil 
*/
class DataUtilTest 
{
	var instance:DataUtil; 
	
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
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function shouldSortNodesById():Void
	{
		var node1 = new NodeMock();
		var node2 = new NodeMock();
		var node3 = new NodeMock();

		node1.id = 0;
		node2.id = 2;
		node3.id = 1;

		var a = [node1,node2,node3];
		a.sort(DataUtil.sortOnNodeId);

		Assert.areEqual(node1, a[0]);
		Assert.areEqual(node3, a[1]);
		Assert.areEqual(node2, a[2]);		
	}

	@Test
	public function shouldSortOnNodeName():Void
	{
		var node1 = new NodeMock();
		var node2 = new NodeMock();
		var node3 = new NodeMock();
		var node4 = new NodeMock();
		node1.name = "a";
		node2.name = "b";
		node3.name = "A.a";
		node4.name = "b";

		var a = [node1,node2,node3, node4];
		a.sort(DataUtil.sortOnNodeName);

		Assert.areEqual(node1, a[0]);
		Assert.areEqual(node3, a[1]);
		Assert.areEqual(node2, a[2]);
		Assert.areEqual(node4, a[3]);	
	}

	@Test
	public function shouldSortOnBlockName():Void
	{
		var node1 = new Branch();
		var node2 = new Branch();
		var node3 = new Branch();
		var node4 = new Branch();
		node1.qualifiedClassName = "a";
		node2.qualifiedClassName = "b";
		node3.qualifiedClassName = "A.a";
		node4.qualifiedClassName = "b";

		var a = [node1,node2,node3, node4];
		a.sort(DataUtil.sortOnBlockName);

		Assert.areEqual(node1, a[0]);
		Assert.areEqual(node3, a[1]);
		Assert.areEqual(node2, a[2]);
		Assert.areEqual(node4, a[3]);	
	}
}