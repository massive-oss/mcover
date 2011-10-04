import massive.munit.TestSuite;

import massive.mcover.data.AbstractBlockTest;
import massive.mcover.data.AbstractNodeListTest;
import massive.mcover.data.AbstractNodeTest;
import massive.mcover.data.BranchTest;
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
		add(massive.mcover.data.BranchTest);
		add(massive.mcover.data.StatementTest);
	}
}
