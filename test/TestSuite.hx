import massive.munit.TestSuite;

import mcover.logger.LoggerExceptionTest;
import mcover.logger.data.LogRecordingTest;
import mcover.logger.data.LogTest;
import mcover.util.TimerTest;
import mcover.ExceptionTest;
import mcover.macro.ClassInfoTest;
import mcover.coverage.CoverageExceptionTest;
import mcover.coverage.MCoverageTest;
import mcover.coverage.munit.client.MCoverPrintClientTest;
import mcover.coverage.CoverageLoggerTest;
import mcover.coverage.CoverageLoggerImplTest;
import mcover.coverage.data.CoverageTest;
import mcover.coverage.data.ClazzTest;
import mcover.coverage.data.BranchTest;
import mcover.coverage.data.AbstractNodeListTest;
import mcover.coverage.data.StatementTest;
import mcover.coverage.data.MethodTest;
import mcover.coverage.data.AbstractBlockTest;
import mcover.coverage.data.FileTest;
import mcover.coverage.data.PackageTest;
import mcover.coverage.data.AbstractNodeTest;
import mcover.coverage.data.DataUtilTest;
import mcover.coverage.client.CoverageReportClientTest;
import mcover.coverage.client.PrintClientTest;
import mcover.coverage.client.EMMAPrintClientTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(mcover.logger.LoggerExceptionTest);
		add(mcover.logger.data.LogRecordingTest);
		add(mcover.logger.data.LogTest);
		add(mcover.util.TimerTest);
		add(mcover.ExceptionTest);
		add(mcover.macro.ClassInfoTest);
		add(mcover.coverage.CoverageExceptionTest);
		add(mcover.coverage.MCoverageTest);
		add(mcover.coverage.munit.client.MCoverPrintClientTest);
		add(mcover.coverage.CoverageLoggerTest);
		add(mcover.coverage.CoverageLoggerImplTest);
		add(mcover.coverage.data.CoverageTest);
		add(mcover.coverage.data.ClazzTest);
		add(mcover.coverage.data.BranchTest);
		add(mcover.coverage.data.AbstractNodeListTest);
		add(mcover.coverage.data.StatementTest);
		add(mcover.coverage.data.MethodTest);
		add(mcover.coverage.data.AbstractBlockTest);
		add(mcover.coverage.data.FileTest);
		add(mcover.coverage.data.PackageTest);
		add(mcover.coverage.data.AbstractNodeTest);
		add(mcover.coverage.data.DataUtilTest);
		add(mcover.coverage.client.CoverageReportClientTest);
		add(mcover.coverage.client.PrintClientTest);
		add(mcover.coverage.client.EMMAPrintClientTest);
	}
}
