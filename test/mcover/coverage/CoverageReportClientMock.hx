package mcover.coverage;

import mcover.coverage.data.Statement;
import mcover.coverage.data.Branch;
import mcover.coverage.data.Coverage;
import mcover.coverage.CoverageReportClient;

class CoverageReportClientMock implements AdvancedCoverageReportClient
{
	public var coverage:Coverage;

	/**
		Handler which if present, is called when the client has completed generating its results.
	**/
	public var completionHandler(default, default):CoverageReportClient -> Void;

	public var includeHeader(default, default):Bool;
	public var includeMissingBlocks(default, default):Bool;
	public var includeExecutionFrequency(default, default):Bool;
	public var includeClassBreakdown(default, default):Bool;
	public var includePackageBreakdown(default, default):Bool;
	public var includeOverallPercentage(default, default):Bool;
	public var includeSummary(default, default):Bool;

	public var output(default, null):String;

	public var header(default, null):String;
	public var executionFrequency(default, null):String;
	public var missingBlocks(default, null):String;
	public var classBreakdown(default, null):String;
	public var packageBreakdown(default, null):String;
	public var summary(default, null):String;
	public var overallPercentage(default, null):String;

	public function new()
	{
		
	}

	public function report(coverage:Coverage):Void
	{
		this.coverage = coverage;

		var timer = massive.munit.util.Timer.delay(reportComplete, 1);
	}

	function reportComplete()
	{
		if (completionHandler != null)
		{
			completionHandler(this);
		}
	}
}