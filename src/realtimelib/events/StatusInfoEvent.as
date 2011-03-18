/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib.events
{
	import flash.events.Event;
	
	public class StatusInfoEvent extends Event
	{
		public static const STATUS_INFO:String = "statusInfo";

		public var message:String;
		
		public function StatusInfoEvent(type:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		
			this.message = message;
		}
	}
}