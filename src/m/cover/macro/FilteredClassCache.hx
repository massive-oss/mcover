package m.cover.macro;

/**
Stores a cache of previously filtered classes
- overall time stamp
- time stamp per package
- time stamp per file in package


Format:

@id
file|stamp|class,class
*/
class FilteredClassCache
{
	var file:String;

	var id:String;
	var fileHash:Hash<CachedClasses>;


	public function new(path:String)
	{
		file = m.cover.MCover.TEMP_DIR + "/" + path;

		fileHash = new Hash();

		if(neko.FileSystem.exists(file))
		{
			load(file);
		}
	}

	public function init(?classPaths : Array<String>, ?packages : Array<String>, ?exclusions : Array<String>)
	{
		trace("init");
		var tempId = "";
		if(classPaths != null) tempId += classPaths.join(",");
		tempId += ",";
		if(packages != null) tempId += packages.join(",");
		tempId += ",";
		if(exclusions != null) tempId += exclusions.join(",");

		trace("tempId = " + tempId);
		trace("id = " + id);
		if(tempId != id)
		{
			trace("reset");
			id = tempId;
			fileHash = new Hash();
		}

	}

	function getStamp(path:String):String
	{
		if(neko.FileSystem.exists(path) && !neko.FileSystem.isDirectory(path))
		{
			var stat = neko.FileSystem.stat(path);
			return stat.mtime.toString();
		}
		return null;
	}

	public function getCachedFile(path:String):Array<String>
	{
		if(fileHash.exists(path))
		{
			var file = fileHash.get(path);
			var stamp = getStamp(path);

			if(file.stamp == stamp) return file.classes != "" ? file.classes.split(",") : [];		
		}
		return null;
	}

	public function cacheFile(path:String, classes:Array<String>)
	{
		var stamp = getStamp(path);
		var cache:CachedClasses = {stamp:stamp, classes:classes.join(",")};
		fileHash.set(path, cache);
	}


	function load(file:String)
	{
		var f = neko.io.File.read(file, true);
		try
		{
			while( true )
			{
				var line = StringTools.trim(f.readLine());
				
				if(line.charAt(0) == "@")
				{
					id = line.substr(1);
				}
				else
				{
					var a = line.split("|");
					var cache:CachedClasses = {stamp:a[1], classes:a[2]};
						fileHash.set(a[0], cache);
				}
			}
		}
		catch( e : haxe.io.Eof ){}
		f.close();
	}

	public function save()
	{
		var buf = new StringBuf();

		buf.add("@" + id + "\n");

		for(path in fileHash.keys())
		{
			var file = fileHash.get(path);
			buf.add(path + "|" + file.stamp + "|" + file.classes + "\n");
		}

		var f = neko.io.File.write(file, false);
		f.writeString(buf.toString());
		f.close();
	}
}

typedef CachedClasses =
{
	stamp:String,
	classes:String
}

