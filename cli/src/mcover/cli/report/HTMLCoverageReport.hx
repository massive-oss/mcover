package mcover.cli.report;

import massive.neko.io.File;
import mcover.coverage.DataTypes;
import mcover.cli.report.CoverageReport;

class HTMLCoverageReport extends CoverageReportBase
{
	public function new(outputDir:File, classPaths:Array<File>)
	{
		super();
	}

	override public function report(coverage:Coverage):Void
	{
		super.report(coverage);
	}
}