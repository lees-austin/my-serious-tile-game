﻿package org.stg.level {

	public class Level extends Object {
			
		private var _id				: Number;
		private var _LevelChildNo	: Number;
		private var _maxPlayers		: Number;
		private var _firstChildId	: Number;
		private var _aLevelChildren	: Array;
		
		private var _levelChild		: LevelChild;
		
		public function Level(properties:XML) {
			super();
			_id = properties.@id;
			_file = properties.@file;
			_name = properties.@name;
			_aLevelChildren = new Array();
		}
		
		public function initialize(properties:XML):void {
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
		public function set id(n:Number):void { _id=n;	}
	
		// GETTER
		public function get id():Number { return _id;	}
		public function get maxPlayers():Number { return _maxPlayers;	}
				
	} // Fin de la classe
	
}