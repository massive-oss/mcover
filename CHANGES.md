## 2.3.0

- Removed `EDisplayNew` which is now removed in Haxe 4.3
- Moved `haxelib.json` to the root of the repository, so that it can be added as a git haxelib dependency
- Replaced the deprecated `@:extern` metadata with the `extern` keyword

## 2.2.2

- LcovPrintClient improvements

## 2.2.1

- Support `eval`, `hl`, `java` targets

## 2.2.0

- Haxe 4 compatibility
- Fixed line number detection
- Skip unknown positions
- Add lcov print client

## 2.1.1

- fix: Issue #28 - support package with space at the end before ';'
- fix: Issue #29 - support class/package with single character name

## 2.1.0

- Fix: Support packages with underscore in their name
- Fix: paths on Windows: use regexp instead of splitting on :, because windows paths contain :
- Ported NodeJS timer support from MUnit repository
- Merge pull request #24 from nadako/master
- Fix: issue #31 - Compiler.keep not consistent in Haxe 3.1

v 2.0.3
- added haxelib.json

v 2.0.1
- added support for haxe3 RC
- removed dependency on mconsole

v 1.5.1
- hotfix for edge case with position file path not found using Context.resolvePath
- hotfix for excpetion thrown when creating temp directory on windows

v 1.5.0
- added better coverage handling/ support for macro generated functions/code blocks

v 1.4.2
- cache file naming causing issues on some platforms
- minor compatibility updates for building with haxe svn (2.11)

v 1.4.1
- updated edge case for detecting partial fragments using mpartial 1.1.0
- moved log/cache to .temp/mcover (was .mcover). Updated to use mconsole file printer for logs
- skips coverage for @:macro methods
- added support for @:ignore and @:ignoreCover metadata

v1.4.0 - 21.08.12
- all: issue #14 - changed top level package from m.cover to mcover to avoid conflicts with local vars called 'm'

v1.3.4 - 20.08.12

- all: updated macro regexp for Haxe 2.10
- all: fixed issue with classes inside of comments being added to include class list in Haxe 2.10
- all : removed some internal logging/traces
- added new tests for logger macro classes
- dev: added md5 hash cached classes file to ensure reset when rebuilding mcover from source
- dev: changed order of cp's in test file to prevent installed versions of mcover to take precedence over local source when running mcover's tests
- cpp/php : fixed edge case relating to issue #9

v1.3.3 - 17.08.12
- all: issue #12 - Line number missing from coverage block string output (if single line)
- all: fixed broken test for issue #10 (test shouldn't have been failing)
- php: missing ';' in import

v1.3.2 - ??
- cpp: issue #9 0% branch coverage prints -21474836.48% on cpp target
- all: issue #10 - Added ability to resume recording of filtered results when using CoverageLogger.currentTest

v1.3.1 - 27.07.12
- Added support for php target

v1.3.0 - 26.07.12
- Added support for cpp target

v1.2.5.2 - 29.06.12
- Hotfix for MCore partials on windows
- Removed examples from haxelib package (still on gitub)

v1.2.5.1 - 28.06.12
- Hotfix for MCore partials on windows

v1.2.5 - 27.06.12
- Minor bug fixes
- Added currentFileName to ClassParser
- Added support for edge cases for generated expressions where expr pos file differs from current file (prints warning rather than error)
- moved class info (like fileName, className, methodName, location) into separate ClassInfo class)

v1.2.4 - 30.05.12

- Added MCoverSummaryReportClient to leverage better CI support in munit 0.9.3.x
- Changed default ouput of MCoverPrintClient (only prints summary info by default)
- Switched hxml files broken by Haxe209 to bash scripts
- Updated documentation regarding MCoverSummaryReportClient

v1.2.3 - 24.05.12

- Fixed 'missing a return' compilation error when returns are located within if/else or switch statements

	function isTrue():Bool
	{
		if(true) return true
		else return false;
	}
- Fixed same issue above for anonymous functions inside of methods
- Added support for single line methods that dont use curly braces (yuck)

	function isTrue():Bool return true;

- changed missing entryLog in Logger.logExit() from an exception to a trace warning
- updated examples with above scenarios

v1.2.2
- Fixed minor bug on windows preventing code coverage from appearing against individual classes in munit print client

v1.2.1
- Added caching of filtered classes to improve compilation times
- Moved debug log (and caches) to local .mcover directory in project
- Added @IgnoreCover classes to Compiler.include ignore list
- Fixed critical bug on Windows introduced in last release

v1.2.0 - 28.02.12

- Added function logging macros
- Reinstated class level @IgnoreCoverage
- internal refactoring to leverage common macro code between coverage and logging packages
- Added better examples and documentation
- Fixed bug with relative/absolute class paths

v1.1.0 - 22.11.11

- Added support for MUnit RichPrintClient html output
- minor bug fixes

v1.0.1 - 11-10-2011

- Added support for filtered reports
- improved integration with MUnit
- increased coverage support

v1.0.0 - 11-10-2011

- Initial release to haxelib
- covers almost all types of code blocks and conditional branches in your code base
