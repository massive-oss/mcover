package;

class Main
{
	@IgnoreCover
	static public function main()
	{
		new Main();
	}

	public function new()
	{
		var account = new example.Account();
		account.add(1);
		account.add(5);
		account.add(3);
		account.remove(5);

		var total = account.totalValue();

		trace(account.toString());
	}
}	