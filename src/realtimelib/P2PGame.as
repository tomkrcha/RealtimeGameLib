/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import realtimelib.events.ConnectionStatusEvent;
	import realtimelib.events.GameEvent;
	import realtimelib.events.PeerStatusEvent;
	import realtimelib.session.GroupChat;
	import realtimelib.session.ISession;
	import realtimelib.session.P2PSession;
	import realtimelib.session.UserList;
	import realtimelib.session.UserObject;

	[Event(name="change",type="flash.events.Event")]
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="startGame", type="realtimelib.events.GameEvent")]
	[Event(name="gameOver", type="realtimelib.events.GameEvent")]
	[Event(name="playerReady", type="realtimelib.events.GameEvent")]
	[Event(name="playerOut", type="realtimelib.events.GameEvent")]
	[Event(name="userAdded",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userRemoved",type="com.adobe.fms.PeerStatusEvent")]
	
	/**
	 * P2PGame class handles movement, position, mouse position, rotation and speed callbacks back to your game
	 * Allows you to distribute realtime data to everyone in the group using RealtimeChannel class
	 */
	public class P2PGame extends EventDispatcher implements IRealtimeGame
	{
		
		private var session:P2PSession;
		public var realtimeChannelManager:RealtimeChannelManager;
		// callbacks

		

		public var receiveMovementCallback:Function;
		public var receivePositionCallback:Function;
		public var receiveMousePositionCallback:Function;
		public var receiveRotationCallback:Function;
		public var receiveSpeedCallback:Function;
		
		private var _running:Boolean = false;
		public function get running():Boolean
		{
			return _running;
		}
		
		private var serverAddr:String;
		private var groupName:String;
	
		
		public function P2PGame(serverAddr:String, groupName:String="defaultGroup"){
			this.serverAddr = serverAddr;
			this.groupName = groupName;
		}
				
		/**
		 * creates new session and connects to the group with username and details
		 */
		public function connect(userName:String,userDetails:Object=null):void{
			session = new P2PSession(serverAddr,groupName);			
			session.addEventListener(Event.CONNECT, onConnect);
			session.addEventListener(ConnectionStatusEvent.STATUS_CHANGE, onStatusChange);
			session.connect(userName,userDetails);
			trace("CONNECT: "+userName);
		}
		
		protected function onStatusChange(event:ConnectionStatusEvent):void
		{
			switch (event.status)
			{
				case ConnectionStatusEvent.DISCONNECTED:
					dispatchEvent(new Event(Event.CLOSE));
					break;
			}
		}
		
		/**
		 * closes session
		 */
		public function close():void{
			session.close();
		}
		
		/*
		 * DEFAULT EVENTS
		 */
		protected function onConnect(event:Event):void{
			Logger.log("onConnect");
			
			session.addEventListener(Event.CHANGE, onUserListChange);
			session.addEventListener(PeerStatusEvent.USER_ADDED, onUserAdded);
			session.addEventListener(PeerStatusEvent.USER_REMOVED, onUserRemoved);
			
			realtimeChannelManager = new RealtimeChannelManager(session);
			
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		protected function onUserListChange(event:Event):void{
			Logger.log("onUserListChange");
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onUserAdded(event:PeerStatusEvent):void{
			if(event.info.id!=session.myUser.id){
				realtimeChannelManager.addRealtimeChannel(event.info.id, this);
				dispatchEvent(event);
			}
		}
		
		protected function onUserRemoved(event:PeerStatusEvent):void{
			if(event.info.id!=session.myUser.id){
				realtimeChannelManager.removeRealtimeChannel(event.info.id);
				dispatchEvent(event);
			}
		}
		
		/*
		 **********************************************************************
		 * SEND 
		 **********************************************************************
		 */ 
		
		/*
		 * GAME MESSAGES
		 */ 
		/**
		 * send trigger to start game
		 */
		public function sendStartGame():void{
			realtimeChannelManager.sendStream.send("receiveStartGame",session.myUser.id);
		}
		/**
		 * send trigger to game over
		 */
		public function sendGameOver():void{
			realtimeChannelManager.sendStream.send("receiveGameOver",session.myUser.id);
		}
		
		/*
		 * PLAYER MESSAGES
		 */
		/**
		 * send trigger that player is ready
		 */
		public function sendPlayerReady():void{
			realtimeChannelManager.sendStream.send("receivePlayerReady",session.myUser.id);
		}
		/**
		 * send trigger that player is out
		 */
		public function sendPlayerOut():void{
			realtimeChannelManager.sendStream.send("receivePlayerOut",session.myUser.id);
		}
		
		/*
		 * MOVEMENT MESSAGES
		 */ 
		
		/**
		 * distributes message to everyone in the group
		 */
		public function sendMessage(message:String):void{
			realtimeChannelManager.sendStream.send("receiveMessage",message);
		}
		/**
		 * distributes mouse position to everyone in the group
		 * @param x Mouse x position.
		 * @param y Mouse y position.
		 */
		public function sendMousePositions(x:int,y:int):void{
			realtimeChannelManager.sendStream.send("receiveMousePositions",session.myUser.id,x,y);
		}
		/**
		 * distributes movement direction to everyone in the group
		 * @param direction Can be any int describing UP, DOWN, LEFT, RIGHT or FORWARD, BACKWARD, LEFT, RIGHT or their combinations UP-LEFT, UP-RIGHT and so on.
		 * @param down Information about key, if it is down or not (Boolean).
		 */
		public function sendMovement(direction:int, down:Boolean):void{
			realtimeChannelManager.sendStream.send("receiveMovement",session.myUser.id,direction,down);
		}
		/**
		 * distributes position to everyone in the group
		 * @param position Object that usually contains info about position like x, y, z and orientation, rotation, velocity.
		 */
		public function sendPosition(position:Object):void{
			realtimeChannelManager.sendStream.send("receivePosition",session.myUser.id,position);
		}
		
		/*
		 * car related
		 */
		
		/**
		 * distributes rotation to everyone in the group
		 * @param rotation Number containing a rotation - for instance steering wheel rotation, accelerometer rotation in one direction or similar.
		 */
		public function sendRotation(rotation:Number):void{
			realtimeChannelManager.sendStream.send("receiveRotation",session.myUser.id,rotation);

		}
		
		/**
		 * distributes speed to everyone in the group
		 * @param speed Number containing the speed of a car or similar.
		 */
		public function sendSpeed(speed:Number):void{
			realtimeChannelManager.sendStream.send("receiveSpeed",session.myUser.id,speed);

		}
		
		/**
		 * send object
		 * @param Anything
		 */
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
			_running = true;
		}
		
		public function receiveGameOver(peerID:String):void{
			dispatchEvent(new GameEvent(GameEvent.GAME_OVER,peerID));
			_running = false;
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
		/**
		 * Receive movement, called internally in the most cases.
		 * @param peerID Contains unique peerID.
		 * @param direction an be any int describing UP, DOWN, LEFT, RIGHT or FORWARD, BACKWARD, LEFT, RIGHT or their combinations UP-LEFT, UP-RIGHT and so on.
		 * @param down
		 */
		public function receiveMovement(peerID:String, direction:int, down:Boolean):void{
			receiveMovementCallback.call(this, peerID, direction, down);
		}
		/**
		 * Receive position, called internally in the most cases.
		 * @param peerID Contains unique peerID.
		 * @param position Object that usually contains info about position like x, y, z and orientation, rotation, velocity.
		 */
		public function receivePosition(peerID:String, position:Object):void{
			receivePositionCallback.call(this,peerID, position);
		}
		
		/**
		 * Receive mouse position, called internally in the most cases.
		 * @param peerID Contains unique peerID.
		 * @param x Mouse x position.
		 * @param y Mouse y position.
		 */
		public function receiveMousePositions(peerID:String, x:int, y:int):void{
			receiveMousePositionCallback.call(this,peerID, x, y);

		}
		
		// car related
		/**
		 * Receive rotation, called internally in the most cases. This method is mostly racing car steering wheel related.
		 * @param peerID Contains unique peerID.
		 * @param rotation Contains rotation.
		 */
		public function receiveRotation(peerID:String, rotation:Number):void{
			receiveRotationCallback.call(this, peerID, rotation);
		}
		
		/**
		 * Receive speed, called internally in the most cases. This method is mostly racing car steering wheel related.
		 * @param peerID Contains unique peerID.
		 * @param speed Contains speed.
		 */
		public function receiveSpeed(peerID:String, speed:Number):void{
			receiveSpeedCallback.call(this, peerID, speed);
		}
		
		/*
		* SET CALLBACKS
		*/ 
		/**
		 * sets callback function
		 * @param fnc Callback function, just one to be defined.
		 */
		public function setReceiveMovementCallback(fnc:Function):void{
			receiveMovementCallback = fnc;
		}
		/**
		 * sets callback function
		 * @param fnc Callback function, just one to be defined.
		 */
		public function setReceivePositionCallback(fnc:Function):void{
			receivePositionCallback = fnc;
		}
		/**
		 * sets callback function
		 * @param fnc Callback function, just one to be defined.
		 */
		public function setReceiveMousePositionCallback(fnc:Function):void{
			receiveMousePositionCallback = fnc;
		}
		/**
		 * sets callback function
		 * @param fnc Callback function, just one to be defined.
		 */
		public function setReceiveRotationCallback(fnc:Function):void{
			receiveRotationCallback = fnc;
		}
		/**
		 * sets callback function
		 * @param fnc Callback function, just one to be defined.
		 */
		public function setReceiveSpeedCallback(fnc:Function):void{
			receiveSpeedCallback = fnc;
		}
		
		/**
		 * List of users in the group as an object.
		 */
		public function get userList():Object{
			return session.mainChat.userList;
		}
		
		/**
		 * Returns my user object.
		 */
		public function get myUser():Object{
			return session.myUser;
		}
		
		/**
		 * List of users in the group as an array.
		 */
		public function get userListArray():Array{
			var arr:Array = new Array();
			for(var user:Object in userList){
				arr.push(userList[user].userName);
			}
			return arr;
		}
		
		/**
		 * List of users in the group as a map object.
		 */
		public function get userListMap():Object{
			var obj:Object = new Object();
			for(var id:String in userList){
				obj[id] = userList[id].userName;
			}
			return obj;
		}
		
	}
}