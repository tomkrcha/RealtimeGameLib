/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib
{
	
	import realtimelib.session.FMSSession;
	import realtimelib.session.GroupChat;
	import realtimelib.session.ISession;
	import realtimelib.session.P2PSession;
	import realtimelib.session.UserList;
	import realtimelib.session.UserObject;
	import realtimelib.events.PeerStatusEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	import realtimelib.events.GameEvent;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="startGame", type="realtimelib.events.GameEvent")]
	[Event(name="gameOver", type="realtimelib.events.GameEvent")]
	[Event(name="playerReady", type="realtimelib.events.GameEvent")]
	[Event(name="playerOut", type="realtimelib.events.GameEvent")]
	[Event(name="userAdded",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userRemoved",type="com.adobe.fms.PeerStatusEvent")]
	
	
	/**
	 * Creates new FMS game, needs an application installed on FMS server
	 * Warning: experimental class
	 */
	public class FMSGame extends EventDispatcher //implements IRealtimeGame
	{

		// callbacks
		public var receiveMovementCallback:Function;
		public var receivePositionCallback:Function;
		public var receiveMousePositionCallback:Function;
		public var receiveRotationCallback:Function;
		public var receiveSpeedCallback:Function;
		
		public var running:Boolean = false;
		
		private var serverAddr:String;
		private var groupName:String;
		private var myUserDetails:Object;
		private var myUserName:String;
		
		private var session:FMSSession;
		
		/**
		 * @param serverAddr Define server address
		 */
		public function FMSGame(serverAddr:String, groupName:String="defaultGroup"){
			this.serverAddr = serverAddr;
			this.groupName = groupName;
		}
		
		public function connect(userName:String,userDetails:Object=null):void{
			myUserName = userName.split("|")[0];
			if(userDetails==null){
				myUserDetails = new Object();
				myUserDetails.userName = myUserName;
				myUserDetails.id = myUserName;
			}else{
				myUserDetails = userDetails
			}
			
			session = new FMSSession(this,serverAddr,groupName);			
			session.addEventListener(Event.CONNECT, function(event:Event):void{
				dispatchEvent(event);
			});
			session.addEventListener(Event.CHANGE,function(event:Event):void{
				dispatchEvent(event);
			});
			session.addEventListener(PeerStatusEvent.USER_ADDED,function(event:PeerStatusEvent):void{
				dispatchEvent(event);
			});
			session.addEventListener(PeerStatusEvent.USER_REMOVED,function(event:PeerStatusEvent):void{
				dispatchEvent(event);
			});
			session.connect(myUserName,myUserDetails);
		}
		
		public function close():void{
			session.close();
		}
		
		
		/*
		**********************************************************************
		* SEND 
		**********************************************************************
		*/ 
		
		/*
		* GAME MESSAGES
		*/ 
		/*public function sendStartGame():void{
			sendStream.send("receiveStartGame",session.myUser.id);
		}*/
		
		/*public function sendGameOver():void{
			realtimeChannelManager.sendStream.send("receiveGameOver",session.myUser.id);
		}*/
		
		/*
		* PLAYER MESSAGES
		*/
		/*public function sendPlayerReady():void{
			realtimeChannelManager.sendStream.send("receivePlayerReady",session.myUser.id);
		}
		
		public function sendPlayerOut():void{
			realtimeChannelManager.sendStream.send("receivePlayerOut",session.myUser.id);
		}*/
		
		/*
		* MOVEMENT MESSAGES
		*/ 
		public function sendMessage(message:String):void{
			session.sendStream.send("receiveMessage",message);
		}
		
		public function sendMousePositions(x:int,y:int):void{
			session.sendStream.send("receiveMousePositions",myUserDetails.id,x,y);
		}
		
		public function sendMovement(direction:int, down:Boolean):void{
			session.sendStream.send("receiveMovement",myUserDetails.id,direction,down);
		}
		
		public function sendPosition(position:Object):void{
			session.sendStream.send("receivePosition",myUserDetails.id,position);
		}
		
		// car related
		public function sendRotation(rotation:Number):void{
			session.sendStream.send("receiveRotation",myUserDetails.id,rotation);
		}
		
		public function sendSpeed(speed:Number):void{
			session.sendStream.send("receiveSpeed",myUserDetails.id,speed);
		}
		
		public function sendObject(object:*):void{
			
		}
		
		/*
		**********************************************************************
		* RECEIVE 
		**********************************************************************
		*/ 
		
		/*
		* GAME MESSAGES
		*/
		public function receiveStartGame(peerID:String):void{
			dispatchEvent(new GameEvent(GameEvent.START_GAME,peerID));
			running = true;
		}
		
		public function receiveGameOver(peerID:String):void{
			dispatchEvent(new GameEvent(GameEvent.GAME_OVER,peerID));
			running = false;
		}
		
		/*
		* PLAYER MESSAGES
		*/
		public function receivePlayerReady(peerID:String):void{
			dispatchEvent(new GameEvent(GameEvent.PLAYER_READY,peerID));
		}
		
		public function receivePlayerOut(peerID:String):void{
			dispatchEvent(new GameEvent(GameEvent.PLAYER_OUT,peerID));
		}
		
		/*
		* MOVEMENT MESSAGES
		*/ 
		public function receiveMovement(peerID:String, direction:int, down:Boolean):void{
			receiveMovementCallback.call(this, peerID, direction, down);
		}
		
		public function receivePosition(peerID:String, position:Object):void{
			receivePositionCallback.call(this,peerID, position);
		}
		
		public function receiveMousePositions(peerID:String, x:int, y:int):void{
			receiveMousePositionCallback.call(this,peerID, x, y);
			
		}
		
		// car related
		
		public function receiveRotation(peerID:String, rotation:Number):void{
			receiveRotationCallback.call(this, peerID, rotation);
		}
		
		public function receiveSpeed(peerID:String, speed:Number):void{
			receiveSpeedCallback.call(this, peerID, speed);
		}
		
		/*
		* SET CALLBACKS
		*/ 
		public function setReceiveMovementCallback(fnc:Function):void{
			receiveMovementCallback = fnc;
		}
		
		public function setReceivePositionCallback(fnc:Function):void{
			receivePositionCallback = fnc;
		}
		
		public function setReceiveMousePositionCallback(fnc:Function):void{
			receiveMousePositionCallback = fnc;
		}
		
		public function setReceiveRotationCallback(fnc:Function):void{
			receiveRotationCallback = fnc;
		}
		
		public function setReceiveSpeedCallback(fnc:Function):void{
			receiveSpeedCallback = fnc;
		}
		
		//
		
		
		public function get userList():Object{
			return session.userList;
		}
		
		public function get myUser():Object{
			return session.myUserDetails;
		}
		
		public function get userListArray():Array{
			var arr:Array = new Array();
			for(var id:String in userList){
				arr.push(id);
			}
			return arr;
		}
		
		public function get userListMap():Object{
			var obj:Object = new Object();
			for(var id:String in userList){
				obj[id] = userList[id].userName;
			}
			return obj;
		}

	}
}