package mcover.cli.report;

import mcover.coverage.DataTypes;
import mcover.cli.report.CoverageReport;

class BasicCoverageReport extends CoverageReportBase
{
	public function new()
	{
		super();
	}

	override public function report(coverage:Coverage):Void
	{
		super.report(coverage);

		print("COVERAGE: " + coverage.getPercentage() + "%");

		for (cls in coverage.getClasses())
		{
			print("  " + cls.name + " : " + cls.getPercentage() + "%");

			if (cls.getPercentage() == 100) continue;

			var statements = cls.getMissingStatements();

			if (statements.length > 0)
			{
				print("    statements:");
				for(statement in statements)
				{
					print("      " + statement);
				}
			}

			var branches = cls.getMissingBranches();

			if (branches.length > 0)
			{
				print("    branchs:");
				for(branch in branches)
				{
					print("      " + branch);
				}
			}
		}
	}
	function print(message:String)
	{
		Sys.println(message);
	}
}
