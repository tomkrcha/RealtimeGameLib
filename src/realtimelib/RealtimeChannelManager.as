package realtimelib
{
	import realtimelib.session.ISession;
	import realtimelib.session.P2PSession;
	import realtimelib.session.UserList;
	import realtimelib.session.UserObject;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * Manages realtime connections among peers in a full mesh P2P network scenario.
	 * Creates RealtimeChannel between two peers for every new member in the group.
	 * E.g. if there are 5 peers in the group, RealtimeChannelManager handels 5 RealtimeChannel instances (5 receive streams).
	 * Also creates one send stream (publish) for data distribution to all clients in the group, who subscribe to it - in this scenario everyone.
	 */
	public class RealtimeChannelManager
	{
		public var realtimeChannels:Vector.<RealtimeChannel>;
		
		private var session:ISession
		public var sendStream:NetStream;
		public var streamMethod:String;
		
		public function RealtimeChannelManager(session:ISession,streamMethod:String=NetStream.DIRECT_CONNECTIONS)
		{
			this.session = session;
			this.streamMethod = streamMethod;
			realtimeChannels = new Vector.<RealtimeChannel>();
			initSendStream();
		}
		/**
		 * Adds new RealtimeChannel
		 * @param peerID peerID to connect to
		 * @param clientObject user details
		 */
		public function addRealtimeChannel(peerID:String, clientObject:Object):void{
			var realtimeChannel:RealtimeChannel = new RealtimeChannel(session.connection, peerID, session.myUser.id,clientObject);
			realtimeChannels.push(realtimeChannel);
		}
		
		/**
		 * Removes RealtimeChannel by peerID.
		 * @param peerID Remove RealtimeChannel by peerID.
		 */
		public function removeRealtimeChannel(peerID:String):void{
			for(var i:uint = 0;i<realtimeChannels.length;i++){
				if(realtimeChannels[i].peerID == peerID){
					realtimeChannels[i].close();
					realtimeChannels.splice(i,1);
					break;
				}
			}
		}
		
		protected function netStatus(event:NetStatusEvent):void{
			Logger.log("SendStream: "+event.info.code);
		}
		
		protected function initSendStream():void{
			
			sendStream = new NetStream(session.connection,streamMethod);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus,false,0,true);
			sendStream.publish("media");
			
			var sendStreamClient:Object = new Object();
			sendStreamClient.onPeerConnect = function(callerns:NetStream):Boolean{
				Logger.log("onPeerConnect "+callerns.farID);
				
				return true;
			}
			
			sendStream.client = sendStreamClient;
		}
	}
}