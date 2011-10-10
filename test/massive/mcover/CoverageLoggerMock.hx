package massive.mcover;

import massive.mcover.data.AllClasses;

class CoverageLoggerMock implements CoverageLogger
{
	public var reporter(default, null):CoverageReporter;
	public var allClasses(default, null):AllClasses;

	public var resourceName:String;

	public var statementId:Int;
	public var branchId:Int;
	public var branchValue:Dynamic;
	public var branchCompareValue:Dynamic;
	
		

	public function new()
	{
		resourceName = null;
		reporter = null;
		allClasses = null;
	}

	public function createReporter(?reporterClass:Class<CoverageReporter> =null, overwrite:Bool=false):CoverageReporter
	{
		if(reporterClass == null)
		{
			reporterClass = CoverageReporterMock;
		}

		reporter = Type.createInstance(reporterClass, []);

		return reporter;
	}

	public function loadAllClasses(?resourceName:String = null):Void
	{
		this.resourceName = resourceName;
		allClasses = new AllClasses();
	}

	public function logStatement(id:Int):Void
	{
		statementId = id;
	}

	public function logBranch(id:Int, value:Dynamic, ?compareValue:Dynamic):Dynamic
	{
		branchId = id;
		branchValue = value;
		branchCompareValue = compareValue;
		return value;
	}

}