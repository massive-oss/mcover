package massive.mcover;

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
	 * Called when a code block is executed at runtime.
	 *  
	 * @param	block		a code block  
	 */
	function log(block:CodeBlock):Void;
	
	
	/**
	 * Called when all tests are complete.
	 *  
	 * @param	total		total number of blocks
	 * @param	count		total number of blocks executed
	 * @param	data		coverage data containing all blocks
	 * @return	collated result data if any
	 */
	function report(total:Int, count:Int, data:CoverageData):Dynamic;
}