package mcover.cli.report;

#if !haxe3
import massive.sys.io.File;
#end

import mcover.coverage.DataTypes;
import mcover.cli.report.CoverageReport;

#if haxe3
import massive.sys.io.File;
#end

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