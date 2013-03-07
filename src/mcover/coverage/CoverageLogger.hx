/****
* Copyright 2013 Massive Interactive. All rights reserved.
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

package mcover.coverage;


import mcover.coverage.CoverageException;
import mcover.coverage.DataTypes;

import mcover.coverage.client.TraceClient;
import mcover.coverage.CoverageReportClient;

#if neko
import neko.vm.Mutex;
#elseif cpp
import cpp.vm.Mutex;
#end

#if haxe3
import haxe.ds.StringMap;
import haxe.ds.IntMap;
#else
private typedef StringMap<T> = Hash<T>
private typedef IntMap<T> = IntHash<T>
#end

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
	 * @see mcover.coverage.CoverageReportClient
	 * @see mcover.coverage.client.PrintClient
	 */
	function addClient(client:CoverageReportClient):Void;
	function removeClient(client:CoverageReportClient):Void;
	function getClients():Array<CoverageReportClient>;


	function initializeCoverage(resourceName:String):Void;

	function logStatement(id:Int):Void;

	function logBranch(id:Int, value:Dynamic, ?compareValue:Dynamic=null):Dynamic;


}

@IgnoreLogging
class CoverageLoggerImpl implements CoverageLogger
{
	#if (neko||cpp)
	static public var mutex:Mutex;
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
	var allStatementResultsById:IntMap<Int>;
	
	/*
	 * total execution summary for branches by id
	*/
	var allBranchResultsById:IntMap<BranchResult>;

	/*
	 * stores a cache of test results against currentTest string
	*/
	var filteredResultsMap:StringMap<FilteredCoverageResults>;

	/*
	 * results for active 'currentTest'
	*/
	var currentFilteredResults:FilteredCoverageResults;

	var clients:Array<CoverageReportClient>;
	var clientCompleteCount:Int;

	@IgnoreCover
	public function new()
	{
		allStatementResultsById = new IntMap();
		allBranchResultsById = new IntMap();
		filteredResultsMap = new StringMap();
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
			initializeCoverage(null);	
		}
		
		if(currentTestOnly)
		{
			coverage.setStatementResultsMap(currentFilteredResults.statementResultsById);
			coverage.setBranchResultsMap(currentFilteredResults.branchResultsById);	
		}
		else
		{
			coverage.setStatementResultsMap(allStatementResultsById);
			coverage.setBranchResultsMap(allBranchResultsById);
		}

		coverage.getResults(false);
	}

	
	public function addClient(client:CoverageReportClient)
	{
		if(client == null) throw "Null Client";
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

	public function initializeCoverage(resourceName:String):Void
	{
		if(resourceName == null) resourceName = MCoverage.RESOURCE_DATA;
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
		#if (neko||cpp)
			if(mutex == null) mutex = new Mutex();
		 	mutex.acquire();
		#end

		updateStatementMap(allStatementResultsById, id);

		if(currentFilteredResults != null)
		{				
			updateStatementMap(currentFilteredResults.statementResultsById, id);
		}
		#if (neko||cpp) mutex.release(); #end
	}

	@IgnoreCover
	function updateStatementMap(map:IntMap<Int>, id:Int)
	{
		var count = 1;

		if(map.exists(id))
		{
			count = map.get(id) + 1;
		}
		map.set(id, count);
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
		#if (neko||cpp)
			if(mutex == null) mutex = new Mutex();
		 	mutex.acquire();
		#end

		var bool = false;

		if(compareValue != null)
		{
			bool = value == compareValue;
		}
		else
		{
			bool = value;
		}

		updateBranchMap(allBranchResultsById, id, bool);

		if(currentFilteredResults != null)
		{
			updateBranchMap(currentFilteredResults.branchResultsById, id, bool);
		}

		#if (neko||cpp) mutex.release(); #end
		return value;
	}

	@IgnoreCover
	function updateBranchMap(map:IntMap<BranchResult>, id:Int, value:Bool)
	{
		var r:BranchResult = null;
		
		if(map.exists(id))
		{
			r = map.get(id);
		}
		else
		{
			r = {id:id, trueCount:0, falseCount:0, total:0};
			map.set(id, r);
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

		if(value == null)
		{
			currentFilteredResults = null;
			return value;
		}

		if(!filteredResultsMap.exists(value))
		{
			var result:FilteredCoverageResults = {filter:value, statementResultsById:new IntMap(), branchResultsById:new IntMap()};
			filteredResultsMap.set(value, result); 
		}

		currentFilteredResults = filteredResultsMap.get(value);

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

				// #if php
				// 	executeCompletionHandler();
				// #else
				// 	Timer.delay(executeCompletionHandler, 1);
				// #end
				
			}
		}
	}

	function executeCompletionHandler()
	{
		var percent:Float = coverage.getPercentage();
		completionHandler(percent);
	}

}

typedef FilteredCoverageResults =
{
	/*
	 * name of class being covered
	*/	
	filter:String,

	/*
	 * statement execution counts for current test
	*/
	statementResultsById:IntMap<Int>,
	
	/*
	 * branch execution counts for current test
	*/
	branchResultsById:IntMap<BranchResult>
}

