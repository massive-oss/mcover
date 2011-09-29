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

	massive.mcover.MCover.createRunner();

#### Step 2. 
To generate the results call the static report method once your unit tests (or other code) have completed:

	massive.mcover.MCover.report();

By default these are sent to a generic TraceClient that outputs to the screen.

You can set multiple custom clients if required:

	massive.mcover.MCover.addClient(new massive.mcover.client.PrintClient());


### Coverage Reports

The current output provides a basic percentage breakdown of code blocks that have been executed. It also provides summaries for individual classes and packages within the class path:

	
	MCover v0 Coverage Report, generated 2011-09-29 14:39:35
	----------------------------------------------------------------

	MISSING CODE BLOCKS:

	          src/Main.hx:64: characters 3-9

	COVERAGE BREAKDOWN BY CLASSES:

	          result    blocks    class     
	          92%       12/13     Main      
	          100%      1/1       InternalClass
	          100%      4/4       example.Example
	          100%      2/2       example.foo.Foo

	COVERAGE BREAKDOWN BY PACKAGE:

	          result    blocks    package   
	          93%       13/14     [default] 
	          100%      4/4       example   
	          100%      2/2       example.foo

	----------------------------------------------------------------

	OVERALL STATS SUMMARY:

	total packages      3                   
	total classes       4                   
	total blocks        19                  

	RESULT              95%                 

	----------------------------------------------------------------



Coverage
---------------------

MCover is still in development and currently covers the following code block types (more will be added shortly)

*	class methods

*	if/else blocks

*	switch statements


Examples
---------------------

See the included example for a working test case

	/example

You can also run the unit tests (requires munit haxelib) to see coverage of the coverage classes :)


Advanced Usage
---------------------

#### Setting a custom runner

You can specify a custom runner by passing through an instance that implements MCoverRunner. By default an instance of MCoverRunnerImp is created.

	massive.mcover.MCover.createRunner(new MCoverRunnerImp());

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
	


