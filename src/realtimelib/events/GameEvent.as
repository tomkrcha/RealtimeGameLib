package realtimelib.events
{
	import flash.events.Event;
	
	/**
	 * Game status event
	 */
	public class GameEvent extends Event
	{
		public static const START_GAME:String = "startGame";
		public static const GAME_OVER:String = "gameOver";
		public static const PLAYER_READY:String = "playerReady";
		public static const PLAYER_OUT:String = "playerOut";
		
		public var playerID:String;
		public var details:Object;
		
		public function GameEvent(type:String, playerID:String, details:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.playerID = playerID;
			this.details = details;
		}
	}
}