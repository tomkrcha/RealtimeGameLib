package realtimelib
{
	import flash.events.IEventDispatcher;
	
	import realtimelib.events.GameEvent;

	public class P2PGameStreamReceiver
	{
		private var _eventDispatcher:IEventDispatcher;

		public function get receiveSpeedCallback():Function
		{
			return _receiveSpeedCallback;
		}

		public function set receiveSpeedCallback(value:Function):void
		{
			_receiveSpeedCallback = value;
		}

		public function get receiveRotationCallback():Function
		{
			return _receiveRotationCallback;
		}

		public function set receiveRotationCallback(value:Function):void
		{
			_receiveRotationCallback = value;
		}

		public function get receiveMousePositionCallback():Function
		{
			return _receiveMousePositionCallback;
		}

		public function set receiveMousePositionCallback(value:Function):void
		{
			_receiveMousePositionCallback = value;
		}

		public function get receivePositionCallback():Function
		{
			return _receivePositionCallback;
		}

		public function set receivePositionCallback(value:Function):void
		{
			_receivePositionCallback = value;
		}

		public function get receiveMovementCallback():Function
		{
			return _receiveMovementCallback;
		}

		public function set receiveMovementCallback(value:Function):void
		{
			_receiveMovementCallback = value;
		}

		private var _runningExplicitSetter:Function;
		private var _receiveMovementCallback:Function;
		private var _receivePositionCallback:Function;
		private var _receiveMousePositionCallback:Function;
		private var _receiveRotationCallback:Function;
		private var _receiveSpeedCallback:Function;
		
		
		public function P2PGameStreamReceiver(eventDispatcher:IEventDispatcher, runningExplicitSetter:Function)
		{
			_initializeP2PGameStreamReceiver(eventDispatcher, runningExplicitSetter);
		}
		
		private function _initializeP2PGameStreamReceiver(eventDispatcher:IEventDispatcher, runningExplicitSetter:Function):void
		{
			_eventDispatcher = eventDispatcher;
			_runningExplicitSetter = runningExplicitSetter;
		}
		
		/*
		**********************************************************************
		* RECEIVE 
		**********************************************************************
		*/ 
		
		/*
		* GAME MESSAGES
		*/
		public function receiveStartGame(peerID:String):void
		{
			_eventDispatcher.dispatchEvent(new GameEvent(GameEvent.START_GAME,peerID));
			_runningExplicitSetter(true);
		}
		
		public function receiveGameOver(peerID:String):void
		{
			_eventDispatcher.dispatchEvent(new GameEvent(GameEvent.GAME_OVER,peerID));
			_runningExplicitSetter(false);
		}
		
		/*
		* PLAYER MESSAGES
		*/
		public function receivePlayerReady(peerID:String):void
		{
			_eventDispatcher.dispatchEvent(new GameEvent(GameEvent.PLAYER_READY,peerID));
		}
		
		public function receivePlayerOut(peerID:String):void
		{
			_eventDispatcher.dispatchEvent(new GameEvent(GameEvent.PLAYER_OUT,peerID));
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
		public function receiveMovement(peerID:String, direction:int, down:Boolean):void
		{
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
	}
}