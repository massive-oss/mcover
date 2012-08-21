MCover Function Logging
======================


MCover logger provides detailed metrics on runtime execution of methods, including:

* function start and end time
* function duration (including and excluding nested function times)

Reports

* high level stats (total logs, max call stack depths, etc)
* execution times (longest execution time
* execution frequency (executed most often)
* detailed function stack logs

*Note:* MCover logger only provides basic trace reports at this stage. 


Basic Usage
--------------------

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

	var logger = mcover.logger.MCoverLogger.getLogger();
	logger.startRecording();

Add the followng code to your application to stop recording and print report

	var logger = mcover.logger.MCoverLogger.getLogger();
	logger.stopRecording();
	logger.report();


Features
--------------------

### Code injection

MCover logger injects code around the entry and exit points within every method

	function foo(value:Bool)
	{
		// log entry
		if(value == false)
		{
			// log exit
			throw "Error";
		}
		else
		{
			// log exit
			return value;
		}
	}


In order to maintain high acuracy, function exits are modified to ensure that expressions are evaluated prior to logging the exit. 

Original code:

	return foo();

Modified code:

	var ___m1 = foo();
	logExit();
	return ___m1;

###Function Logs

Each method that executes generates a log containing metadata relating to the entry and exit times/locations within the function

Because uncaught exceptions bypass normal function exits, each exit log has a reference to it's corresponding entry log. This ensures that  

	var _mloggerId = logEntry();
	....

	logExit(_mloggerId);

###Recording

Developer can specify when to start and stop recording log information

	logger.startRecording();

	//... do something

	logger.stopRecording();

### Reporting

Once a recording has started (or has been stopped), a report can be generated via the logger

	logger.report();


The current reportClient outputs several high level summaries of activity

* execution times (longest execution time
* execution frequency (executed most often)
* summary of total calls, max call stack depth, etc

The current reportClient also outputs the full function stack trace that was recorded


