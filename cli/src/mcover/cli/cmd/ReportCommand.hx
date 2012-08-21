package mcover.cli.cmd;

import massive.neko.io.File;
import mcover.coverage.data.Coverage;
import mcover.cli.report.BasicCoverageReport;
import mcover.cli.report.HTMLCoverageReport;
import mcover.cli.report.RawCoverageReport;

class ReportCommand extends MCoverCommand
{
	var file:File;
	var output:File;
	var classPaths:Array<File>;

	var coverage:Coverage;

	public function new()
	{
		super();
	}

	override public function initialise():Void
	{
		super.initialise();

		var filePath = console.getNextArg();
		
		if (filePath == null)
		{
			error("Missing input path. Please refer to help.");
			return;
		}

		file = console.dir.resolveFile(filePath);

		if (!file.exists)
		{
			error("input file path (" + file + ") does not exist.");
			return;
		}

		var outputPath = console.getNextArg();

		if (outputPath == null)
		{
			error("Missing output path. Please refer to help.");
			return;
		}

		output = console.dir.resolveDirectory(outputPath, true);

		
		var classPath = console.getNextArg();
		if (classPath == null) classPath = "src";

		classPaths = [];

		

		while (classPath != null)
		{
			var cp = console.dir.resolveDirectory(classPath);
			if (!cp.exists)
			{
				error("classpath path (" + cp + ") does not exist.");
				return;
			}
			classPaths.push(cp);

			classPath = console.getNextArg();
		}


		coverage = parseCoverageData(file);

		if (coverage == null)
		{
			error("Invalid coverage data file. Unable to load " + file);
			return;
		}
	}

	override public function execute():Void
	{
		super.execute();

		var basicReport = new BasicCoverageReport();
		basicReport.report(coverage);

		var htmlReport = new HTMLCoverageReport(output, classPaths);
		htmlReport.report(coverage);

		var rawReport = new RawCoverageReport(output, classPaths);
		rawReport.report(coverage);


	}

	function parseCoverageData(file:File):Coverage
	{
		var serializedData:String = file.readString();

		try
		{
			return haxe.Unserializer.run(serializedData);
		}
		catch(e:Dynamic)
		{
			return null;
		}
	}
}