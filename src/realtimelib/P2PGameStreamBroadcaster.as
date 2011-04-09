package realtimelib
{
	import realtimelib.session.P2PSession;
	
	public class P2PGameStreamBroadcaster extends StreamBroadcaster
	{
		public function P2PGameStreamBroadcaster(realtimeChannelManager:RealtimeChannelManager, session:P2PSession)
		{
			super(realtimeChannelManager, session);
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
		public function sendStartGame():void
		{
			sendToPeers("receiveStartGame");
		}
		/**
		 * send trigger to game over
		 */
		public function sendGameOver():void
		{
			sendToPeers("receiveGameOver");
		}
		
		/*
		* PLAYER MESSAGES
		*/
		/**
		 * send trigger that player is ready
		 */
		public function sendPlayerReady():void
		{
			sendToPeers("receivePlayerReady");
		}
		/**
		 * send trigger that player is out
		 */
		public function sendPlayerOut():void
		{
			sendToPeers("receivePlayerOut");
		}
		
		/*
		* MOVEMENT MESSAGES
		*/ 
		
		/**
		 * distributes message to everyone in the group
		 */
		public function sendMessage(message:String):void
		{
			sendToAllPeers("receiveMessage", message);
		}
		/**
		 * distributes mouse position to everyone in the group
		 * @param x Mouse x position.
		 * @param y Mouse y position.
		 */
		public function sendMousePositions(x:int,y:int):void
		{
			sendToPeers("receiveMousePositions", x, y);
		}
		/**
		 * distributes movement direction to everyone in the group
		 * @param direction Can be any int describing UP, DOWN, LEFT, RIGHT or FORWARD, BACKWARD, LEFT, RIGHT or their combinations UP-LEFT, UP-RIGHT and so on.
		 * @param down Information about key, if it is down or not (Boolean).
		 */
		public function sendMovement(direction:int, down:Boolean):void
		{
			sendToPeers("receiveMovement", direction, down);
		}
		/**
		 * distributes position to everyone in the group
		 * @param position Object that usually contains info about position like x, y, z and orientation, rotation, velocity.
		 */
		public function sendPosition(position:Object):void
		{
			sendToPeers("receivePosition", position);
		}
		
		/*
		* car related
		*/
		
		/**
		 * distributes rotation to everyone in the group
		 * @param rotation Number containing a rotation - for instance steering wheel rotation, accelerometer rotation in one direction or similar.
		 */
		public function sendRotation(rotation:Number):void
		{
			sendToPeers("receivePosition", rotation);
		}
		
		/**
		 * distributes speed to everyone in the group
		 * @param speed Number containing the speed of a car or similar.
		 */
		public function sendSpeed(speed:Number):void
		{
			sendToPeers("receiveSpeed", speed);
		}
		
		/**
		 * send object
		 * @param Anything
		 */
		public function sendObject(object:*):void
		{
			sendToPeers("receiveObject", object);
		}
	}
}