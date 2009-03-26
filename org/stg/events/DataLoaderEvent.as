package org.stg.events {
	import flash.events.Event;			

	/**
	 * @author japanese cake
	 */
	public class DataLoaderEvent extends Event {
	
		public static var COMPLETE	: String = "complete";		public static var PROGRESS	: String = "progress";		public static var ERROR		: String = "error";		
		public var data				:*;
		
		public function DataLoaderEvent( type:String )
		{
			super( type, false, false );
		}
	}

}