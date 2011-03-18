package realtimelib.events
{
	import flash.events.Event;
	
	public class PeerStatusEvent extends Event
	{
		// constants
		/**
		 * 
		 */		
		public static const CONNECTED:String 		= "connected";
		
		/**
		 * 
		 */
		public static const USER_ADDED:String		= "userAdded";
		
		/**
		 * 
		 */		
		public static const USER_REMOVED:String		= "userRemoved";

		/**
		 * 
		 */
		public static const USER_IDLE:String		= "userIdle";
		
		// state
		private var m_info:Object;

		/**
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param info
		 * 
		 */		
		public function PeerStatusEvent(type:String, 
									  bubbles:Boolean=false, 
									  cancelable:Boolean=false, 
									  info:Object=null)
		{
			super(type, bubbles, cancelable);
			m_info = info;
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public override function clone():Event
		{
			return new PeerStatusEvent(type, bubbles, cancelable, m_info);
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public override function toString():String
		{
			return formatToString("PeerStatusEvent", "type", "bubbles", "cancelable", "eventPhase", "info");
		}

		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get info():Object			{ return m_info; }
		public function set info(value:Object):void	{ m_info=value; }
	}
}