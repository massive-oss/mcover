package example;

class Account 
{
	var values:Array<Int>;
	public function new() 
	{
		values = [];
	}

	public function add(value:Int)
	{
		values.push(value);
	}

	public function remove(value:Int)
	{
		values.remove(value);
	}

	public function toString():String
	{
		return values.toString();
	}

	public function totalValue():Int
	{
		var total = 0;
		for(value in values)
		{
			total = Calculator.add(total, value);
		}
		return total;
	}

	public function double(value:Int)
	{
		@:IgnoreCover if(false)
		{
			return value;
		}
		return value*2;

	}
}