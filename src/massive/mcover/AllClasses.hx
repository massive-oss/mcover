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

package massive.mcover;

import massive.mcover.client.EMMAPrintClient;
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
import massive.mcover.data.DataUtil;
import massive.mcover.data.File;
import massive.mcover.data.Line;
import massive.mcover.data.Method;
import massive.mcover.data.Package;
import massive.mcover.data.Statement;
import massive.mcover.Exception;
import massive.mcover.macro.CoverClassMacro;
import massive.mcover.MCover;
import massive.mcover.munit.client.MCoverPrintClient;
import massive.mcover.util.Timer;

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

