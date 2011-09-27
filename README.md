### MassiveCover (MCover) is a cross-platform haXe code coverage framework.

It injects compile-time code (using macros) to provide runtime tracking of code coverage.

MCover can integrate with existing unit testing frameworks to provide detailed metrics on test coverage.

MCover is still in early development and is **subject to change**

**NOTE:** MCover requires Haxe 2.0.8


Usage
---------------------

### Compiler macro

Include the following macro in your hxml when compiling


	--macro mcover.MCover.include('{package}', {ignoredClasses}, {classPaths})

Where:

*	*package* is the package to filter on (e.g. 'com.example'). Use an empty string to include all packages ('')

*	*ignoredClasses* is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null

*	*classPaths* is an array of classpaths to include in coverage (e.g. ['src']). Default is null (only checks local path (''))


Example:

	--macro mcover.MCover.include('com.example', null, ['src'])

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms



### Runtime reporting

At runtime, MCover will automatically log code execution blocks to MCoverRunner.

Once your unit tests (or other code) has completed executing, call MCoverRunner.printResults() to generate code coverage metrics:

	var result:String = mcover.MCoverRunner.printResults();

The current output provides a basic percentage breakdown of code blocks that have been executed:

	MCover COVERAGE: 75% (12/16 code blocks executed)


To also include  a list of all missing code blocks in the report, set VERBOSE_OUTPUT to true; 

	mcover.MCoverRunner.VERBOSE_OUTPUT = true;




Coverage
---------------------

MCover is still in development and currently covers the following code block types (more will be added shortly)

*	class instance methods (not static methods)

*	if/else blocks

*	switch statements



Example
---------------------

See the example in /example for a working test case
