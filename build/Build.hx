import mtask.target.HaxeLib;

class Build extends mtask.core.BuildBase
{
	public function new()
	{
		super();
	}

	@target function haxelib(t:HaxeLib)
	{
		t.name = build.project.id;
		t.version = build.project.version;
		t.versionDescription = "Please note: The top level package has changed from `m.cover` to `mcover` to remove single char package. See CHANGES.txt for full list of changes.";
		
		t.url = "http://github.com/massiveinteractive/mcover";
		t.license.organization = "Massive Interactive";
		t.username = "massive";
		t.description = "A cross platform code coverage framework for Haxe with testing and profiling applications. Supports AVM1, AVM2, JavaScript, C++, PHP and Neko.";

		t.addTag("cross");
		t.addTag("macro");
		t.addTag("utility");
		t.addTag("massive");

		t.afterCompile = function()
		{
			cp("src/*", t.path);
		}
	}

	@task function release()
	{
		require("clean");
		require("test");
		require("build haxelib");
	}

	@task function test()
	{
		msys.Process.run("haxelib", ["run", "munit", "test", "-neko", "-coverage"]);
	}
}