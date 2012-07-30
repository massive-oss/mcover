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
* THIS SOFTWARE IS PROVIDED BY MASSIVE INTERACTIVE "AS IS" AND ANY EXPRESS OR IMPLIED
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
* 
****/

package mcover.cli;

import massive.haxe.log.Log;
import massive.haxe.util.TemplateUtil;
import massive.neko.cmd.CommandLineRunner;
import massive.neko.cmd.Console;
import massive.neko.cmd.ICommand;
import massive.neko.haxelib.Haxelib;
import massive.neko.io.File;

import mcover.cli.cmd.MCoverCommand;
import mcover.cli.cmd.ReportCommand;


class MCoverCLI extends CommandLineRunner
{
	static public function main():MCoverCLI{return new MCoverCLI();}
	
	var version:String;

	public function new():Void
	{
		super();
		
		mapCommand(ReportCommand, "report", ["r"], "Generate a standlaone report from a raw mcover data file", TemplateUtil.getTemplate("help_report"));
		version = getVersion();
		run();
	}
	
	
	override function createCommandInstance(commandClass:Class<ICommand>):ICommand
	{
		var command:ICommand = super.createCommandInstance(commandClass);
		
		var cmd:MCoverCommand = cast(command, MCoverCommand);
		
		return cmd;
	}


	override public function printHeader():Void
	{	
		print("Massive Cover - Copyright " + Date.now().getFullYear() + " Massive Interactive. Version " + version);
	}
	
	override public function printUsage():Void
	{
		print("Usage: mcover [command] [options]");
	}

	function getVersion():String
	{
		if (version == null)
		{
			var versionPath:String = console.originalDir.name;
			var a:Array<String> = versionPath.split(",");
			version = a.join(".");
		}

		return version;
	}
	
}