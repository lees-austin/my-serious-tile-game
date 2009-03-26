package org.stg.game.elts.character {
	import org.stg.game.elts.tile.MovingTile;
	import org.stg.game.elts.tile.SlopeObject;
	import org.stg.globals.G_Character;
	import org.stg.globals.G_Game;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;	

	public class Character extends EventDispatcher {

		public var mc : MovieClip;
		public var clip : MovieClip;
		
		public var doorMask: Sprite;
	
		// Scrolling
		public var _pasX:Number;
		public var _pasY:Number;
		public var lastX:Number;		public var lastY:Number;		public var lastJump:Number;
		public var lastDirX:Number;
		public var lastDirY:Number;
		public var _addY:Number;
		
		// Les demis hauteurs & largeurs
		public var halfHeight:Number;
		public var halfWidth:Number;
		
		// Les coordonnées dans les tableaux et sur l'écran
		public var _i:Number;
		public var _j:Number;
		public var _ox:Number;
		public var _oy:Number;
				
		// Les vitesses
		public var speedX:Number;
		public var _accX:Number;
		public var _accY:Number;
		public var jumpInitSpeed:Number;
		public var jumpSpeed:Number;
		public var jump:Number;		public var jumpFlag:Number;
		public var climbSpeed:Number;
		
		public var _k:Number;
		public var _f:Number;
		
		public var _flag:String;
		public var _tileTarget:Number;
		public var _isMoving:Boolean=false;
		
		public var _climb:Number;
		// Direction de personnage (-1 ou 1 uniquement)
		public var dirX:Number;
		public var dirY:Number;
		
		// Door Vars
	//	public var doorDir:Number;	//	public var doorTile:DoorTile;
		
		// Variables des bords de la tuile du personnage
		public var _bHaut:Number;
		public var _bBas:Number;
		public var _bGauche:Number;
		public var _bDroit:Number;
		
		// Variables booléennes des coins du personnage
		public var cornerUpLeft:Boolean;
		public var cornerUpRight:Boolean;
		public var cornerDownLeft:Boolean;
		public var cornerDownRight:Boolean;
				public var cornerSlopeDownLeft:Boolean=false;		public var cornerSlopeDownRight:Boolean=false;
		
		private var _onSlope:SlopeObject;		public var onMovingTile:MovingTile;		public var blockMovingTile:MovingTile;		public var isOnMovingTile:Boolean=false;
		public var isBlockMovingTile:Boolean=false;		public var isOnSlope:Boolean=false;
		
		private static var _instance : Character;
		
		public static function getInstance():Character {
			return _instance;	
		}
		
		public function Character(ScreenPlayerContainerRef : MovieClip) {
			super();
			_instance = this;
			mc = ScreenPlayerContainerRef.mc;
			clip = mc.clip;
			doorMask = ScreenPlayerContainerRef.doorMask;
			trace("character mask = "+doorMask);
			onMovingTile = null;
			_onSlope = null;
			isBlockMovingTile	= false;
			isOnMovingTile		= false;
			_addY = 0;
		}

		public function init(i:Number, j:Number, dirX:Number = 1):void {		
			// On définit les vitesses			trace("character clip: "+clip);			trace("character mc: "+mc);
			speedX = 0;
			jumpInitSpeed = G_Character.MAX_SPEED_Y /2;
			_accX = G_Character.ACCX;
			_accY = G_Character.ACCY;
			climbSpeed = G_Character.CLIMB_SPEED;
			_f = G_Character.F;
			
			// On récupère les coordonnées de départ
			_i = i;
			_j = j;

			// On calcul les demis hauteur & largeur
			halfHeight = mc.height / 2;
			halfWidth = mc.width / 2;
			trace("taille: " + halfHeight);

			jump = _climb = -1;
			dirX = 1;			lastJump = 1;
			lastDirX = dirX;			lastDirY = 0;
			dirY = 1;
			// On calcul les coordonnées dans le repère oXY
			_ox = lastX = (_j*G_Game.TILE_SIZE ) + G_Game.TILE_SIZE /2;
	        _oy = lastY = (_i*G_Game.TILE_SIZE ) + G_Game.TILE_SIZE /2;
			
			// On met à jour les coordonnées
			mc.x = _ox;
			mc.y = _oy;

			_pasX = _ox;
			_pasY = _oy;
		}	
		
		public function improveJumpSpeed(dir:Number=0):void {
			jumpSpeed-=_accY;
			_accY-=0.8;
			if (_accY<0) _accY=0;
		}
		
		private function doAction(s:String):void {
			//dispatchEvent({type:s,target:this});	
		}
		
		public function get onSlope() : SlopeObject {
			//return (_onSlope == null) ? new SlopeObject() : _onSlope;			return _onSlope;
		}
		
		public function set onSlope(so:SlopeObject):void {
			_onSlope =so;
		}
	}  // Fin de la classe Personnage
	
}