MCover Code Coverage
======================

MCover code coverage provides detailed metrics on what parts of your code have been executed at run time, including:

* code blocks (statements)
* code branches

The code coverage tool is designed to integrate with existing unit testing frameworks to provide detailed metrics on test coverage.

________________

#### On this page:

* Features
* Quick start guide
* Integrating with MUnit
* How Coverage is Calculated
* Examples
* Advanced usage

Features
--------------------

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


* High level summary


		OVERALL COVERAGE STATS:

		    packages    71.43%     5 / 7      
		    files       86.36%     19 / 22    
		    classes     86.36%     19 / 22    
		    methods     92.21%     142 / 154  
		    statements  93.04%     254 / 273  
		    branches    84.67%     116 / 137  
		    lines       92.49%     1195 / 1292

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


Getting Started
---------------------

### Step 1.

Install mcover:

	haxelib install mcover

### Step 2.

Add the mcover macro to your build.hxml file:

	-lib mcover
	--macro mcover.MCover.configure()
	--macro mcover.MCover.include('', ['src'])

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

    packages    71.43%     5 / 7      
    files       86.36%     19 / 22    
    classes     86.36%     19 / 22    
    methods     92.21%     142 / 154  
    statements  93.04%     254 / 273  
    branches    84.67%     116 / 137  
    lines       92.49%     1195 / 1292

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
This includes the primary print client, as well as the http summary client for CI integration (updated MCover 1.2.4, MUnit 0.9.3.x)

In TestMain.new():

	#if MCOVER
		var client = new mcover.coverage.munit.client.MCoverPrintClient();
		var httpClient = new HTTPClient(new mcover.coverage.munit.client.MCoverSummaryReportClient());
	#else
		var client = new RichPrintClient();
		var httpClient = new HTTPClient(new SummaryReportClient());
	#end

	var runner:TestRunner = new TestRunner(client);	
	runner.addResultClient(httpClient);

### Step 2. Run munit

To test and run with MCover just add the '-coverage' flag

	munit test -coverage


### Step 3. Configure MCoverPrintClient

By default, the MCoverPrintClient includes detailed coverage reports (except on Neko - see below). This includes:

*	missing blocks
*	class and package breakdowns
*	highest execution frequencies for statements/branches (defaults to top 25)
*	overall summaries and result

For JavaScript and Flash targets this is fine for munit's rich html output (as the contents of these reports are collapsable)

For Neko targets (or when using the basic MUnit PrintClient) only the summary information is enabled by default as the full report information can be overwhelming on the console.


To configure these settings on any target, use the follow properties when creating the client in TestMain:

	var client = new mcover.coverage.munit.client.MCoverPrintClient();
	client.includeMissingBlocks = true|false;
	client.includeExecutionFrequency = true|false;
	client.includeClassAndPackageBreakdowns = true|false;
	...

By default MCoverPrintClient creates a default munit TestResultClient (RichPrintClient) and a default MCover CoverageReportClient (PrintClient) to work with:

You can also specify alternatives through the constructor:

	var munitClient = new massive.munit.client.PrintClient(false);
	
	var mcoverClient = new mcover.coverage.client.PrintClient();
	mcoverClient.maxBlockExecutionListSize = 50;
	
	var client = new MCoverPrintClient(munitClient, mcoverClient);
	...


### Step 4. Accessing Coverage Reports on CI environment (or file system)

The MCoverSummaryReportClient (MCover 1.2.4+) appends summary coverage information to the generated summary.txt file per target.

It is added to the TestMain test runner via an HTTPClient


	var httpClient = new HTTPClient(new mcover.coverage.munit.client.MCoverSummaryReportClient());
	...
	runner.addResultClient(httpClient);


MUnit will save the contents of this summary to the local file system (located in your project's munit report directory

E.g.
	
	{reportDirectory}/test/summary/js/summary.txt

Example output:

	#test results
	result:true
	count:266
	pass:266
	fail:0
	error:0
	ignore:0
	time:5.746999979019165

	#coverage:percent,count/total
	coverage:95.02%
	packages:71.43%,5/7
	files:86.36%,19/22
	classes:86.36%,19/22
	methods:93.51%,144/154
	statements:95.24%,260/273
	branches:93.48%,129/138
	lines:96.06%,1244/1295



How Coverage is Calculated
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



### Coverage Support Implementation
	

Statement blocks:

*	class methods

*	if/else statements

*	switch case and default statements

*	for loop statements

*	while loop statements

*   try/catch statements

*	inline functions, arrays and objects (e.g. var o = {f:function(){var a = [1,2,3]}})


Branch scenarios

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

## Macro options

MCover includes a macro for specifying which classes to cover in your application:

	--macro mcover.MCover.cover(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']

*	**classPaths** is an array of classpaths to include in coverage (e.g. ['src']). Default is local path - e.g ['']

*	**ignoredClasses** is an array of specific classes or patterns to ignore (e,g, ['com.example.IgnoredClass', 'com.foo.*']). Default is null.


Example:

	--macro mcover.MCover.include(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms


### Disable caching

By default MCover macro caches the filtered list of classes that will be covered.

To disable this, add MCOVER_NO_CACHE variable to the hxml file

	-D MCOVER_NO_CACHE

To manually delete a cache, delete the .mcover folder in your project


## Custom Report Clients

At runtime, MCover cam automatically log code execution blocks.

To generate a report call once your unit tests (or other code) have completed:

	var logger = MCover.getLogger();
	logger.report();

By default these are sent to a generic TraceClient that outputs to the screen.

You can set multiple custom clients (CoverageReportClient) if required:

	logger.addClient(new mcover.coverage.client.PrintClient());


The current output (see example above) provides a basic percentage breakdown of code blocks that have been executed. It also provides summaries for individual classes and packages within the class path:



### Configuring PrintClient

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


## Ignoring individual classes or methods via metadata

You can flag an entire class, or single method to be excluded from coverage using @IgnoreCover metadata

Ignoring a class:

	@IgnoreCover 
	class Foo
	{
		public function new()
		{
			
		}

		
		function bar()
		{
			
		}
	}

Ignoring a method:

	class Foo
	{
		public function new()
		{
			
		}

		@IgnoreCover 
		function bar()
		{
			
		}
	}





