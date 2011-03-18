/* Created by Tom Krcha (http://flashrealtime.com/, http://twitter.com/tomkrcha). Provided "as is" in public domain with no guarantees */
package realtimelib.session
{
	import realtimelib.session.ISession;
	import realtimelib.events.ChatMessageEvent;
	import realtimelib.events.ConnectionStatusEvent;
	import realtimelib.events.PeerStatusEvent;
	import realtimelib.events.StatusInfoEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetGroupReceiveMode;
	import flash.net.NetGroupSendMode;
	import flash.net.NetGroupSendResult;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	
	
	[Event(name="statusInfo",type="realtimelib.events.StatusInfoEvent")]
	[Event(name="chatMessage",type="realtimelib.events.ChatMessageEvent")]
	[Event(name="openPrivateChat",type="realtimelib.events.ChatMessageEvent")]
	[Event(name="connect", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="netStatus",type="flash.events.NetStatus")]
	[Event(name="statusChange",type="flash.events.ConnectionStatusEvent")]
	[Event(name="userAdded",type="com.adobe.fms.PeerStatusEvent")]
	[Event(name="userRemoved",type="com.adobe.fms.PeerStatusEvent")]
	public class FMSSession extends EventDispatcher implements ISession
	{
		
		private var _connection:NetConnection;
	
		private var _myUser:UserObject;		
		//[Bindable] 
		public var status:uint;
		//[Bindable] 
		private var serverAddr:String;
		private var groupName:String;
		public var myUserDetails:Object;
		private var myUserName:String;
		
		private var mainSO:SharedObject;
		public var sendStream:NetStream;
		private var callbackClient:Object
		//[Bindable] 		
		public var userList:Object;
		
		private var _mainChat:IEventDispatcher;
		
		public static var debugMode:Boolean = false;
		
		/**
		 * contains list of users, maintained by UserList class
		 */
		private var chatSequence:uint = 0;
		
		public function FMSSession(callbackClient:Object,serverAddr:String,groupName:String="defaultGroup")
		{
			this.serverAddr = serverAddr;
			this.groupName = groupName;
			this.callbackClient = callbackClient;
		}
		
		// CORE LOGIC
		
		public function connect(userName:String,userDetails:Object=null):void{
			myUserName = userName;
			myUserDetails = userDetails;
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS,netStatus,false,0,true);
			connection.connect(serverAddr,myUserDetails);
		}
		
		public function close():void{
			connection.close();
		}
		
		private function createSO():void{
			mainSO = SharedObject.getRemote("main",connection.uri,false);
			mainSO.addEventListener(SyncEvent.SYNC, onSOSync);
			mainSO.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			mainSO.connect(connection);
		}
		
		private function createStreams():void{
			sendStream = new NetStream(connection);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			sendStream.publish("stream_"+myUserName);
			
		}
		
		private function onSOSync(event:SyncEvent):void{
			trace("onSync");
			if(mainSO.data.userList!=null){
				
				var userName:String;
				
				for(userName in mainSO.data.userList){
					//if(userName!=myUserName){
						if(userList[userName]==null){
							onUserAdded(mainSO.data.userList[userName]);
						}
					//}
				}
				for(userName in userList){
					if(mainSO.data.userList[userName]==null){
						onUserRemoved(userName);
					}
				}
			}
			
		}
		
		protected function onUserAdded(userDetails:Object):void{
			
			// Add to user list
			userList[userDetails.userName] = userDetails;
			
			// Don't create receive stream for myUser
			if(userDetails.userName != myUserName){
				var sin:NetStream = new NetStream(connection);
				sin.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
				sin.client = callbackClient;
				sin.play("stream_"+userDetails.userName);
				userList[userDetails.userName].streamIn = sin;
			}
			
			
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		protected function onUserRemoved(userName:String):void{
			userList[userName].streamIn.close();
			delete userList[userName].streamIn;
			delete userList[userName];
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		protected function netStatus(e:NetStatusEvent):void{
			trace(e.info.code);
			
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					userList = new Object();
					
					createSO();
					createStreams()
					//onConnect();
					dispatchEvent(new Event(Event.CONNECT));
					break;
				
				case "NetConnection.Connect.Closed":
					
					//	onDisconnect();
					
					break;
			}
		}
		
		/*private function addUser(userDetails:Object):void{
			//if(userDetails.userName != myUserName){
				if(userList[userDetails.userName]==null){
					
				}
			//}
		}*/
		
		
		public function get connection():NetConnection{
			return _connection;
		}
		public function set connection(value:NetConnection):void{
			_connection = value;
		}
		
		public function get myUser():UserObject{
			return _myUser;
		}
		public function set myUser(value:UserObject):void{
			_myUser = value;
		}
		
		public function get mainChat():IEventDispatcher{
			return _mainChat;
		}
		public function set mainChat(value:IEventDispatcher):void{
			_mainChat = value;
		}
	}
}