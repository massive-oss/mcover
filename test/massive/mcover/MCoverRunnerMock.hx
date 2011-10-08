package massive.mcover;
import massive.mcover.data.AllClasses;

class MCoverRunnerMock implements MCoverRunner
{
	public var completionHandler(default, default):Float -> Void;

	public var cover(default, null):MCover;
	public var resourceName:String;
	public var allClasses(default, null):AllClasses;

	public var clients:Array<CoverageClient>;

	public var isDestroyed:Bool;


	public function new()
	{
		clients = [];
	
		isDestroyed = false;
	}

	public function initialize(cover:MCover, resourceName:String)
	{
		this.cover = cover;
		this.resourceName = resourceName;
	}

	public function report()
	{
		var timer = massive.munit.util.Timer.delay(reportComplete, 50);
	}

	function reportComplete()
	{
		if(completionHandler != null)
		{
			completionHandler(0);
		}
	}

	public function addClient(client:CoverageClient)
	{
		clients.push(client);
	}

	public function removeClient(client:CoverageClient)
	{
		clients.remove(client);
	}

	public function getClients():Array<CoverageClient>
	{
		return clients;
	}


	public function destroy()
	{
		clients = [];
		isDestroyed = true;
	}

}