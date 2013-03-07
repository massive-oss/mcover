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

import mcover.coverage.DataTypes;


interface CoverageReportClient
{
	/**
	 * Handler which if present, should be called when the client has completed its processing of the results.
	 */
	var completionHandler(default, default):CoverageReportClient -> Void;
		
	/**
	 * Called when all tests are complete.
	 *  
	 * @param	coverage	arrgregated coverage data containing all statements, branches orded by package/file/class/method
	 * @see mcover.coverage.data.Coverage;
	 */
	function report(coverage:Coverage):Void;

	public var output(default, null):String;
}

#if haxe3
interface AdvancedCoverageReportClient extends CoverageReportClient
#else
interface AdvancedCoverageReportClient implements CoverageReportClient
#end
{
	var includeMissingBlocks(default, default):Bool;
	var includeExecutionFrequency(default, default):Bool;
	var includeClassBreakdown(default, default):Bool;
	var includePackageBreakdown(default, default):Bool;
	var includeOverallPercentage(default, default):Bool;
	var includeSummary(default, default):Bool;

	var header(default, null):String;
	var executionFrequency(default, null):String;
	var missingBlocks(default, null):String;
	var classBreakdown(default, null):String;
	var packageBreakdown(default, null):String;
	var summary(default, null):String;
	var overallPercentage(default, null):String;
}