package mcover.cli.report;
import m.cover.coverage.DataTypes;

interface CoverageReport
{
	function report(coverage:Coverage):Void;
}

class CoverageReportBase implements CoverageReport
{
	var coverage:Coverage;

	public function new()
	{
		
	}

	public function report(coverage:Coverage):Void
	{
		this.coverage = coverage;
		coverage.getResults();
	}
}