package massive.mcover.data;

typedef CoverageResult =
{
	/**
	*	statement count;
	*/
	var sc:Int;
	/**
	*	statement total;
	*/
	var s:Int;
	/**
	*	branch true count;
	*/	
	var bt:Int;
	/**
	*	branch false count;
	*/
	var bc:Int;
	/**
	*	branch count (true and false count both > 0);
	*/
	var bf:Int;
	/**
	*	branch total;
	*/
	var b:Int;
	/**
	*	method count;
	*/
	var mc:Int;
	/**
	*	method total;
	*/	
	var m:Int;
	/**
	*	class count;
	*/
	var cc:Int;
	/**
	*	class total;
	*/	
	var c:Int;
	/**
	*	file count;
	*/
	var fc:Int;
	/**
	*	file total;
	*/	
	var f:Int;
	/**
	*	package count;
	*/
	var pc:Int;
	/**
	*	package total;
	*/	
	var p:Int;
}