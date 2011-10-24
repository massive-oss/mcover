package example.foo;
import example.foo.Foo;


class FooExtended<T:Base> extends Foo<T>
{

	public function new(target:T)
	{
		super(target);
		Main.here();
	}
}