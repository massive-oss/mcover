package mcover.cli.report;

import massive.neko.io.File;
import mcover.coverage.DataTypes;
import mcover.cli.report.CoverageReport;

class RawCoverageReport extends CoverageReportBase
{
	var outputDir:File;
	var classPaths:Array<File>;
	

	public function new(outputDir:File, classPaths:Array<File>)
	{
		super();
		this.outputDir = outputDir;
		this.classPaths = classPaths;
	}

	function resoveFilePath(path:String):String
	{
		for(cp in classPaths)
		{
			var file = cp.resolveFile(path);
			if(file.exists)
			{
				return Std.string(file);
			}
		}

		return path;
	}

	override public function report(coverage:Coverage):Void
	{
		super.report(coverage);

		var buf = new StringBuf();

		buf.add("{");

		var first = true;

		for (cls in coverage.getClasses())
		{
			if (cls.getPercentage() == 100) continue;

			var statements = cls.getMissingStatements();
			if (statements.length > 0)
			{
				for(block in statements)
				{
					var str = serializeBlock(block, null);

					if(first)
					{
						first = false;
						buf.add("\n\t" + str);
					}
					else
					{
						buf.add(",\n\t" + str);
					}
				}
			}

			var branches = cls.getMissingBranches();

			if (branches.length > 0)
			{
				for(block in branches)
				{
					var mode:String = null;
					if(block.isPartiallyCovered())
					{
						if(block.trueCount == 0) mode = "t";
						else mode = "f";
					}

					var str = serializeBlock(block, mode);
					

					if(first)
					{
						first = false;
						buf.add("\n\t" + str);
					}
					else
					{
						buf.add(",\n\t" + str);
					}
					 
				}
			}
		}

		buf.add("\n}");

		trace(buf.toString());
	}

	function serializeBlock(block:AbstractBlock, ?branch:String=null):String
	{

		var reg = ~/(.*):([0-9]*): (chars|lines) ([0-9-]*)/;

		if(!reg.match(block.location)) return null;


		var s = "{\"file\":\"" + reg.matched(1) + "\"";

		if(reg.matched(3) == "lines")
		{
			s += ", \"lines\":\"" + reg.matched(4) + "\"";
		}
		else
		{
			s += ", \"lines\":\"" + reg.matched(2) + "\"";
			s += ", \"chars\":\"" + reg.matched(4) + "\"";
					
		}

		if(branch != null)
			s += ", \"branch\":" + branch;

		s += " }";

		return s;
	}
}
