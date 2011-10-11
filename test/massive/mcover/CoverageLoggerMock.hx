package massive.mcover;

import massive.mcover.data.AllClasses;

class CoverageLoggerMock implements CoverageLogger
{
	public var completionHandler(default, default):Float -> Void;


	public var allClasses(default, null):AllClasses;

	public var clients:Array<CoverageReportClient>;

	public var resourceName:String;

	public var statementId:Int;
	public var branchId:Int;
	public var branchValue:Dynamic;
	public var branchCompareValue:Dynamic;
	
		

	public function new()
	{
		resourceName = null;
		
		allClasses = null;
		clients = [];
	}

	public function report()
	{
		var timer = massive.munit.util.Timer.delay(executeCompletionHandler, 1);
	}

	function executeCompletionHandler()
	{
		if(completionHandler != null)
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
	

	public function loadAllClasses(?resourceName:String = null):Void
	{
		this.resourceName = resourceName;
		allClasses = new AllClasses();
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