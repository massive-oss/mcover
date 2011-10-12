package massive.mcover;

import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.Coverage;


class CoverageReportClientMock implements CoverageReportClient
{
	public var coverage:Coverage;

	/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(default, default):CoverageReportClient -> Void;


	public function new()
	{
		
	}

	public function report(coverage:Coverage):Void
	{
		this.coverage = coverage;

		var timer = massive.munit.util.Timer.delay(reportComplete, 50);

		return null;
	}

	function reportComplete()
	{
		if(completionHandler != null)
		{
			completionHandler(this);
		}
	}

}