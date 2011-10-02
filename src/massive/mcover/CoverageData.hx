package massive.mcover;

class CoverageData
{
	public var blocks:IntHash<CodeBlock>;
	public var packages:IntHash<String>;
	public var files:IntHash<String>;
	public var classes:IntHash<String>;

	public function new()
	{
		blocks = new IntHash();
		packages = new IntHash();
		files = new IntHash();
		classes = new IntHash();
	}
}