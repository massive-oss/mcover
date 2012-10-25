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
		t.versionDescription = "Minor tweaks to support haxe svn (2.11). See CHANGES for details.";

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

	@task function test()
	{
		msys.Process.run("haxelib", ["run", "munit", "test", "-coverage"]);
	}

	@task function teamcity()
	{
		invoke("test");
		cmd("haxelib", ["run", "munit", "report", "teamcity"]);

		invoke("build haxelib");
		invoke("build example");
	}
}