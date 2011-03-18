package realtimelib.session
{
	import flash.events.IEventDispatcher;
	import flash.net.NetConnection;

	public interface ISession extends IEventDispatcher
	{
		function connect(userName:String,userDetails:Object=null):void;
		function close():void;
		
		function get connection():NetConnection;
		function set connection(value:NetConnection):void;
		
		function get myUser():UserObject;
		function set myUser(value:UserObject):void;
	}
}