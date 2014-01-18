import massive.munit.TestSuite;

import example.AccountTest;
import example.CalculatorTest;
import ExampleTest;

/**
 	Auto generated Test Suite for MassiveUnit.
 	Refer to munit command line tool for more information (haxelib run munit)
**/

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(example.AccountTest);
		add(example.CalculatorTest);
		add(ExampleTest);
	}
}
