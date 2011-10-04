import massive.munit.TestSuite;

import massive.mcover.data.AbstractBlockTest;
import massive.mcover.data.AbstractNodeListTest;
import massive.mcover.data.AbstractNodeTest;
import massive.mcover.data.AllClassesTest;
import massive.mcover.data.BranchTest;
import massive.mcover.data.ClazzTest;
import massive.mcover.data.FileTest;
import massive.mcover.data.MethodTest;
import massive.mcover.data.PackageTest;
import massive.mcover.data.StatementTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(massive.mcover.data.AbstractBlockTest);
		add(massive.mcover.data.AbstractNodeListTest);
		add(massive.mcover.data.AbstractNodeTest);
		add(massive.mcover.data.AllClassesTest);
		add(massive.mcover.data.BranchTest);
		add(massive.mcover.data.ClazzTest);
		add(massive.mcover.data.FileTest);
		add(massive.mcover.data.MethodTest);
		add(massive.mcover.data.PackageTest);
		add(massive.mcover.data.StatementTest);
	}
}
