package realtimelib
{
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * Creates a DIRECT_CONNECTIONS NetStream between two peers
	 * This method enables to reach lowest latency possible in a P2P network
	 * Creates a receive stream for receiving data from the opposite side.
	 */
	public class RealtimeChannel
	{
		public var peerID:String;
		
		private var receiveStream:NetStream;
		
		private var myPeerID:String;
				
		private var client:Object;
		
		public function RealtimeChannel(connection:NetConnection, peerID:String, myPeerID:String,client:Object)
		{
			Logger.log("create RealtimeChannel and listen to: "+peerID);
			this.peerID = peerID;
			this.myPeerID = myPeerID;
			this.client = client;
			
			receiveStream = new NetStream(connection,peerID);
			receiveStream.addEventListener(NetStatusEvent.NET_STATUS,netStatus,false,0,true);
			receiveStream.client = client;
			receiveStream.play("media");
		}
		
		public function close():void{
			receiveStream.close();
		}
		protected function netStatus(event:NetStatusEvent):void{
			Logger.log("receiveStream: "+event.info.code);
		}
	}
}