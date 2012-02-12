MassiveCover (MCover)
======================

MCover is a collection of cross platform code quality tools for Haxe that are injected into your code at compile-time (using macros) to provide runtime tracking of code coverage and/or function entry/exit times. 


To install mcover:

	haxelib install mcover


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

* Compile in a specific tool or tools
* Includ classes by classpaths, packages and wildcard patterns


To enable mcover, you need to specify which tools to run, and what class paths to include

e.g.

	--macro m.cover.MCover.coverage([''], ['src'])

### Cross Platform

MCover has been designed to work with any HaXe target. Officially we support the following:

*	ActionScript 2
*	ActionScript 3
*	JavaScript
*	Neko

**NOTE:** MCover requires Haxe 2.0.8

**NOTE:** The following documentation generally refers to the latest trunk builds. Refer to tagged versions for documentation pertaining to most recent official haxelib release (https://github.com/massiveinteractive/MassiveCover/tags) 




Code Coverage
---------------------

For detailed information see [Code Coverage](/doc/Coverage.md)

#### Compiler args

Add the following to your hxml file:

	-lib mcover
	--macro m.cover.MCover.coverage(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']
*	**classPaths** is an array of classpaths to include (e.g. ['src']). Default is local path - e.g ['']
*	**ignoredClasses** is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null.


Example:

	--macro m.cover.MCover.coverage(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms

#### Runtime report

Add the followng code to your application after code has executed:

	var logger = m.cover.coverage.MCoverage.getLogger();
	logger.report();



Function Logging
---------------------

For detailed information see [Function Logging](/doc/Logger.md)

#### Compiler args

Add the following to your hxml file:

	-lib mcover
	--macro m.cover.MCover.logger(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']
*	**classPaths** is an array of classpaths to include (e.g. ['src']). Default is local path - e.g ['']
*	**ignoredClasses** is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null.


Example:

	--macro m.cover.MCover.logger(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms


#### Runtime Usage

Add the followng code to your application to start recording

	var logger = m.cover.coverage.MCoverLogger.getLogger();
	logger.startRecording();

Add the followng code to your application to stop recording and print report

	var logger = m.cover.coverage.MCoverLogger.getLogger();
	logger.stopRecording();
	logger.report();


