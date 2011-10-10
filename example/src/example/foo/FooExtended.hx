package example.foo;
import example.foo.Foo;


class FooExtended<T:Int> extends Foo<T>
{

	public function new(target:T)
	{
		super(target);
		Main.here();
	}
}