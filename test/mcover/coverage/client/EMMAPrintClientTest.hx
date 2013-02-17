package mcover.coverage.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import mcover.coverage.client.EMMAPrintClient;
import mcover.coverage.data.Statement;
import mcover.coverage.data.Branch;
import mcover.coverage.data.Coverage;
import mcover.coverage.data.CoverageResult;

import mcover.coverage.data.NodeMock;

/**
* Auto generated MassiveUnit Test Class  for mcover.coverage.client.EMMAPrintClient 
*/
class EMMAPrintClientTest extends CoverageReportClientTest
{
	var instance:EMMAPrintClient; 
	
	public function new() 
	{
		super();
	}
	
	
	@Before
	override public function setup():Void
	{
		super.setup();
		instance = new EMMAPrintClient();
		coverage = new Coverage();
	}
	


	@Test
	public function shouldIncludeEmptyStats():Void
	{
		instance.report(new Coverage());

		var xml = instance.xml;

		var stats = xml.firstChild();

		Assert.areEqual("stats", stats.nodeName);

		var node:Xml;
		
		node = stats.elementsNamed("packages").next();
		assertStatNodeValue(node, 0);

		node = stats.elementsNamed("classes").next();
		assertStatNodeValue(node, 0);

		node = stats.elementsNamed("methods").next();
		assertStatNodeValue(node, 0);

		node = stats.elementsNamed("srcfiles").next();
		assertStatNodeValue(node, 0);

		node = stats.elementsNamed("srclines").next();
		assertStatNodeValue(node, 0);

	}

	@Test
	public function shouldIncludeStats():Void
	{
		coverage = createMockCoverage();
		instance.report(coverage);

		var xml = instance.xml;

		var stats = xml.firstChild();

		Assert.areEqual("stats", stats.nodeName);

		var result = coverage.getResults();
		var node:Xml;
		
		node = stats.elementsNamed("packages").next();
		assertStatNodeValue(node, result.p);

		node = stats.elementsNamed("classes").next();
		assertStatNodeValue(node, result.c);

		node = stats.elementsNamed("methods").next();
		assertStatNodeValue(node, result.m);

		node = stats.elementsNamed("srcfiles").next();
		assertStatNodeValue(node, result.f);

		node = stats.elementsNamed("srclines").next();
		assertStatNodeValue(node, 0);

	}

	@Test
	public function shouldIncludeAllClassesNode():Void
	{
		coverage =  createMockCoverage();

		instance.report(coverage);

		var xml = instance.xml;
		var dataNode = xml.elementsNamed("data").next();

		Assert.isNotNull(dataNode);
		var allNode = dataNode.firstElement();

		Assert.isNotNull(allNode);
		assertNodeNameAtt(allNode, "all classes");
	}

	//////

	function assertStatNodeValue(node:Xml, value:Int)
	{
		Assert.isNotNull(node);
		assertNodeAtt(node, "value", value);
	}

	function assertNodeNameAtt(node:Xml, name:String)
	{
		assertNodeAtt(node, "name", name);
	}

	function assertNodeAtt(node:Xml, att:String, value:Dynamic)
	{
		Assert.isNotNull(node);
		Assert.isNotNull(node.get(att));
		Assert.areEqual(Std.string(value), Std.string(node.get(att)));
	}

	override function createClient():CoverageReportClient
	{
		return new EMMAPrintClient();
	}


	static public function createMockCoverage(?statementCount:Int=10, ?branchTrueCount:Int=5, ?branchFalseCount:Int=5):Coverage
	{
		var coverage = new Coverage();

		var statement =NodeMock.createStatement();
		coverage.addStatement(statement);

		var map:Map<Int,Int> = new Map();
		map.set(statement.id, statementCount);
		coverage.setStatementResultsMap(map);

		var statement2 = NodeMock.createStatement(1);
		statement2.methodName="method2";
		coverage.addStatement(statement2);

		var branch = NodeMock.createBranch();
		coverage.addBranch(branch);

		var map:Map<Int,BranchResult> = new Map();

		var result:BranchResult = {id:branch.id, trueCount:branchTrueCount, falseCount:branchFalseCount, total:branchTrueCount + branchFalseCount};

		map.set(branch.id, result);
		coverage.setBranchResultsMap(map);

		var branch2 = NodeMock.createBranch(1);
		coverage.addBranch(branch2);

		return coverage;
	}
}