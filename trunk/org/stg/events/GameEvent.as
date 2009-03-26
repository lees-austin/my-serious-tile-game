﻿package org.stg.events {
	import flash.events.Event;			

	/**
	 * @author japanese cake
	 */
	public class GameEvent extends Event {
	
		public static var START_GAME	: String = "startGame";
		
		
		public var data:*;
		
		public function GameEvent( type:String, data:* = null )
		{
			super( type, false, false );
			this.data = data;
		}
	}

}