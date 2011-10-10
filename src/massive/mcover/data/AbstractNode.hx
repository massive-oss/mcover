package massive.mcover.data;

@:keep class AbstractNode
{
	public var id:Null<Int>;
	public var name:String;

	var resultCache:CoverageResult;

	function new()
	{

	}

	public function getResults(?cache:Bool=true):CoverageResult
	{
		if(resultCache == null || !cache)
		{
			resultCache = emptyResult();
		}

		return resultCache;
	}

	public function getPercentage():Float
	{
		var r = getResults();
		try
		{
			var p = Math.round((r.bt + r.bf + r.sc + r.mc)/(2*r.b + r.s + r.m)*10000)/100;

			#if (!neko && !flash9) 
			if(Math.isNaN(p)) throw "NaN";
			#end
			return p;
		}
		catch(e:Dynamic){}
		return 0;
	}
	
	public function getClasses():Array<Clazz>
	{
		return [];
	}

	public function lookupBranch(path:Array<Int>):Branch
	{
		return null;
	}

	public function lookupStatement(path:Array<Int>):Statement
	{
		return null;
	}

	
	public function getMissingBranches():Array<Branch>
	{
		return [];
	}

	public function getMissingStatements():Array<Statement>
	{
		return [];
	}

	//////////////
	

	function emptyResult():CoverageResult
	{
		return {sc:0, s:0, bt:0, bf:0,bc:0,b:0, mc:0, m:0, cc:0, c:0, fc:0, f:0, pc:0, p:0};
	}

	function hxSerialize( s : haxe.Serializer )
	{
		s.serialize(id);
        s.serialize(name);
    }
    
    function hxUnserialize( s : haxe.Unserializer )
    {
    	id = s.unserialize();
        name = s.unserialize();
    }
}