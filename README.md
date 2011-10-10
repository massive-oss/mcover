### MassiveCover (MCover) is a cross-platform haXe code coverage framework.

It injects compile-time code (using macros) to provide runtime tracking of code coverage.

MCover can integrate with existing unit testing frameworks to provide detailed metrics on test coverage.

MCover is still in early development and is **subject to change**

**NOTE:** MCover requires Haxe 2.0.8


Usage
---------------------

### Compiler macro

Include the following macro in your hxml when compiling


	--macro massive.mcover.MCover.include('{package}', {classPaths}, {ignoredClasses})

Where:

*	*package* is the package to filter on (e.g. 'com.example'). Use an empty string to include all packages ('')

*	*classPaths* is an array of classpaths to include in coverage (e.g. ['src']). Default is null (only checks local path (''))

*	*ignoredClasses* is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null


Example:

	--macro massive.mcover.MCover.include('com.example', ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms



### Basic Usage

#### Step 1. 
At runtime, MCover cam automatically log code execution blocks.

To capture coverage initialize a coverage runner (MCoverRunner):

	var runner = massive.mcover.MCover.createRunner();

#### Step 2. 
To generate the results call MCoverRunner.report() once your unit tests (or other code) have completed:

	runner.report();

By default these are sent to a generic TraceClient that outputs to the screen.

You can set multiple custom clients if required:

	runner.addClient(new massive.mcover.client.PrintClient());


### Coverage Reports

The current output provides a basic percentage breakdown of code blocks that have been executed. It also provides summaries for individual classes and packages within the class path:

	----------------------------------------------------------------
	MCover v0.4 Coverage Report, generated 2011-10-10 11:39:59
	----------------------------------------------------------------

	NON-EXECUTED BRANCHES:

	              None          

	NON-EXECUTED STATEMENTS:

	              None          

	COVERAGE BREAKDOWN BY CLASSES:

	              Result        Methods       Statements    Branches      Class         
	              100%          10/10         16/16         0/0           massive.mcover.MCoverRunnerImpl
	              100%          5/5           10/10         0/0           massive.mcover.MCover
	              100%          3/3           4/4           0/0           massive.mcover.MCoverException
	              100%          2/2           2/2           0/0           massive.mcover.client.TraceClient
	              100%          11/11         35/35         0/0           massive.mcover.client.PrintClient
	              100%          19/19         23/23         2/2           massive.mcover.data.AllClasses
	              100%          6/6           7/7           0/0           massive.mcover.data.Branch
	              100%          5/5           5/5           0/0           massive.mcover.data.AbstractBlock
	              100%          2/2           2/2           0/0           massive.mcover.data.Clazz
	              100%          11/11         17/17         6/6           massive.mcover.data.AbstractNodeList
	              100%          12/12         17/17         6/6           massive.mcover.data.Method
	              100%          4/4           4/4           0/0           massive.mcover.data.Statement
	              100%          3/3           5/5           0/0           massive.mcover.data.File
	              100%          11/11         12/12         2/2           massive.mcover.data.AbstractNode
	              100%          2/2           2/2           0/0           massive.mcover.data.Package

	COVERAGE BREAKDOWN BY PACKAGE:

	              Result        Files         Classes       Package       
	              100%          10/10         10/10         massive.mcover.data
	              100%          2/2           2/2           massive.mcover.client
	              100%          3/3           3/3           massive.mcover

	----------------------------------------------------------------

	OVERALL STATS SUMMARY:

	total packages      3 / 3               
	total files         15 / 15             
	total classes       15 / 15             
	total methods       106 / 106           
	total statements    161 / 161           
	total branches      16 / 16             

	----------------------------------------------------------------
	RESULT              100%                
	----------------------------------------------------------------



Coverage
---------------------

### Overview

MCover reports coverage on code statements and branches

*	*Statement* coverage measures whether a block of code as been executrd


	function foo()
	{
		//one or more lines of code in a statement block

	}


*	*Branch* coverage measures possible code branches where multiple scenarios are possible by recording the boolean result of each operator. In the example if(a||b), branch coverage will determine if 'a' and 'b' have been evaluated to both 'true' and 'false' during execution.


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


*	*Method* coverage measures if one or more statements within a method was entered during execution.

*	*Class* coverage measures if one or more methods within a class (static or instance) was entered during execution.

*	*File* coverage measures if one or more classes within a file was entered during execution.

*	*Package* coverage measures if one or more files within a file was entered during execution.


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

*	if/else blocks

*	switch statements

*	for loops

*	while loops

*   try/catch

*	terniary ops

*	inline functions, arrays and objects (e.g. var o = {f:function(){var a = [1,2,3]}})


Currently supported branch scenarios

*	a || b


Examples
---------------------

See the included example for a working test case

	/example

You can also run the unit tests (requires munit haxelib) to see coverage of the coverage classes :)


Advanced Usage
---------------------

#### Setting a custom runner

You can specify a custom runner by passing through a class that implements MCoverRunner. By default an instance of MCoverRunnerImp is created.

	massive.mcover.MCover.createRunner(MCoverRunnerImpl);

#### Ignoring individual classes or methods

You can flag a class or method to be excluded from coverage using @IgnoreCover metadata
	
	@IgnoreCover class Foo
	{
		public function new()
		{
			
		}
	}

Or

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
	


