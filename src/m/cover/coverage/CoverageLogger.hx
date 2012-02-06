/****
* Copyright 2012 Massive Interactive. All rights reserved.
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

package m.cover.coverage;


import m.cover.coverage.CoverageException;
import m.cover.coverage.data.Package;
import m.cover.coverage.data.File;
import m.cover.coverage.data.Clazz;
import m.cover.coverage.data.Method;
import m.cover.coverage.data.Branch;
import m.cover.coverage.data.Statement;
import m.cover.coverage.data.AbstractNode;
import m.cover.coverage.data.AbstractBlock;
import m.cover.coverage.data.AbstractNodeList;
import m.cover.coverage.data.Coverage;
import m.cover.coverage.data.CoverageResult;

import m.cover.coverage.client.TraceClient;
import m.cover.coverage.CoverageReportClient;


interface CoverageLogger
{
		/*
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(default, default):Float -> Void;

	var coverage(default, null):Coverage;


	var currentTest(default, set_currentTest):String;

	function report(?skipClients:Bool=false):Void;
	function reportCurrentTest(?skipClients:Bool=false):Void;

	/**
	 * Add a coverage clients to interpret coverage results.
	 * 
	 * @param client  client to interpret coverage results 
	 * @see m.cover.coverage.CoverageReportClient
	 * @see m.cover.coverage.client.PrintClient
	 */
	function addClient(client:CoverageReportClient):Void;
	function removeClient(client:CoverageReportClient):Void;
	function getClients():Array<CoverageReportClient>;


	function initializeCoverage(?resourceName:String = null):Void;

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

	public var coverage(default, null):Coverage;

	public var currentTest(default, set_currentTest):String;


	/*
	 * total execution count for statements by id
	*/
	var allStatementResultsById:IntHash<Int>;
	
	/*
	 * total execution summary for branches by id
	*/
	var allBranchResultsById:IntHash<BranchResult>;

	/*
	 * statement execution counts for current test
	*/
	var testStatementResultsById:IntHash<Int>;
	
	/*
	 * branch execution counts for current test
	*/
	var testBranchResultsById:IntHash<BranchResult>;


	var clients:Array<CoverageReportClient>;
	var clientCompleteCount:Int;

	@IgnoreCover
	public function new()
	{
		allStatementResultsById = new IntHash();
		allBranchResultsById = new IntHash();
		clients = [];
	}

	public function report(?skipClients:Bool=false)
	{
		generateReportResults(false);

		if(!skipClients)
		{
			reportToClients();
		}
	}

	public function reportCurrentTest(?skipClients:Bool=false)
	{
		if(currentTest == null) throw new CoverageException("No test specified to report on.");
		generateReportResults(true);	
		
		if(!skipClients)
		{
			reportToClients();
		}
	}

	function generateReportResults(?currentTestOnly:Bool=false)
	{
		if(coverage == null)
		{
			initializeCoverage();	
		}
		
		if(currentTestOnly)
		{
			coverage.setStatementResultsHash(testStatementResultsById);
			coverage.setBranchResultsHash(testBranchResultsById);	
		}
		else
		{
			coverage.setStatementResultsHash(allStatementResultsById);
			coverage.setBranchResultsHash(allBranchResultsById);
		}

		coverage.getResults(false);
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


	public function initializeCoverage(?resourceName:String = null)
	{
		if(resourceName == null) resourceName = MCover.RESOURCE_DATA;
		var serializedData:String = haxe.Resource.getString(resourceName);
		if(serializedData == null) throw new CoverageException("No generated coverage data found in haxe Resource '" + resourceName  + "'");
		try
		{
			coverage = haxe.Unserializer.run(serializedData);
		}
		catch(e:Dynamic)
		{
			throw new CoverageException("Unable to unserialize coverage data in " + resourceName, e);
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

		updateStatementHash(allStatementResultsById, id);

		if(currentTest != null)
		{				
			updateStatementHash(testStatementResultsById, id);
		}
		#if neko mutex.release(); #end
	}

	@IgnoreCover
	function updateStatementHash(hash:IntHash<Int>, id:Int)
	{
		var count = 1;

		if(hash.exists(id))
		{
			count = hash.get(id) + 1;
		}
		hash.set(id, count);
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

		updateBranchHash(allBranchResultsById, id, bool);

		if(currentTest != null)
		{
			updateBranchHash(testBranchResultsById, id, bool);
		}

		#if neko mutex.release(); #end
		return value;
	}

	@IgnoreCover
	function updateBranchHash(hash:IntHash<BranchResult>, id:Int, value:Bool)
	{
		var r:BranchResult = null;
		
		if(hash.exists(id))
		{
			r = hash.get(id);
		}
		else
		{
			r = {id:id, trueCount:0, falseCount:0, total:0};
			hash.set(id, r);
		}

		//record current value
		if(value) r.trueCount ++;
		else r.falseCount ++;

		r.total ++;
	}

	///////////////////////////////////

	function set_currentTest(value:String):String
	{
		currentTest = value;
		testStatementResultsById = new IntHash();
		testBranchResultsById = new IntHash();
		return value;
	}


	function reportToClients()
	{
		if(clients.length == 0)
		{
			addClient(new TraceClient());
		}
		
		clientCompleteCount = 0;
			
		for (client in clients)
		{	
			client.report(coverage);
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
		var percent:Float = coverage.getPercentage();
		completionHandler(percent);
	}

}
