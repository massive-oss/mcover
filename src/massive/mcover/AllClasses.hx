package massive.mcover;

import massive.mcover.client.PrintClient;
import massive.mcover.client.TraceClient;
import massive.mcover.CoverageLogger;
import massive.mcover.CoverageReportClient;
import massive.mcover.data.AbstractBlock;
import massive.mcover.data.AbstractNode;
import massive.mcover.data.AbstractNodeList;
import massive.mcover.data.Branch;
import massive.mcover.data.Clazz;
import massive.mcover.data.Coverage;
import massive.mcover.data.CoverageResult;
import massive.mcover.data.File;
import massive.mcover.data.Method;
import massive.mcover.data.Package;
import massive.mcover.data.Statement;
import massive.mcover.Exception;
import massive.mcover.macro.CoverClassMacro;
import massive.mcover.MCover;
import massive.mcover.munit.client.HtmlPrintClient;
import massive.mcover.munit.client.HtmlPrinter;
import massive.mcover.munit.client.MCoverPrintClient;
import massive.mcover.util.Timer;

class AllClasses
{
	public static function main():AllClasses {return new AllClasses();}
	public function new(){trace('This is a generated main class');}
}

