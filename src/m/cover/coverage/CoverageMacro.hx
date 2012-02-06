package m.cover.coverage;

#if macro
import haxe.macro.Context;
import m.cover.MCover;
import m.cover.macro.PackageHelper;
import m.cover.macro.BuildMacro;
import m.cover.macro.IncludeMacro;
import m.cover.coverage.data.Coverage;
import m.cover.coverage.macro.CoverageBuildMacro;

class CoverageMacro implements IncludeMacro
{
	static public var coverage = new Coverage();
	static public var classPathHash:IntHash<String> = new IntHash();

	public var id(default, null):String;

	public function new()
	{
		id = "coverage";
	}

	public function initialize()
	{
		BuildMacro.registerParser(id, CoverageBuildMacro);
	}

	public function getClasses(?packages : Array<String>=null, ?classPaths : Array<String>=null, ?exclusions : Array<String>=null):Array<String>
	{
		if(packages ==  null || packages.length == 0) packages = [""];
		var helper = new PackageHelper();
		helper.ignoreClassMeta = "IgnoreCover";
		
		var classes = helper.include(classPaths, packages, exclusions);
		
		for(cp in classPaths)
		{
			classPathHash.set(Lambda.count(classPathHash), cp);
		}


		return classes;

	}

	/**
	* Inserts reference to all identified code coverage blocks into a haxe.Resource file called 'MCover'.
	* This resource is used by MCoverRunner to determine code coverage results
	*/
	public function onGenerate(types:Array<haxe.macro.Type>):Void
	{
		var serializedData = haxe.Serializer.run(CoverageMacro.coverage);
       	Context.addResource(MCoverage.RESOURCE_DATA, haxe.io.Bytes.ofString(serializedData));
	}
}

#end