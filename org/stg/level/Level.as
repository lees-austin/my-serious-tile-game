package org.stg.level {

	public class Level extends Object {
			
		private var _id				: Number;		private var _file			: String;
		private var _LevelChildNo	: Number;
		private var _maxPlayers		: Number;
		private var _firstChildId	: Number;		private var _name			: String;
		private var _aLevelChildren	: Array;
		
		private var _levelChild		: LevelChild;
		
		public function Level(properties:XML) {
			super();
			_id = properties.@id;
			_file = properties.@file;
			_name = properties.@name;
			_aLevelChildren = new Array();
		}
		
		public function initialize(properties:XML):void {			_maxPlayers = properties.@maxplayer;			_firstChildId = properties.@firstChildId;
			_LevelChildNo = _firstChildId;
		}
		
		public function getLevelChild():LevelChild {
			return _aLevelChildren[_LevelChildNo];
		}
	
		public function addChild(newLevelChild:LevelChild):LevelChild {
			trace("new child->"+newLevelChild);
			_aLevelChildren.push(newLevelChild);
			return newLevelChild;
		}
	
		// SETTER
		public function set id(n:Number):void { _id=n;	}		public function set maxPlayers(n:Number):void { _maxPlayers=n;	}		public function set firstChildId(n:Number):void { _firstChildId=n;	}		public function set name(s:String):void { _name=s;	}			public function set LevelChildren(a:Array):void { _aLevelChildren=a; }			public function set levelChild(lc:LevelChild):void { _levelChild=lc; }			public function set CurrentLevelChildNo(n:Number):void { _LevelChildNo=n; }	
	
		// GETTER
		public function get id():Number { return _id;	}		public function get xmlFile():String { return _file; }
		public function get maxPlayers():Number { return _maxPlayers;	}		public function get firstChildId():Number { return _firstChildId;	}		public function get name():String { return _name;	}		public function get LevelChildren():Array { return _aLevelChildren;	}		public function get levelChild():LevelChild { return _levelChild;	}		public function get CurrentLevelChildNo():Number { return _LevelChildNo;	}
				
	} // Fin de la classe
	
}