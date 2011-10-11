/****
* Copyright 2011 Massive Interactive. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

package massive.mcover;


import massive.mcover.Exception;
import massive.mcover.data.Package;
import massive.mcover.data.File;
import massive.mcover.data.Clazz;
import massive.mcover.data.Method;
import massive.mcover.data.Branch;
import massive.mcover.data.Statement;
import massive.mcover.data.AbstractNode;
import massive.mcover.data.AbstractBlock;
import massive.mcover.data.AbstractNodeList;
import massive.mcover.data.AllClasses;
import massive.mcover.data.CoverageResult;

import massive.mcover.client.TraceClient;
import massive.mcover.CoverageReportClient;


interface CoverageLogger
{
		/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(default, default):Float -> Void;

	var allClasses(default, null):AllClasses;

	function report():Void;

	/**
	 * Add a coverage clients to interpret coverage results.
	 * 
	 * @param client  client to interpret coverage results 
	 * @see massive.mcover.CoverageReportClient
	 * @see massive.mcover.client.PrintClient
	 */
	function addClient(client:CoverageReportClient):Void;
	function removeClient(client:CoverageReportClient):Void;
	function getClients():Array<CoverageReportClient>;


	function initializeAllClasses(?resourceName:String = null):Void;

	function logStatement(id:Int):Void;

	function logBranch(id:Int, value:Dynamic, ?compareValue:Dynamic=null):Dynamic;


}

class CoverageLoggerImpl implements CoverageLogger
{
	#if neko
	static public var mutex:neko.vm.Mutex = new neko.vm.Mutex();
	#end

	/**
	 * Handler called when all clients 
	 * have completed processing the results.
	 */
	public var completionHandler(default, default):Float -> Void;

	public var allClasses(default, null):AllClasses;


	/*
	 * total execution count for statements by id
	*/
	var statementResultsById:IntHash<Int>;
	
	/*
	 * total execution summary for branches by id
	*/
	var branchResultsById:IntHash<BranchResult>;


	var clients:Array<CoverageReportClient>;
	var clientCompleteCount:Int;

	@IgnoreCover
	public function new()
	{
		statementResultsById = new IntHash();
		branchResultsById = new IntHash();
		clients = [];

	}

	public function report()
	{
		#if neko mutex.acquire(); #end

		if(allClasses == null)
		{
			initializeAllClasses();	
		}

		if(clients.length == 0)
		{
			addClient(new TraceClient());
		}
		generateReport();

		#if neko mutex.release(); #end
	}

		public function addClient(client:CoverageReportClient)
	{
		for(c in clients)
		{
			if(c == client) return;
		}

		client.completionHandler = clientCompletionHandler;
		clients.push(client);
	}

	public function removeClient(client:CoverageReportClient)
	{
		client.completionHandler = null;
		clients.remove(client);
	}

	public function getClients():Array<CoverageReportClient>
	{
		return clients.concat([]);
	}


	public function initializeAllClasses(?resourceName:String = null)
	{
		if(resourceName == null) resourceName = MCover.RESOURCE_DATA;
		var serializedData:String = haxe.Resource.getString(resourceName);
		if(serializedData == null) throw new Exception("No generated coverage data found in haxe Resource '" + resourceName  + "'");
		try
		{
			allClasses = haxe.Unserializer.run(serializedData);
			allClasses.setStatementResultsHash(statementResultsById);
			allClasses.setBranchResultsHash(branchResultsById);
		}
		catch(e:Dynamic)
		{
			throw new Exception("Unable to unserialize coverage data in " + resourceName, e);
		}
	}

	/**
	* Method called from injected code each time a code block executes. 
	* Developers should not class this method directly.
	**/
	@IgnoreCover
	public function logStatement(id:Int)
	{	
		#if neko mutex.acquire(); #end
		var count = 1;

		if(statementResultsById.exists(id))
		{
			count = statementResultsById.get(id) + 1;
		}

		statementResultsById.set(id, count);

		#if neko mutex.release(); #end
	}
	
	/**
	* Method called from injected code each time a binary operation resolves to true or false 
	* Developers should not class this method directly.
	* @param id				branch id
	* @param value 			boolean or value to compare with compareValue
	* @param compareValue	secondary value to compare with
	**/
	@IgnoreCover
	public function logBranch(id:Int, value:Dynamic, ?compareValue:Dynamic=null):Dynamic
	{
		#if neko mutex.acquire(); #end


		var bool = false;

		if(compareValue != null)
		{
			bool = value == compareValue;
		}
		else
		{
			bool = value;
		}

		var r:BranchResult = null;
		
		if(branchResultsById.exists(id))
		{
			r = branchResultsById.get(id);
		}
		else
		{
			r = {id:id, trueCount:0, falseCount:0, total:0};
			branchResultsById.set(id, r);
		}

		//record current value
		if(bool) r.trueCount ++;
		else r.falseCount ++;

		r.total ++;
	

		#if neko mutex.release(); #end
		return value;
	}



	

	///////////////////////////////////

	function generateReport()
	{
		allClasses.getResults(true);

		clientCompleteCount = 0;
			
		for (client in clients)
		{	
			client.report(allClasses);
		}
	}

	function clientCompletionHandler(client:CoverageReportClient):Void
	{
		clientCompleteCount ++;
		
		if (clientCompleteCount == clients.length)
		{
			if (completionHandler != null)
			{
				executeCompletionHandler();
				//Timer.delay(executeCompletionHandler, 1);
			}
		}
	}

	function executeCompletionHandler()
	{
		var percent:Float = allClasses.getPercentage();
		completionHandler(percent);
	}

}
