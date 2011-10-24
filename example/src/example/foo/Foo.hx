package example.foo;

class Foo<T> extends Base,implements IFoo<T>
{
	public var target:T;

	static public function bar()
	{
		Main.here();
	}

	public function new(target:T)
	{
		super();
		this.target = target;
		Main.here();
	}
}