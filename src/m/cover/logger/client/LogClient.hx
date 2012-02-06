package m.cover.logger.client;

import m.cover.logger.data.Log;
import m.cover.logger.data.LogRecording;

interface LogClient
{
	/**
	Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(default, default):LogClient -> Void;

	/**
	String representation of report output;
	*/
	var output(default, null):String;


	/**
	Generates report output for the current logs
	
	@param logs 		an array of captured logs
	@param recording 	additional metadata such as start/end time
	*/
	function report(logs:Array<Log>, recording:LogRecording):Void;
}
