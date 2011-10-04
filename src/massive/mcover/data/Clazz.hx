package massive.mcover.data;
import massive.mcover.data.CoverageResult;
@:keep class Clazz extends AbstractNodeList
{
	public function new()
	{
		super();
	}

	override function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to = super.appendResults(to, from);
		to.mc += (from.sc > 0) ? 1 : 0; 
		to.m += 1;	
		return to;
	}

}