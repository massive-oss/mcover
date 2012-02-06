package m.cover;

import m.cover.coverage.client.EMMAPrintClient;
import m.cover.coverage.client.PrintClient;
import m.cover.coverage.client.TraceClient;
import m.cover.coverage.CoverageException;
import m.cover.coverage.CoverageLogger;
import m.cover.coverage.CoverageMacro;
import m.cover.coverage.CoverageReportClient;
import m.cover.coverage.data.AbstractBlock;
import m.cover.coverage.data.AbstractNode;
import m.cover.coverage.data.AbstractNodeList;
import m.cover.coverage.data.Branch;
import m.cover.coverage.data.Clazz;
import m.cover.coverage.data.Coverage;
import m.cover.coverage.data.CoverageResult;
import m.cover.coverage.data.DataUtil;
import m.cover.coverage.data.File;
import m.cover.coverage.data.Line;
import m.cover.coverage.data.Method;
import m.cover.coverage.data.Package;
import m.cover.coverage.data.Statement;
import m.cover.coverage.DataTypes;
import m.cover.coverage.macro.CoverageBuildMacro;
import m.cover.coverage.MCoverage;
import m.cover.coverage.munit.client.MCoverPrintClient;
import m.cover.coverage.util.Timer;
import m.cover.Exception;
import m.cover.logger.client.LogClient;
import m.cover.logger.client.LogClientImpl;
import m.cover.logger.data.Log;
import m.cover.logger.data.LogRecording;
import m.cover.logger.LogException;
import m.cover.logger.Logger;
import m.cover.logger.LoggerImpl;
import m.cover.logger.LoggerMacro;
import m.cover.logger.macro.LoggerBuildMacro;
import m.cover.logger.MLogger;
import m.cover.logger.Utils;
import m.cover.macro.BuildMacro;
import m.cover.macro.BuildMacroParser;
import m.cover.macro.IncludeMacro;
import m.cover.macro.MacroUtil;
import m.cover.macro.PackageHelper;
import m.cover.MCover;

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

