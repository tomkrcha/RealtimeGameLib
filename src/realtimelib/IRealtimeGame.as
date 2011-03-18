package realtimelib
{
	import realtimelib.session.ISession;
	import realtimelib.session.UserObject;
	
	import flash.events.IEventDispatcher;

	[Event(name="change",type="flash.events.Event")]
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="startGame", type="realtimelib.events.GameEvent")]
	[Event(name="gameOver", type="realtimelib.events.GameEvent")]
	[Event(name="playerReady", type="realtimelib.events.GameEvent")]
	[Event(name="playerOut", type="realtimelib.events.GameEvent")]
	[Event(name="userAdded",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userRemoved",type="com.adobe.fms.PeerStatusEvent")]
	public interface IRealtimeGame extends IEventDispatcher
	{
		function connect(userName:String,userDetails:Object=null):void;
		function close():void;
		
		/*
		 * SEND functions
		 */
		function sendMessage(message:String):void;
		function sendMousePositions(x:int,y:int):void;
		function sendMovement(direction:int, down:Boolean):void;
		function sendPosition(position:Object):void;
		function sendRotation(rotation:Number):void;
		function sendSpeed(speed:Number):void;
		function sendObject(object:*):void;
		
		/*
		 * RECEIVE functions
		 */
		function receiveMovement(peerID:String, direction:int, down:Boolean):void;
		function receivePosition(peerID:String, position:Object):void;
		function receiveMousePositions(peerID:String, x:int, y:int):void;
		function receiveRotation(peerID:String, rotation:Number):void;
		function receiveSpeed(peerID:String, speed:Number):void;
		
		/*
		* SET CALLBACKS
		*/ 

		function setReceiveMovementCallback(fnc:Function):void;
		function setReceivePositionCallback(fnc:Function):void;
		function setReceiveMousePositionCallback(fnc:Function):void;
		function setReceiveRotationCallback(fnc:Function):void;
		function setReceiveSpeedCallback(fnc:Function):void;
		
		/*function get session():ISession;
		function set session(value:ISession):void;*/
		
		function get myUser():Object;
		function get userList():Object;
		function get userListArray():Array;
		function get userListMap():Object;
	}
}