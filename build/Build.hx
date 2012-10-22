import mtask.target.HaxeLib;

class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}

	@target function haxelib(t:HaxeLib)
	{
		t.url = "http://github.com/massiveinteractive/mcover";
		t.description = "A cross platform code coverage framework for Haxe with testing and profiling applications. Supports AVM1, AVM2, JavaScript, C++, PHP and Neko.";
		t.versionDescription = "Minor bugfixes. See CHANGES for full list of changes.";

		t.addTag("cross");
		t.addTag("macro");
		t.addTag("utility");
		t.addTag("massive");

		t.addDependency("mconsole");

		t.beforeCompile = function(path)
		{
			rm("src/haxelib.xml");
			cp("src/*", path);
		}
	}

	@task function release()
	{
		invoke("clean");
		invoke("test");
		invoke("build haxelib");
	}

	@task function test()
	{
		msys.Process.run("haxelib", ["run", "munit", "test", "-coverage"]);
	}
}