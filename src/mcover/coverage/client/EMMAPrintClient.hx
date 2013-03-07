/****
* Copyright 2013 Massive Interactive. All rights reserved.
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

package mcover.coverage.client;

import mcover.coverage.CoverageReportClient;
import mcover.coverage.DataTypes;

import mcover.util.Timer;

class EMMAPrintClient implements CoverageReportClient
{
	public var completionHandler(default, default):CoverageReportClient -> Void;

	public var output(default, null):String;

	var coverage:Coverage;
	var result:CoverageResult;

	public var xml:Xml;

	public function new() 
	{
		
	}

	public function report(coverage:Coverage):Void
	{
		xml = Xml.createElement("report");

		this.coverage = coverage;
		
		result = coverage.getResults();		
		
		var stats = createStats();

		xml.addChild(stats);

		var all = createAll();

		xml.addChild(all);

		#if php
			reportComplete();
		#else
			var timer = Timer.delay(reportComplete, 10);
		#end
	}

	function reportComplete()
	{
		if(completionHandler != null)
		{
			completionHandler(this);
		}
	}

	function createStats():Xml
	{
		var stats = Xml.createElement("stats");
		var node:Xml;
		node = Xml.parse("<packages value=\"" + result.p + "\" />").firstElement();
		stats.addChild(node);

		node = Xml.parse("<classes value=\"" + result.c + "\" />").firstElement();
		stats.addChild(node);

		node = Xml.parse("<methods value=\"" + result.m + "\" />").firstElement();
		stats.addChild(node);

		node = Xml.parse("<srcfiles value=\"" + result.f + "\" />").firstElement();
		stats.addChild(node);

		node = Xml.parse("<srclines value=\"" + getLineTotal(result) + "\" />").firstElement();
		stats.addChild(node);
	
		return stats;
	}

	function createAll():Xml
	{
		var data = Xml.createElement("data");

		var node = createNodeWithName("all", "all classes");

		var coverageNodes = createCoverageNodes(result, ALL);

		for(coverageNode in coverageNodes)
		{
			node.addChild(coverageNode);
		}
		
		
		for(pck in coverage.getPackages())
		{
			var pckNode = createPackageNode(pck);
			node.addChild(pckNode);
		}

		data.addChild(node);
		return data;
	}

	function createPackageNode(pck:Package):Xml
	{
		var node = createNodeWithName("package", pck.name);

		var result = pck.getResults();

		var coverageNodes = createCoverageNodes(result, ALL);

		for(coverageNode in coverageNodes)
		{
			node.addChild(coverageNode);
		}

		for(file in pck.getFiles())
		{
			var fileNode = createFileNode(file);
			node.addChild(fileNode);
		}

		return node;
	}

	function createFileNode(file:File):Xml
	{
		var node = createNodeWithName("srcfile", file.name);

		var result = file.getResults();

		var coverageNodes = createCoverageNodes(result, ALL);

		for(coverageNode in coverageNodes)
		{
			node.addChild(coverageNode);
		}

		for(clazz in file.getClasses())
		{
			var clazzNode = createClassNode(clazz);
			node.addChild(clazzNode);
		}

		return node;
	}

	function createClassNode(clazz:Clazz):Xml
	{
		var node = createNodeWithName("class", clazz.name);

		var result = clazz.getResults();

		var coverageNodes = createCoverageNodes(result, CLAZZ);

		for(coverageNode in coverageNodes)
		{
			node.addChild(coverageNode);
		}

		for(method in clazz.getMethods())
		{
			var methodNode = createMethodNode(method);
			node.addChild(methodNode);
		}

		return node;
	}

	function createMethodNode(method:Method):Xml
	{
		var node = createNodeWithName("method", method.name);

		var result = method.getResults();

		var coverageNodes = createCoverageNodes(result, METHOD);

		for(coverageNode in coverageNodes)
		{
			node.addChild(coverageNode);
		}

		return node;
	}


	/*
	* generates the coverage summary up to the specified level
	* @param level (0 == line, 1 == block, 2 == method, 3 == class)
	*/
	function createCoverageNodes(result:CoverageResult, level:CoverageLevel):Array<Xml>
	{
		var nodes:Array<Xml> = [];

		var node = createCoverageNode("line", getLineCount(result), getLineTotal(result));
		nodes.unshift(node);

		var bc = getBlockCount(result);
		var bt = getBlockTotal(result);

		node = createCoverageNode("block", bc, bt);
		nodes.unshift(node);

		if(level == METHOD)
		{
			if(bc > 0)
			{
				node = createCoverageNode("method", 1, 1);
			}
			else
			{
				node = createCoverageNode("method", 0, 1);
			}

			nodes.unshift(node);

			return nodes;
		}
		else
		{
			node = createCoverageNode("method", result.mc, result.m);
			nodes.unshift(node);
		}

		if(level == CLAZZ)
		{
			if(result.mc > 0)
			{
				node = createCoverageNode("class", 1, 1);
			}
			else
			{
				node = createCoverageNode("class", 0, 1);
			}

			nodes.unshift(node);

			return nodes;
		}
		else
		{
			node = createCoverageNode("class", result.cc, result.c);
			nodes.unshift(node);
		}


		return nodes;
	
	}

	function createCoverageNode(type:String, count:Int, total:Int)
	{
		var node = Xml.createElement("coverage");
		node.set("type", type + ", %");

		var percent = getPercentage(count, total);
		node.set("value", percent + "% (" + count + "/" + total + ")");
		return node;
	}

	function getPercentage(count:Int, total:Int):Int
	{
		try
		{
			var p = (count == 0 ? 0 : Math.round((count/total)*100));

			#if (!neko && !flash9) 
				if(Math.isNaN(p)) throw "NaN";
			#else
				if(Math.isNaN(p)) p = 0;
			#end
			return p;
		}
		catch(e:Dynamic){}
		return 0;
	}

	function createNodeWithName(node:String, name:String)
	{
		var node = Xml.createElement(node);
		node.set("name", name);
		return node;
	}

	function getBlockCount(r:CoverageResult):Int
	{
		return r.bt + r.bf + r.sc;
	}

	function getBlockTotal(r:CoverageResult):Int
	{
		return r.b*2 + r.s;
	}

	function getLineCount(r:CoverageResult):Int
	{
		return r.lc;
	}

	function getLineTotal(r:CoverageResult):Int
	{
		return r.l;
	}
}

enum CoverageLevel
{
	ALL;
	PACKAGE;
	FILE;
	CLAZZ;
	METHOD;
}