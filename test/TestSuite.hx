import massive.munit.TestSuite;

import ExampleTest;
import massive.mcover.client.CoverageReportClientTest;
import massive.mcover.client.EMMAPrintClientTest;
import massive.mcover.client.PrintClientTest;
import massive.mcover.CoverageLoggerImplTest;
import massive.mcover.CoverageLoggerTest;
import massive.mcover.data.AbstractBlockTest;
import massive.mcover.data.AbstractNodeListTest;
import massive.mcover.data.AbstractNodeTest;
import massive.mcover.data.BranchTest;
import massive.mcover.data.ClazzTest;
import massive.mcover.data.CoverageTest;
import massive.mcover.data.DataUtilTest;
import massive.mcover.data.FileTest;
import massive.mcover.data.MethodTest;
import massive.mcover.data.PackageTest;
import massive.mcover.data.StatementTest;
import massive.mcover.ExceptionTest;
import massive.mcover.MCoverTest;
import massive.mcover.munit.client.MCoverPrintClientTest;
import massive.mcover.util.TimerTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(massive.mcover.client.CoverageReportClientTest);
		add(massive.mcover.client.EMMAPrintClientTest);
		add(massive.mcover.client.PrintClientTest);
		add(massive.mcover.CoverageLoggerImplTest);
		add(massive.mcover.CoverageLoggerTest);
		add(massive.mcover.data.AbstractBlockTest);
		add(massive.mcover.data.AbstractNodeListTest);
		add(massive.mcover.data.AbstractNodeTest);
		add(massive.mcover.data.BranchTest);
		add(massive.mcover.data.ClazzTest);
		add(massive.mcover.data.CoverageTest);
		add(massive.mcover.data.DataUtilTest);
		add(massive.mcover.data.FileTest);
		add(massive.mcover.data.MethodTest);
		add(massive.mcover.data.PackageTest);
		add(massive.mcover.data.StatementTest);
		add(massive.mcover.ExceptionTest);
		add(massive.mcover.MCoverTest);
		add(massive.mcover.munit.client.MCoverPrintClientTest);
		add(massive.mcover.util.TimerTest);
	}
}
