package massive.mcover;
import massive.mcover.data.AllClasses;

class CoverageReporterMock implements CoverageReporter
{
	public var completionHandler(default, default):Float -> Void;

	public var logger(default, null):CoverageLogger;
	public var allClasses(default, null):AllClasses;

	public var clients:Array<CoverageReportClient>;

	public var isDestroyed:Bool;


	public function new()
	{
		clients = [];
	
		isDestroyed = false;
	}

	public function initialize(logger:CoverageLogger, allClasses:AllClasses)
	{
		this.logger = logger;
		this.allClasses = allClasses;
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


	public function destroy()
	{
		clients = [];
		isDestroyed = true;
	}

}