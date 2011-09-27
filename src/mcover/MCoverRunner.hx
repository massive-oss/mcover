package mcover;

import mcover.client.PrintClient;
import haxe.Timer;

@:keep class MCoverRunner
{
	static public var instance(default, null):MCoverRunner;

	static public function createInstance(?client:CoverageClient, ?posInfos:haxe.PosInfos):MCoverRunner
	{
		if(client == null) client = new PrintClient();
		instance = new MCoverRunner(client);
		return instance;
	}

	/**
	* method called from injected code each time a code block executes
	**/
	static public function log(value:String)
	{	
		if(instance == null) createInstance(new PrintClient());
		instance.logEntry(value);
	}

	static public function report()
	{
		if(instance == null) throw "No instance found.";
		return instance.reportResults();
	}

	/**
	 * Handler called when all clients 
	 * have completed processing the results.
	 */
	public var completionHandler:Bool -> Void;

	public var clientCount(get_clientCount, null):Int;
	function get_clientCount():Int { return clients.length; }

	var clientCompleteCount:Int;

	var clients:Array<CoverageClient>;

	var isDebug(default, null):Bool;


	var entries:IntHash<CoverageEntry>;
	
	var classes:Hash<CoverageEntryCollection>;
	var packages:Hash<CoverageEntryCollection>;

	var total(default, null):Int;
	var count(default, null):Int;

	/**
	 * Class constructor.
	 * 
	 * @param	client	a client to interpret coverage results
	 */
	function new(client:CoverageClient)
	{
		clients = new Array();
		addClient(client);

		entries = new IntHash();
		classes = new Hash();
		packages = new Hash();

		parseEntries();	

		total = Lambda.count(entries);
		count = 0;

		instance = this;
	}

	/**
	 * Add one or more coverage clients to interpret coverage results.
	 * 
	 * @param	client		a  client to interpret coverage results 
	 */
	public function addClient(client:CoverageClient):Void
	{
		for (c in clients) if (c == client) return;

		client.completionHandler = clientCompletionHandler;
		clients.push(client);
	}

	/**
	 * Log an individual call from within the code base.
	 * Do not call directly. The method only called via code injection by the compiler
	 * 
	 * @param	value		a string representation of a CoverageEntry
	 * @see mcover.CoverageEntry
	 */
	public function logEntry(value:String)
	{
		//trace(value);
		var temp = new CoverageEntry(value);
		
		if(!entries.exists(temp.id)) throw "Unexpected entry " + value;
		
		var entry = entries.get(temp.id);

		if(!entry.result)
		{
			count += 1;
		}

		entry.count += 1;

		for (client in clients) client.logEntry(entry);
	}

	public function reportResults()
	{
		for (client in clients)
		{
			client.report(total, count, entries, classes, packages);
		}
	}

	function clientCompletionHandler(client:CoverageClient):Void
	{
		if (++clientCompleteCount == clients.length)
		{
			if (completionHandler != null)
			{
				var percent:Bool = (count == total);
				var handler:Dynamic = completionHandler;
				
				#if !neko
				Timer.delay(function() { handler(percent); }, 1);
				#else
				trace("Warning - neko haxe.Timer has no delay method");
				#end
			}
		}
	}

	function parseEntries()
	{
		var file = haxe.Resource.getString("MCover");
		var lines = file.split("\n");

		for(line in lines)
		{
			var entry = new CoverageEntry(line);
		
			addEntryToHashes(entry);
		}
	}

	function addEntryToHashes(entry:CoverageEntry)
	{
		entries.set(Lambda.count(entries), entry);

		var packageKey = entry.packageName != "" ?  entry.packageName : "[default]";
		if(!packages.exists(packageKey))
		{
			packages.set(packageKey, new CoverageEntryCollection(packageKey));
		}

		var pckg = packages.get(packageKey);
		pckg.addEntry(entry);


		var classKey = entry.packageName != "" ? entry.packageName + "." + entry.className : entry.className;
		if(!classes.exists(classKey))
		{
			classes.set(classKey, new CoverageEntryCollection(classKey));
		}

		var cls = classes.get(classKey);
		cls.addEntry(entry);
	}
}