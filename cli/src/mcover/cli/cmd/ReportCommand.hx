package mcover.cli.cmd;

import massive.neko.io.File;
import mcover.coverage.data.Coverage;
import mcover.cli.report.BasicCoverageReport;
import mcover.cli.report.HTMLCoverageReport;
import mcover.cli.report.RawCoverageReport;

class ReportCommand extends MCoverCommand
{
	var src:File;
	var out:File;
	var classPaths:Array<File>;

	var targets:Array<File>;

	var coverage:Array<Coverage>;

	public function new()
	{
		super();
	}

	override public function initialise():Void
	{
		super.initialise();

		src = initializeSource();
		out = initializeOut();
		classPaths = initializeClassPaths();

		targets = initializeTargets(src);
		coverage = initializeCoverage(targets);
	}

	override public function execute():Void
	{
		super.execute();

		var basicReport = new BasicCoverageReport();
		//basicReport.report(coverage);

		var htmlReport = new HTMLCoverageReport(out, classPaths);
		//htmlReport.report(coverage);

		var rawReport = new RawCoverageReport(out, classPaths);
		rawReport.report(coverage[0]);


	}


	//---------------------------------------------------------------------------  init


	function initializeSource():File
	{
		var path = ".mcover/data";

		var file = console.dir.resolveDirectory(path);

		if (!file.exists)
		{
			error("mcover data (" + file + ") does not exist.");
			return null;
		}

		return file;
	}

	function initializeOut():File
	{
		var path = console.getNextArg();

		if (path == null)
		{
			error("Missing out path. Please refer to help.");
			return null;
		}

		return console.dir.resolveDirectory(path, true);
	}

	function initializeClassPaths():Array<File>
	{
		var classPaths = [];

		var classPath = console.getNextArg();
		if (classPath == null) classPath = "src";

		while (classPath != null)
		{
			var cp = console.dir.resolveDirectory(classPath);
			if (!cp.exists)
			{
				error("classpath path (" + cp + ") does not exist.");
				return null;
			}
			classPaths.push(cp);

			classPath = console.getNextArg();
		}

		return classPaths;

	}

	function initializeTargets(src:File):Array<File>
	{
		var defaultTargets = ["neko", "cpp", "php", "as3", "js"];
		var targets:Array<File> = [];

		for(t in defaultTargets)
		{
			if(console.getOption(t) == null) continue;

			var file = src.resolveFile(t + ".mcover");

			if(file.exists)
				targets.push(file);
		}

		if(targets.length == 0)
		{
			var t = null;

			while(t == null)
			{
				t = console.getOption("-target","   Please specifiy target (" + defaultTargets.join(",") + ")");
				var file = src.resolveFile(t + ".mcover");

				if(file.exists)
					targets.push(file);
			}
			
		}

		return targets;
	}

	function initializeCoverage(targets:Array<File>):Array<Coverage>
	{
		var coverage:Array<Coverage> = [];
		for(target in targets)
		{
			var c = parseCoverageData(target);
			if (c == null)
				error("Invalid coverage data file. Unable to load " + target);

			coverage.push(c);
		}
		return coverage;
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