/****
* Copyright 2012 Massive Interactive. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*    1. Redistributions of source code must retain the above copyright notice, this list of
*       conditions and the following disclaimer.
* 
*    2. Redistributions in binary form must reproduce the above copyright notice, this list
*       of conditions and the following disclaimer in the documentation and/or other materials
*       provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MASSIVE INTERACTIVE OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Massive Interactive.
****/

package ;

import m.cover.AllClasses;
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
import massive.mcover.munit.client.MCoverPrintClient;

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

