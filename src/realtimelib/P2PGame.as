/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
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
	public class P2PGame extends EventDispatcher //implements IRealtimeGame
	{
		
		public function get groupName():String
		{
			return _groupName;
		}

		public function set groupName(value:String):void
		{
			_groupName = value;
		}

		/**
		 * Receives messages from the other peers. This object provides
		 * setters for assigning callbacks to messages from connected
		 * peers. You can use it to assign callbacks for game messages.
		 * 
		 * @return 
		 * 
		 */		
		public function get channelClient():P2PGameStreamReceiver
		{
			return _channelClient;
		}

		/**
		 * Broadcaster object used to send commands to the other peers.
		 * You can use this object to send game function commands to 
		 * other connected peers.
		 * 
		 * @return 
		 * 
		 */		
		public function get channelBroadcaster():P2PGameStreamBroadcaster
		{
			return _channelBroadcaster;
		}

		public function get running():Boolean
		{
			return _running;
		}
		
		private var _realtimeChannelManager:RealtimeChannelManager;
		private var _session:P2PSession;
		private var _running:Boolean = false;
		private var _serverAddr:String;
		private var _groupName:String;
		private var _channelBroadcaster:P2PGameStreamBroadcaster;
		private var _channelClient:P2PGameStreamReceiver;
		private var _gameNetConnectionClient:Class;
		private var _gameUserName:String;
		private var _gameUserDetails:Object;
	
		
		public function P2PGame(serverAddr:String, groupName:String="defaultGroup", gameNetConnectionClient:Class=null)
		{
			_serverAddr = serverAddr;
			_groupName = groupName;
			_gameNetConnectionClient = gameNetConnectionClient;
		}
				
		/**
		 * creates new session and connects to the group with username and details
		 */
		public function connect(userName:String, userDetails:Object=null):void
		{
			_gameUserName = userName;
			_gameUserDetails = userDetails;
			
			_session = new P2PSession(_serverAddr, _groupName, _gameNetConnectionClient);			
			_session.addEventListener(Event.CONNECT, onConnect);
			_session.addEventListener(ConnectionStatusEvent.STATUS_CHANGE, onStatusChange);
			_session.connect(userName, userDetails);
		}
		
		protected function setRunning(value:Boolean):void
		{
			_running = value;
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
		public function close():void
		{
			if (_session)
				_session.close();
		}
		
		/*
		 * DEFAULT EVENTS
		 */
		protected function onConnect(event:Event):void
		{
			Logger.log("onConnect");
			
			_addSessionEventHandlers();
			
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		private function _startRealTimeChannelManager():void
		{
			_realtimeChannelManager = new RealtimeChannelManager(_session);
			_channelBroadcaster = createBroadcaster();
		}
		
		private function _addSessionEventHandlers():void
		{
			_session.addEventListener(Event.CHANGE, onUserListChange);
			_session.addEventListener(PeerStatusEvent.USER_ADDED, onUserAdded);
			_session.addEventListener(PeerStatusEvent.USER_REMOVED, onUserRemoved);
		}
		
		protected function createBroadcaster():P2PGameStreamBroadcaster
		{
			return new P2PGameStreamBroadcaster(_realtimeChannelManager, _session);
		}
		
		protected function onUserListChange(event:Event):void
		{
			Logger.log("onUserListChange");
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onUserAdded(event:PeerStatusEvent):void
		{
			if (event.info.id!=_session.myUser.id)
			{
				_realtimeChannelManager.addRealtimeChannel(event.info.id, getChannelClient()); // Sets the client on the receiving netstream to this (P2PGame)
				dispatchEvent(event);
			}
		}
		
		protected function getChannelClient():Object
		{
			if (!_channelClient)
				_channelClient = new P2PGameStreamReceiver(this, setRunning);
			
			return _channelClient;
		}
		
		protected function onUserRemoved(event:PeerStatusEvent):void
		{
			if (event.info.id!=_session.myUser.id)
			{
				_realtimeChannelManager.removeRealtimeChannel(event.info.id);
				dispatchEvent(event);
			}
		}
		

		
		/**
		 * List of users in the group as an object.
		 */
		public function get userList():Object
		{
			return _session.mainChat.userList;
		}
		
		/**
		 * Returns my user object.
		 */
		public function get myUser():Object
		{
			return _session.myUser;
		}
		
		/**
		 * List of users in the group as an array.
		 */
		public function get userListArray():Array
		{
			var arr:Array = new Array();
			var user:Object;
			for (user in userList)
			{
				arr.push(userList[user].userName);
			}
			return arr;
		}
		
		/**
		 * List of users in the group as a map object.
		 */
		public function get userListMap():Object
		{
			var obj:Object = new Object();
			var id:String;
			for (id in userList)
			{
				obj[id] = userList[id].userName;
			}
			return obj;
		}
		
		public function joinGroup(groupId:Number):void
		{
			_session.addEventListener(ConnectionStatusEvent.STATUS_CHANGE, handleGroupConnected);
			_session.join(groupId);
		}
		
		protected function handleGroupConnected(event:ConnectionStatusEvent):void
		{
			if (event.status == ConnectionStatusEvent.CONNECTED_GROUP)
			{
				dispatchEvent(event);
				_startRealTimeChannelManager();
			}
		}
	}
}