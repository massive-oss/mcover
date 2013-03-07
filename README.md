MCover is a collection of macro based cross-platform code coverage and quality tools. MCover runs on all main Haxe targets including js, flash, neko, cpp and php.

To install mcover:

	haxelib install mcover


MCover supports Haxe 2.10 and Haxe 3

Features
---------------------

### Code Coverage

MCover can provide detailed coverage of executed code, including:

* code blocks (statements)
* code branches

Example macro usage:

	--macro mcover.MCover.coverage([''], ['src'])

### Function logging

MCover can generate timing metrics around function entry/exit times, including:

* function start/exit time
* function duration (both inclusive and exclusive of nested methods)
* call stack depths

Example macro usage:

	--macro mcover.MCover.logger([''], ['src'])


### Cross Platform

MCover has been designed to work with any Haxe target. Officially we support the following:

*	ActionScript
*	JavaScript
*	Neko
*	CPP
*	PHP


Code Coverage
---------------------

For detailed information see src/m/cover/coverage/README.md

#### Compiler args

Add the following to your hxml file:

	-lib mcover
	--macro mcover.MCover.coverage(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']
*	**classPaths** is an array of classpaths to include (e.g. ['src']). Default is local path - e.g ['']
*	**ignoredClasses** is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null.


Example:

	--macro mcover.MCover.coverage(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms

#### Runtime report

Add the followng code to your application after code has executed:

	var logger = mcover.coverage.MCoverage.getLogger();
	logger.report();



Function Logging
---------------------
For detailed information see src/m/cover/logger/README.md

#### Compiler args

Add the following to your hxml file:

	-lib mcover
	--macro mcover.MCover.logger(['{package}'], {classPaths}, {ignoredClasses})

Where:

*	**package** is an array of packages to filter on (e.g. 'com.example'). Default is all packages - e.g. ['']
*	**classPaths** is an array of classpaths to include (e.g. ['src']). Default is local path - e.g ['']
*	**ignoredClasses** is an array of specific classes to ignore (e,g, ['com.example.IgnoredClass']). Default is null.


Example:

	--macro mcover.MCover.logger(['com.example'], ['src'], null)

Note: Only use single quotation marks (' ') to avoid compiler issues on windows platforms


#### Runtime Usage

Add the followng code to your application to start recording

	var logger = mcover.coverage.MCoverLogger.getLogger();
	logger.startRecording();

Add the followng code to your application to stop recording and print report

	var logger = mcover.coverage.MCoverLogger.getLogger();
	logger.stopRecording();
	logger.report();




Changes
----------

See CHANGES for full changes

### New since 2.0.0

* Haxe 3 support, includes some breaking changes to APIs to better align with Haxe 3
* Updated for Munit 2.0
* Removed support for Haxe 2.08 and 2.09

### New since 1.5.x

* Improved handling of macro generated code blocks

### New since 1.4.x

* Changed top level package from `m.cover` to `mcover`

### New since 1.3.x

* Added cpp target support
* Added php target support
* Updated for Haxe 2.10

### New since 1.2.x

* Added function logging macro



Building from source
--------------

OSX: Use the build.sh bash script (osx only)
Windows: Manually run steps within build.sh

> Note: Make sure to set the dev path of mcover to /src before running tests (it's a bit tricky running code coverage on itself!)
