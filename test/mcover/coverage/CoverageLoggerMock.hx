package mcover.coverage;

import mcover.coverage.data.Coverage;

class CoverageLoggerMock implements CoverageLogger
{
	public var completionHandler(default, default):Float -> Void;


	public var coverage(default, null):Coverage;

	public var currentTest(default, set_currentTest):String;
	function set_currentTest(value:String):String
	{
		currentTest = value;
		return value;
	}


	public var clients:Array<CoverageReportClient>;

	public var resourceName:String;

	public var statementId:Int;
	public var branchId:Int;
	public var branchValue:Dynamic;
	public var branchCompareValue:Dynamic;
	
		

	public function new()
	{
		resourceName = null;
		
		coverage = null;
		clients = [];
	}

	public function setCoverage(coverage:Coverage)
	{
		this.coverage = coverage;
	}

	public function report(?skipClients:Bool=false)
	{
		var timer = massive.munit.util.Timer.delay(executeCompletionHandler, 1);
	}

	public function reportCurrentTest(?skipClients:Bool=false)
	{
		var timer = massive.munit.util.Timer.delay(executeCompletionHandler, 1);
	}


	function executeCompletionHandler()
	{
		if (completionHandler != null)
		{
			completionHandler(0);
		}
	}

	public function addClient(client:CoverageReportClient)
	{
		clients.push(client);
	}

	public function removeClient(client:CoverageReportClient)
	{
		clients.remove(client);
	}

	public function getClients():Array<CoverageReportClient>
	{
		return clients;
	}
	

	public function initializeCoverage(resourceName:String):Void
	{
		this.resourceName = resourceName;
		coverage = new Coverage();
	}

	public function logStatement(id:Int):Void
	{
		statementId = id;
	}

	public function logBranch(id:Int, value:Dynamic, ?compareValue:Dynamic):Dynamic
	{
		branchId = id;
		branchValue = value;
		branchCompareValue = compareValue;
		return value;
	}

}