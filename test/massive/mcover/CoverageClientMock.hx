package massive.mcover;

import massive.mcover.data.Statement;
import massive.mcover.data.Branch;
import massive.mcover.data.AllClasses;


class CoverageClientMock implements CoverageClient
{
	public var statement:Statement;
	public var branch:Branch;
	public var allClasses:AllClasses;
	

	/**
	 * Handler which if present, is called when the client has completed generating its results.
	 */
	public var completionHandler(default, default):CoverageClient -> Void;


	public function new()
	{
		
	}

	/**
	 * Called when a statement code block is executed at runtime.
	 *  
	 * @param	block		a code block  
	 */
	public function logStatement(statement:Statement)
	{
		this.statement = statement;
	}
	
	/**
	 * Called when a branch code block is executed at runtime.
	 *  
	 * @param	block		a code block  
	 */
	public function logBranch(branch:Branch)
	{
		this.branch = branch;
	}
	
	/**
	 * Called when all tests are complete.
	 *  
	 * @param	allClasses	arrgregated coverage data containing all statements, branches orded by package/file/class/method
	 * @return	collated result data if any
	 * @see massive.mcover.data.AllClasses;
	 */
	public function report(allClasses:AllClasses):Dynamic
	{
		this.allClasses = allClasses;
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