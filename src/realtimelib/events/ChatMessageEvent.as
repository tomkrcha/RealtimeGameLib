/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib.events
{
	import realtimelib.session.UserObject;
	
	import flash.events.Event;
	
	/**
	 * transmits chat messages in/out of a visual component to P2PSession
	 */
	public class ChatMessageEvent extends Event
	{
		
		public static const CHAT_MESSAGE:String = "chatMessage";
		public static const OPEN_PRIVATE_CHAT:String = "openPrivateChat";
		
		public var message:Object;
		public var userName:String;
		public var details:Object;
		public var receiver:Object;
		
		public function ChatMessageEvent(type:String, message:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.message = message;/*
			this.userName = userName;
			this.receiver = receiver;
			this.details = details;*/
		}
	}
}