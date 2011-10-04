package massive.mcover.data;
import massive.mcover.data.CoverageResult;
@:keep class File extends AbstractNodeList
{
	public function new()
	{
		super();
	}

	override function appendResults(to:CoverageResult, from:CoverageResult):CoverageResult
	{
		to = super.appendResults(to, from);
		to.cc += (from.sc > 0) ? 1 : 0; 
		to.c += 1;	
		return to;
	}
}