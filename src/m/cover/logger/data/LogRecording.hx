package m.cover.logger.data;

@IgnoreCover
class LogRecording
{
	public var depth:Int;
	public var maxDepth:Int;
	public var startTime:Float;
	public var endTime:Float;
	public var duration:Float;

	public function new()
	{
		depth = 0;
		maxDepth = 0;
		startTime = Utils.inlineStamp();
		endTime = 0;
		duration = 0;
	}
}