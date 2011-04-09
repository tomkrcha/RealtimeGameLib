package realtimelib
{
	import realtimelib.session.ISession;

	public class StreamBroadcaster
	{
		private var _realtimeChannelManager:RealtimeChannelManager;
		private var _session:ISession;
		
		public function StreamBroadcaster(manager:RealtimeChannelManager, session:ISession)
		{
			_initialize(realtimeChannelManager, session);
		}
		
		private function _initialize(realtimeChannelManager:RealtimeChannelManager, session:ISession):void
		{
			_realtimeChannelManager = realtimeChannelManager;
			_session = session;
		}
		
		protected function sendToPeers(command:String, ...rest):void
		{
			rest.unshift(_session.myUser.id);
			rest.unshift(command);
			_realtimeChannelManager.sendStream.send.apply(this, rest);
		}
		
		protected function sendToAllPeers(command:String, ...rest):void
		{
			rest.unshift(command);
			_realtimeChannelManager.sendStream.send.apply(this, rest);
		}
		
		protected function get realtimeChannelManager():RealtimeChannelManager
		{
			return _realtimeChannelManager;
		}
	}
}