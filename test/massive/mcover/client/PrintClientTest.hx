package massive.mcover.client;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.mcover.data.AllClasses;
import massive.mcover.CoverageClient;

class PrintClientTest extends CoverageClientTest
{
	var printClient:PrintClient;

	public function new()
	{
		super();
	}

	@BeforeClass
	override public function beforeClass():Void
	{
		super.beforeClass();
	}
	
	@AfterClass
	override public function afterClass():Void
	{
		super.afterClass();
	}
	
	@Before
	override public function setup():Void
	{
		super.setup();
		printClient = new PrintClient();
	}
	
	@After
	override public function tearDown():Void
	{
		super.tearDown();
	}

	///////////

	override function createClient():CoverageClient
	{
		return new PrintClient();
	}
}
