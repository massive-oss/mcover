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

package mcover.coverage.data;

class DataUtil
{
	@IgnoreCover
	public function new(){}

	@IgnoreLogging
	static public function sortOnNodeId(a:AbstractNode, b:AbstractNode)
	{
		return a.id-b.id;
	}

	@IgnoreLogging
	static public function sortOnNodeName(a:AbstractNode, b:AbstractNode)
	{
		var nodeA = a.name.toLowerCase();
        var nodeB = b.name.toLowerCase();
        
        if (nodeA < nodeB) return -1;
        if (nodeA > nodeB) return 1;

		return 0;
	}

	@IgnoreLogging
	static public function sortOnBlockName(a:AbstractBlock, b:AbstractBlock)
	{
		var blockA = a.toString().toLowerCase();
        var blockB = b.toString().toLowerCase();
        
        if (blockA < blockB) return -1;
        if (blockA > blockB) return 1;
        return 0;
	}
}