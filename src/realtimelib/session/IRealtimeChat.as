package realtimelib.session
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="userAdded",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userRemoved",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userIdle",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="connected",type="com.adobe.fms.PeerStatusEvent")]
	public interface IRealtimeChat
	{
		
	}
}