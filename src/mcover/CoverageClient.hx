package mcover;

interface CoverageClient
{
	/**
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */

	var completionHandler(get_completeHandler, set_completeHandler):CoverageClient -> Void;

	
	/**
	 * The unique identifier for the client.
	 */
	var id(default, null):String;
	
	/**
	 * Called when an entry is executed at runtime.
	 *  
	 * @param	entry		an entry 
	 */
	function logEntry(entry:CoverageEntry):Void;
	
	
	/**
	 * Called when all tests are complete.
	 *  
	 * @param	total		total number of entries
	 * @param	count		total number of entries executed
	 * @param	entries		hash of entries
	 * @param	classes		entries by class
	 * @param	packages	entries by package
	 * @param	time			number of milliseconds taken for all tests to be executed
	 * @return	collated result data if any
	 */
	function report(total:Int,
							count:Int,
							entries:IntHash<CoverageEntry>,
							classes:Hash<CoverageEntryCollection>,
							packages:Hash<CoverageEntryCollection>
							):Dynamic;
}