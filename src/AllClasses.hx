package ;

import m.cover.MCover;
import mcover.coverage.client.EMMAPrintClient;
import mcover.coverage.client.PrintClient;
import mcover.coverage.client.TraceClient;
import mcover.coverage.CoverageException;
import mcover.coverage.CoverageLogger;
import mcover.coverage.CoverageReportClient;
import mcover.coverage.data.AbstractBlock;
import mcover.coverage.data.AbstractNode;
import mcover.coverage.data.AbstractNodeList;
import mcover.coverage.data.Branch;
import mcover.coverage.data.Clazz;
import mcover.coverage.data.Coverage;
import mcover.coverage.data.CoverageResult;
import mcover.coverage.data.DataUtil;
import mcover.coverage.data.File;
import mcover.coverage.data.Method;
import mcover.coverage.data.Package;
import mcover.coverage.data.Statement;
import mcover.coverage.DataTypes;
import mcover.coverage.macro.CoverageExpressionParser;
import mcover.coverage.macro.CoverageMacroDelegate;
import mcover.coverage.MCoverage;
import mcover.coverage.munit.client.MCoverPrintClient;
import mcover.coverage.munit.client.MCoverSummaryReportClient;
import mcover.Exception;
import mcover.logger.client.LoggerClient;
import mcover.logger.client.LoggerClientImpl;
import mcover.logger.data.Log;
import mcover.logger.data.LogRecording;
import mcover.logger.Logger;
import mcover.logger.LoggerException;
import mcover.logger.LoggerImpl;
import mcover.logger.macro.LoggerExpressionParser;
import mcover.logger.macro.LoggerMacroDelegate;
import mcover.logger.MCoverLogger;
import mcover.macro.ClassInfo;
import mcover.macro.ClassParser;
import mcover.macro.ClassPathFilter;
import mcover.macro.ExpressionParser;
import mcover.macro.FilteredClassCache;
import mcover.macro.MacroDelegate;
import mcover.macro.MacroUtil;
import mcover.MCover;
import mcover.util.NumberUtil;
import mcover.util.Timer;

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

