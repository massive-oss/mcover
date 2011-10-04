package massive.mcover.data;

import massive.mcover.data.CoverageResult;

@:keep class Package extends AbstractNodeList
{
	public function new()
	{
		super();
	}

	override function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to = super.appendResults(to, from);
		to.fc += (from.sc > 0) ? 1 : 0; 
		to.f += 1;	
		return to;
	}
}