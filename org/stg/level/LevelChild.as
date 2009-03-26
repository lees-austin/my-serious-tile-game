﻿package org.stg.level {
	import org.stg.events.GameEvent;
	import org.stg.game.Screen;
	import org.stg.globals.G_Game;
	import org.stg.globals.G_Screen;
	import org.stg.globals.G_Tile;
	import org.stg.managers.LevelManager;
	import org.stg.managers.LibraryManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;	

	/**
	 * @author japanese cake
	 */
	public class LevelChild extends Sprite {
		
		private static var _instance : LevelChild;
		
		private var _id				: Number;
		
		
		private var _isFirst		: Boolean;
		
		private var _aTiles			: Array;
		private var _aMovingTiles	: Array;
		private var _aCharacters	: Array;
		
		private var _visibleX		: Number;
		
		
		private var _characterI		: Number;
		
		private var _tmp			: String;
		
		public static function getInstance():LevelChild {
			return _instance;	
		}
		
		public function LevelChild(properties:XMLList) {
			super();
			_instance = this;
			_aTiles = new Array();
			
			_id = properties.@id;
			
			
			//_skin = (_skin==undefined || _skin=="") ? Screen.SkinDefaultLink : _skin;		
		}

		public function generateGfx():void {
			trace(":: generateGfx :: ");
			
			_visibleX = G_Screen.GAME_WIDTH;
			_visibleY = G_Screen.GAME_HEIGHT;
			_halfVisX = G_Screen.HALF_GAME_WIDTH;
			_halfVisY = G_Screen.HALF_GAME_HEIGHT;
			_centerX = G_Screen.CENTER_X;
			_centerY = G_Screen.CENTER_Y;
			
			trace("doorTile: "+LevelManager.nextLevelChildDoor);
			if (LevelManager.nextLevelChildDoor == null) {
				trace("POSITION INITIAL");
				_characterI = LevelManager.getLevelChild().characters[G_Game.PLAYER_ID].i;
				_characterJ = LevelManager.getLevelChild().characters[G_Game.PLAYER_ID].j;
			}else{
				trace("POSITION DOOR");
				var newRoomId:Number = LevelManager.nextLevelChildDoor.newLevelChildID;
//				
//				
				_characterI = LevelManager.getLevel().LevelChildren[newRoomId].doorsTiles[newDoorId].i;
				_characterJ = LevelManager.getLevel().LevelChildren[newRoomId].doorsTiles[newDoorId].j;
				//_characterI = LevelManager.getLevelChild().characters[G_Game.PLAYER_ID].i;
				//_characterJ = LevelManager.getLevelChild().characters[G_Game.PLAYER_ID].j;
				trace("----------------____________---------------");
				trace("+ i="+LevelManager.getLevel().LevelChildren[newRoomId].doorsTiles[newDoorId].i);
				trace("New Character positions :"+"\n"+" + i="+_characterI+"\n"+" + j="+_characterJ);
			} 
			
			// on contrôle si on est proche d'un bord
			
				// perso tout à gauche
			if (_halfVisX>_characterJ) {
				_fixX = _characterJ-_halfVisX;
				_fixX1 = 0;
				
				// perso tout à droite
			}else if ( _characterJ>LevelManager.getLevelChild()._tileWidth-_halfVisX-1) {
				_fixX =  _characterJ-LevelManager.getLevelChild()._tileWidth+_halfVisX+2;
				_fixX1 = 1;
			}else _fixX = _fixX1 = 0;
			
				// perso tout en haut
			if (_halfVisY> _characterI) {
				_fixY =  _characterI-_halfVisY;
				_fixY1 = 0;
				
				// perso tout en bas
			}else if ( _characterI>LevelManager.getLevelChild()._tileHeight - _halfVisY-1) {
				_fixY = LevelManager.getLevelChild()._tileHeight-_characterI;
				_fixY1 = 1;
			}else _fixY = _fixY1 = 0;
			
			Screen.Elements.x = _centerX - ((_characterJ-_fixX) * G_Game.TILE_SIZE) - G_Game.TILE_SIZE/2;
			Screen.Elements.y = _centerY - ((_characterI-_fixY) * G_Game.TILE_SIZE) - G_Game.TILE_SIZE/2;
			trace("Screen.Elements.x="+Screen.Elements.x);
			Screen.Background.ratioW = Screen.Background.width/((tileWidth+_visibleX) * G_Game.TILE_SIZE);
			Screen.Background.ratioH = Screen.Background.height/((tileHeight+_visibleY) * G_Game.TILE_SIZE);
			
			Screen.Mediumground.ratioW = Screen.Mediumground.width/((tileWidth+_visibleX)*G_Game.TILE_SIZE);
			Screen.Mediumground.ratioH = Screen.Mediumground.height/((tileHeight+_visibleY)*G_Game.TILE_SIZE);
			
			Screen.Background.x = Screen.Elements.x * Screen.Background.ratioW;
			
			Screen.Mediumground.x = Screen.Elements.x * Screen.Mediumground.ratioW;
			Screen.Mediumground.y = Screen.Elements.y * Screen.Mediumground.ratioH;
			
			trace("DIM :: " + tileHeight + " | " + tileWidth);
			for (var i:Number=0;i<tileHeight;++i) {
				for (var j:Number=0;j<tileWidth;++j) {
					//trace("blop");
					if (i >= _characterI-_halfVisY-_fixY && i<=_characterI+_halfVisY+1-_fixY) {
						if (j>=_characterJ-_halfVisX-_fixX && j<=_characterJ+_halfVisX+1-_fixX) {
							if (i>=0 && j>=0 && i<= tileHeight-1 && j<=tileWidth-1) {
								_aTiles[i][j].mc = _addTile(Screen.Tiles, i,j);
							}
						}
					}		
				}
			}		
						
			// Moving Tiles
			trace("MovingTiles: "+_aMovingTiles.length);
			for (var n:Number=0; n<_aMovingTiles.length; n++) {
				var name:String ="movingTile"+n;
				_aMovingTiles[name].mc = _addMovingTile(Screen.MovingTiles,_aMovingTiles[name].i,_aMovingTiles[name].j,name,G_Game.TILE_SIZE/2);
			}
			
			dispatchEvent(new GameEvent(GameEvent.GFX_GENERATED));
		}
		
		private function _addTile(sprite:Sprite, i:Number, j:Number):DisplayObject {
			var tile = new LibraryManager.TileClassRef();
			tile.x = j*G_Game.TILE_SIZE;
			tile.y = i*G_Game.TILE_SIZE; 
			tile.name = "t_"+i+"_"+j;
			_tmp+= " "+tile.name;
			//Tile(tile).init(_aTiles[i][j]);
			var iRef:DisplayObject = sprite.addChild(tile);
			//iRef.cacheAsBitmap = true;
			//trace(iRef.name);
			MovieClip(iRef).gotoAndStop(G_Tile.getTileFrame(_aTiles[i][j].frameNumber));
			//trace(tile);
			return iRef;
		}
		
		private function _addMovingTile(sprite:Sprite, i:Number, j:Number, name, sizeFix:Number=0):DisplayObject {
			var movingTile = new LibraryManager.MovingTileClassRef();
			movingTile.x = j*G_Game.TILE_SIZE+sizeFix;
			movingTile.y = i*G_Game.TILE_SIZE+sizeFix;
			movingTile.name = name;
			var iRef:DisplayObject = sprite.addChild(movingTile);
			//MovieClip(iRef).gotoAndStop(G_Tile.getTileFrame(_aMovingTiles[i][j].frameOut));
			//MovingTileMC(iRef).init(_aMovingTiles[name]);
			//trace("+ movingTile (frameOut=" + _aMovingTiles[name].frameOut+")");
			return iRef;
		}
		
		// GETTER
		public function get id():Number { return _id;	}
		public function get backGroundLink():String { return _bgLink; }	
		public function get mediumGroundLink():String { return _mgLink; }	
		public function get tiles():Array { return _aTiles;	}
		public function get movingTiles():Array { return _aMovingTiles; }
		public function get characters():Array { return _aCharacters; }
		
		// SETTER
		public function set id(n:Number):void { _id=n;	}
		public function set skin(s:String):void { _skin=s;	}
		public function set mediumGroundLink(s:String):void { _mgLink=s; }
		public function set isFirst(b:Boolean):void { _isFirst=b; }	
		public function set tiles(a:Array):void { _aTiles=a;	}
		public function set characters(a:Array):void { _aCharacters=a; }	
		
		
	}

}