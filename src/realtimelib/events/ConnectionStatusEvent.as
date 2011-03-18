package realtimelib.events
{
	import flash.events.Event;

	public class ConnectionStatusEvent extends Event
	{
		
		// EVENT
		public static const STATUS_CHANGE:String = "statusChange";
		
		// STATUSES
		
		public static const UNINITIALIZED:uint = 0xCCCCCC;
		public static const DISCONNECTED:uint = 0xFF0000;
		public static const CONNECTING:uint = 0xFFFF00;
		public static const CONNECTED:uint = 0x008000;
		public static const CONNECTED_GROUP:uint = 0x00FF00;
		public static const FAILED:uint = 0x800000;	
		
		public var status:uint = UNINITIALIZED;
		
		public function ConnectionStatusEvent(type:String, status:uint, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.status = status;
		}
		
		
		
	}
}