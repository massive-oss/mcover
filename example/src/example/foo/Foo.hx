package example.foo;

class Foo<T>
{
	public var target:T;

	static public function bar()
	{
		Main.here();
	}

	public function new(target:T)
	{
		this.target = target;
		Main.here();
	}
}