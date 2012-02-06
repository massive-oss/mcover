**MassiveCover (MCover) is a collection of macro based code quality tools.**



### How does it work?

MCover injects code at compile-time (using macros) to provide runtime tracking of code coverage and/or function entry/exit times. 


The code coverage tool is designed to integrate with existing unit testing frameworks to provide detailed metrics on test coverage.



Features
---------------------


### Code Coverage

MCover can provide detailed coverage of executed code, including:

* code blocks (statements)
* code branches

### Function logging

MCover can generate timing metrics around function entry/exit times, including:

* function start/exit time
* function duration (both inclusive and exclusive of nested methods)
* call stack depths


### Macros

MCover utilises Haxe macros to simplify enabling features on your existing code base

* Specify included classes by classpaths, packages and wildcard patterns
* Configure individual MCover features per compilation target


To enable mcover, you need to specify which tools to run, and what class paths to include

e.g.

	--macro m.cover.MCover.configure(true)
	--macro m.cover.MCover.include([''], ['src'])

### Cross Platform

MCover has been designed to work with any HaXe target. Officially we support the following:

*	ActionScript 2
*	ActionScript 3
*	JavaScript
*	Neko

**NOTE:** MCover requires Haxe 2.0.8

**NOTE:** The following documentation generally refers to the latest trunk builds. Refer to tagged versions for documentation pertaining to most recent official haxelib release (https://github.com/massiveinteractive/MassiveCover/tags) 




Code Coverage Features
---------------------

### Statement coverage

MCover tracks all statement code blocks {...} within your code.


	function test(value:Bool)
	{
		// statement block 1
		if(value)
		{
			// statement block 2
		}
		else
		{
			//statement block 3
		}
	}


### Branch coverage

For code branches with multiple scenarios e.g. (a||b), MCover will log branch results for each individual expression , i.e.:

	if(a || b)

	a = true, b = false;
	a = false, b = true;
	a = true, b = true;
	a = false, b = false; 



### Granular Reporting

MCover stores the contextual information around every statement and branch in order to provide detailed reporting and metrics, including:

*	Package, Class and Method level summaries


		COVERAGE BREAKDOWN BY CLASSES:

	              Result        Methods       Statements    Branches      Class         
	              100%          2/2           2/2           0/0           example.foo.Foo
	              90.48%        11/12         24/26         1/2           Main   
	                  

*	Detailed information on missing statements and branches


		NON-EXECUTED BRANCHES:

		              Main#branch | src/Main.hx:77: characters 10-11 | t

		NON-EXECUTED STATEMENTS:

		              Main#otherTypes | src/Main.hx:107: characters 3-9
		              Main#completionHandler | src/Main.hx:30: characters 2-18


*	Information on statement and branch execution frequency




Getting Started - Code Coverage
---------------------

### Step 1.

Install mcover:

	haxelib install mcover

### Step 2.

Add the mcover macro to your build.hxml file:

	-lib mcover
	--macro m.cover.MCover.configure()
	--macro m.cover.MCover.include('', ['src'])

### Step 3.

Print a report at runtime (once your tests/code have finished executing):

	var logger = MCover.getLogger();
	logger.report();

### Step 4.

View results!
	
	----------------------------------------------------------------
	MCover v1.0 Coverage Report, generated 2011-10-10 11:44:16
	----------------------------------------------------------------

	NON-EXECUTED BRANCHES:

	              Main#branch | src/Main.hx:77: characters 10-11 | t

	NON-EXECUTED STATEMENTS:

	              Main#otherTypes | src/Main.hx:107: characters 3-9
	              Main#completionHandler | src/Main.hx:30: characters 2-18

	COVERAGE BREAKDOWN BY CLASSES:

	              Result        Methods       Statements    Branches      Class         
	              100%          2/2           2/2           0/0           example.foo.Foo
	              100%          3/3           3/3           0/0           example.Example
	              90.48%        11/12         24/26         1/2           Main          
	              100%          1/1           1/1           0/0           InternalClass 

	COVERAGE BREAKDOWN BY PACKAGE:

	              Result        Files         Classes       Package       
	              90.91%        1/1           2/2           [Default]     
	              100%          1/1           1/1           example       
	              100%          1/1           1/1           example.foo   

	----------------------------------------------------------------

	OVERALL STATS SUMMARY:

	total packages      3 / 3               
	total files         3 / 3               
	total classes       4 / 4               
	total methods       17 / 18             
	total statements    30 / 32             
	total branches      1 / 2               

	----------------------------------------------------------------
	RESULT              92.59%              
	----------------------------------------------------------------


Integrating with MUnit
---------------------

MCover is now fully integrated with MUnit's rich HTML print client (MUnit 0.9.2.0 or higher)

**Note:** Inline coverage is only appended to test classes that have a matching class in the covered src path (e.g. com.ExampleTest will look for results for com.Example)

**Note:** You may need to update your munit project settings if updating from older version of munit

### Step 1. Add MCover macro to build

Specify the MCoverPrintClient when MUnit is including coverage (if upgrading from earlier version of munit):

In TestMain.new():

	#if MCOVER
		var client = new massive.mcover.munit.client.MCoverPrintClient();
	#else
		var client = new massive.munit.client.RichPrintClient();
	#end

	var runner:TestRunner = new TestRunner(client);	

### Step 2. Run munit

To test and run with MCover just add the '-coverage' flag

	munit test -coverage


### Step 3. Configure MCoverPrintClient

By default, the MCoverPrintClient includes all the coverage reports

*	missing blocks
*	class and package breakdowns
*	highest execution frequencies for statements/branches (defaults to top 25)
*	overall summaries and result

For JavaScript and Flash targets this is fine for munit's rich html output (as the contents of these reports are collapsable)

For Neko targets (or if using the basic MUnit PrintClient) this amount of information can be overwhelming.

To configure these settings use the follow properties when creating the client in TestMain:

	var client = new massive.mcover.munit.client.MCoverPrintClient();
	client.includeMissingBlocks = false;
	client.includeExecutionFrequency = false;
	client.includeClassAndPackageBreakdowns = false;
	...

By default MCoverPrintClient creates a default munit TestResultClient (RichPrintClient) and a default MCover CoverageReportClient (PrintClient) to work with:

You can also specify alternatives through the constructor:

	var munitClient = new massive.munit.client.PrintClient(false);
	
	var mcoverClient = new massive.mcover.client.PrintClient();
	mcoverClient.maxBlockExecutionListSize = 50;
	
	var client = new MCoverPrintClient(munitClient, mcoverClient);
	...


Usage
---------------------

### Compiler macros

MCover uses a couple of simple macros to enable individual features including code coverage and function logging.

To enable mcover, you need to specify which tools to run, and what class paths to include

e.g. Compiling for code coverage:

	--macro m.cover.MCover.configure(true)
	--macro m.cover.MCover.include([''], ['src'])


#### --macro m.cover.MCover.configure

The configure method defines which tools to compile for the current target

	--macro m.cover.MCover.configure({includeCoverage}, {includeLogging})

Where

*	**includeCoverage** is a bool indicating to include code coverage
*	**includeLogging** is a bool indicating to include function logging


For example, to only enable coverage:

	--macro m.cover.MCover.configure(true)

Or only logging:

	--macro m.cover.MCover.configure(false, true)



#### -macro m.cover.MCover.include

Specify the classpaths/packages to include in coverage

	--macro m.cover.MCover.include(['package.name'], ['src'])

MCover includes a macro for specifying which classes to cover in your application:

	--macro m.cover.MCover.include(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']

*	**classPaths** is an array of classpaths to include in coverage (e.g. ['src']). Default is local path - e.g ['']

*	**ignoredClasses** is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null.


Example:

	--macro m.cover.MCover.include(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms



### Runtime reporting

At runtime, MCover cam automatically log code execution blocks.

To generate a report call once your unit tests (or other code) have completed:

	var logger = MCover.getLogger();
	logger.report();

By default these are sent to a generic TraceClient that outputs to the screen.

You can set multiple custom clients (CoverageReportClient) if required:

	logger.addClient(new massive.mcover.client.PrintClient());



### Coverage Reports

The current output (see example above) provides a basic percentage breakdown of code blocks that have been executed. It also provides summaries for individual classes and packages within the class path:



Code Coverage
---------------------

### Overview

MCover reports coverage on code statements and branches

*	**Statement** coverage measures whether a block of code as been executed


		function foo()
		{
			//one or more lines of code in a statement block

		}


*	**Branch** coverage measures possible code branches where multiple scenarios are possible by recording the boolean result of each operator. In the example if(a||b), branch coverage will determine if 'a' and 'b' have been evaluated to both 'true' and 'false' during execution.


		e.g.
		function foo(a:Bool, b:Bool)
		{
			if(a||b)
			{
				//do someting
			}
		}

		foo(true, false);
		for(false, true);


*	**Method** coverage measures if one or more statements within a method was entered during execution.

*	**Class** coverage measures if one or more methods within a class (static or instance) was entered during execution.

*	**File** coverage measures if one or more classes within a file was entered during execution.

*	**Package** coverage measures if one or more files within a package was entered during execution.


### Coverage Percentage

MCover uses the same formula as Clover (Java Coverage tool) for calculating a coverage percentage

	TPC = (BT + BF + SC + MC)/(2*B + S + M)
 
where
 
	BT - branches that evaluated to "true" at least once
	BF - branches that evaluated to "false" at least once
	SC - statements covered
	MC - methods entered
	 

	B - total number of branches
	S - total number of statements
	M - total number of methods



### Current Implementation
	

MCover is still in development but it already covers most functional expressions including:

Currently supported statement blocks

*	class methods

*	if/else statements

*	switch case and default statements

*	for loop statements

*	while loop statements

*   try/catch statements

*	inline functions, arrays and objects (e.g. var o = {f:function(){var a = [1,2,3]}})


Currently supported branch scenarios

*	binary operations like a || b, a == b, a != b, a && b

*	comparisons like a == b, a < b, a <= b, a > b, a >= b

*	terniary operations like a = b ? c : d

*	if/else  conditions

*	switch case conditions (and default)

*	while conditions


Examples
---------------------

See the included example for a working test case

	/example

You can also run the unit tests (requires munit haxelib) to see coverage of the coverage classes :)


Advanced Usage
---------------------


### Customising PrintClient report output

You can customise the detail of reports generated by the default PrintClient

	var printClient = new PrintClient();
	printClient.includeMissingBlocks = true; //defaults to true;
	printClient.includeBlockExecutionCounts = true;//defaults to false;

*includeBlockExecutionCount* will include a list of all branches and statements sorted by highest to lowest frequency (how often they were executed). Defaults to false

*includeMissingBlocks* includes an list of all statements and branches that have not been executed at all (name, file, position). Defaults to true.


### Reporting during execution of a single test class

	logger.currentTest = "com.ExampleTest";

	logger.reportCurrentTest();


### Silent reporting

This can be useful for forcing the logger to update results without triggering clients to print out verbose reports
 
	logger.report(true);
	logger.reportCurrentTest(true);


Results can then be accessed directly from the logger

	logger.coverage.getResults();
	logger.coverage.getPercentages();


### Ignoring individual classes or methods

You can flag a method to be excluded from coverage using @IgnoreCover metadata
	
	class Foo
	{
		public function new()
		{
			
		}

		@IgnoreCover 
		function ignore()
		{
			
		}
	}
	
By default @IgnoreCover is not available for an entire class (due to a quirky bug with haxe.Context.getLocalClass). However you can try your luck if you add -D MCOVER_IGNORE_CLASS to your compilation instructions

