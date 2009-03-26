package org.stg.game {
	import it.gotoandplay.smartfoxserver.data.User;
	
	import org.stg.debug.DebugPanel;
	import org.stg.events.CharacterEvents;
	import org.stg.events.GameEvent;
	import org.stg.game.elts.character.Character;
	import org.stg.game.elts.tile.DoorTile;
	import org.stg.game.elts.tile.MovingTile;
	import org.stg.game.elts.tile.MovingTilePoint;
	import org.stg.game.elts.tile.SlopeObject;
	import org.stg.game.elts.tile.Tile;
	import org.stg.globals.G_Character;
	import org.stg.globals.G_Game;
	import org.stg.globals.G_Tile;
	import org.stg.level.LevelChild;
	import org.stg.managers.LevelManager;
	import org.stg.net.socket.SocketClient;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;	

	public final class GameEngine extends EventDispatcher {
	
		// Variable du jeu
		private const G			:Number = 1.4; // Gravité
		private const _xFriction:Number = 0.42;
		
		// Personnage du jeu
		private var _character:Character;
		
		// Variables pour le Scrolling
		private var _visibleX:Number;
		private var _visibleY:Number;
		private var _centreX:Number;
		private var _centreY:Number;
		private var _halfVisX:Number;
		private var _halfVisY:Number;
		private var fixX:Number;
		private var fixX1:Number;
		private var fixY:Number;
		private var fixY1:Number;
		
		// Move Action
		private var effectiveDirX : Number;		private var effectiveDirY : Number;
		
		// Variable pour la carte (=niveau)
		private var _levelChild:LevelChild;	
		private var _aTilesObject:Array;
		private var _aMovingTilesObject:Array;
		
		private var _nDecalageX:Number=0;
		private var _nDecalageY:Number=0;
		
		private var isPaused	: Boolean;
		
		private var startTimer	: Number;
		
		public var doorTile		: DoorTile;
				
		// Keyboard Keys:
		private var _gamePad : GamePad;
		
		private var _socketClient	: SocketClient;
		
		private static var _instance : GameEngine;
	
		public function GameEngine() {
			super();
			_instance = this;
			_gamePad = GamePad.getInstance();
			_socketClient = SocketClient.getInstance();
		}

		public static function getInstance():GameEngine {
			return _instance;
		}
		
		public static function setInstance(ge:GameEngine) {
			_instance = ge;
		}
		
		public function destroy():void {
			stop();
			try{
				LevelManager.nextLevelChildDoor.mc.clip.removeEventListener(CharacterEvents.DOOR_CLOSED, onEnteredDoor);
			}catch (e:Error) {}
			delete(this);
			_instance = null;
		}
		
		public function onEnterFrame(evt:Event= null):void {
		
			DebugPanel.getInstance().tfEffDirX.text = effectiveDirX.toString();
			DebugPanel.getInstance().tfCharSpeed.text = _character.speedX.toString();
			DebugPanel.getInstance().tfCharDirX.text = _character.dirX.toString();
			DebugPanel.getInstance().tfCharLastDirX.text = _character.lastDirX.toString();
			DebugPanel.getInstance().tfCharJump.text = _character.jump.toString();
			DebugPanel.getInstance().tfOnMovingBlockTile.text = "("+_character.isOnMovingTile.toString()+")";			DebugPanel.getInstance().tfIsOnSlope.text = "("+_character.isOnSlope.toString() + ")";
			
			if (!isPaused) {
				moveTiles();
				listenTo(_character);
				_socketClient.sendCharacter(_character);
				updatePlayers();
			}
		}
		
		public function pause(b:Boolean = true):void {
			isPaused = b;
		}
		
		public function clear():void {
			_levelChild = null;
			_character = null;
			_aTilesObject = new Array();
			_aMovingTilesObject = new Array();		
		}
	
		public function initialize():void {
			trace(":: INIT GAME START ::");
			// Initialisation du jeu
			_visibleX = LevelManager.getLevelChild().visibleX;
			_visibleY = LevelManager.getLevelChild().visibleY;
			_halfVisX = LevelManager.getLevelChild().halfVisX;
			_halfVisY = LevelManager.getLevelChild().halfVisY;
			_centreX = LevelManager.getLevelChild().centerX;
			_centreY = LevelManager.getLevelChild().centerY;
			
			fixX = LevelManager.getLevelChild().fixX;			fixX1 = LevelManager.getLevelChild().fixX1;			fixY = LevelManager.getLevelChild().fixY;			fixY1 = LevelManager.getLevelChild().fixY1;

			_aTilesObject = new Array();
	
			_levelChild = LevelManager.getLevelChild();
			_aTilesObject = LevelManager.getLevelChild().tiles;
			_aMovingTilesObject = _levelChild.movingTiles;
			
			for (var i:Number=0;i<_aMovingTilesObject.length;i++) {
				_aMovingTilesObject["movingTile"+i].firstLoop = true;
			}

			loadCharacter();
		
			isPaused = true;
			dispatchEvent(new GameEvent(GameEvent.INITIALIZED));
		}
		
		private function initListeners():void {
			//Screen.getInstance().stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);			//Support3D.getInstance().planeMaterialGameSide.addEventListener(Event.ENTER_FRAME, onEnterFrame);		}
		
		public function start():void {
			trace("start");
			//initListeners();
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			startTimer = getTimer();
			isPaused = false;
			_gamePad.enable = true;
		}

		public function stop():void {
			trace("stop");
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			isPaused = true;
			_gamePad.enable = false;
		}
		
		private function loadCharacter():void {
			_character = new Character(Screen.getPlayerMc(SocketClient.getInstance().playerid));
			trace("INIT CHARACTER :: "+Character.getInstance());
			_character = Character.getInstance();
			trace("charI="+_levelChild.characterI+" | charJ="+_levelChild.characterJ);
			_character.init(_levelChild.characterI, _levelChild.characterJ);
			_character._pasX = _character._ox-(fixX+fixX1)*G_Game.TILE_SIZE;
			_character._pasY = _character._oy-(fixY+fixY1)*G_Game.TILE_SIZE;
			fall(_character);
			scroll(_character);
		}
	
		private function changeTile(jold:Number, iold:Number, jnew:Number, inew:Number):void {
			
			var nomO:String = "t_"+iold+"_"+jold;
			var nomN:String = "t_"+inew+"_"+jnew;
			
			// On vérifie si la tuile est dans la carte
			//if (iold>=0 && jold>=0 && jold<_levelChild.tileWidth && iold<_levelChild.tileHeight) {
				if (inew>=0 && jnew>=0 && jnew<_levelChild.tileWidth && inew<_levelChild.tileHeight) {
					// On rajoute les nouvelles tuiles
					try {
						//var type:String = _aTileObject[inew][jnew].type;
						Screen.Tiles.getChildByName(nomO).name = nomN;
						MovieClip(Screen.Tiles.getChildByName(nomN)).gotoAndStop(G_Tile.getTileFrame(getTile(inew,jnew).frameNumber));
						//_aTilesObject[iold][jold].mc.name = nomN;						//_aTilesObject[inew][jnew].mc.gotoAndStop(G_Tile.getTileFrame(_aTilesObject[inew][jnew].frameNumber));
						//MovieClip(Screen.Tiles[nomN]).gotoAndStop(G_Tile.getTileFrame(_aTilesObject[inew][jnew].frameNumber));												//_aTilesObject[iold][jold].mc.gotoAndStop(G_Tile.getTileFrame(_aTilesObject[inew][jnew].frameNumber));
						//Screen.Tiles[nomN].changeTo(_aTilesObject[inew][jnew]);
						//trace("CHANGETO :: "+_aTilesObject[inew][jnew].mc.name);
						Screen.Tiles.getChildByName(nomN).x = jnew*G_Game.TILE_SIZE;
						Screen.Tiles.getChildByName(nomN).y = inew*G_Game.TILE_SIZE;
						_aTilesObject[inew][jnew].mc = Screen.Tiles.getChildByName(nomN);
					} catch(e:Error) {
						
					}
					
					
//					_aTilesObject[inew][jnew].mc.x = jnew*G_Game.TILE_SIZE;//					_aTilesObject[inew][jnew].mc.y = inew*G_Game.TILE_SIZE;
					//_aTilesObject[inew][jnew].mc = Screen.Tiles[nomN];
				}
			//}
		}
			
		private function listenTo(objet:Character):void {
			
			// Init cycle
			objet.dirX = 0;			objet.dirY = 0;
			
			if (_gamePad.left) {
				objet.dirX = -1;
				if (!checkMovingTiles(1)) {
					objet.isOnMovingTile=false;
					objet.isBlockMovingTile=false;
				}
			}
			if (_gamePad.right) {
				objet.dirX = 1;
				if (!checkMovingTiles(1)) {
					objet.isOnMovingTile=false;
					objet.isBlockMovingTile=false;
				}
			}
			if (_gamePad.jump) {
				if (objet.jump==-1) {
					//On saute !
					objet.jump = 1;
					objet.isOnMovingTile=false;					objet.isBlockMovingTile=false;
					objet._accY = G_Character.ACCY;
					objet.jumpSpeed = objet.jumpInitSpeed;
				}else{
					//trace("jump while jumping !");
					if (objet.jumpSpeed>G_Character.MAX_SPEED_Y) objet.improveJumpSpeed();
				}
			}
			if (_gamePad.up) {
				if(objet.jump!=1 && checkUpLadder(objet) && Math.abs(objet.speedX) < 0.05) {
					climb(objet,-1);
				}else objet._climb=-1;
				
					if (getTile(objet._i,objet._j).door && objet==_character && getTimer()>startTimer + G_Game.INIT_DELAY && Math.abs(objet.speedX) < 0.2) {
						
						// on vérifie que le personnage touche bien le sol
						getCharacterCorners(objet, objet._ox, objet._oy+1);
						
						if (objet.cornerDownRight==false || objet.cornerDownLeft==false) {
							trace("openDoor","door enabled="+DoorTile(getTile(objet._i,objet._j)).enabled);							if (DoorTile(getTile(objet._i,objet._j)).enabled) {
								//if (_aTilesObject[objet._i][objet._j].lock) _aTilesObject[objet._i][objet._j].enabled = false;
								openDoor(objet,DoorTile(getTile(objet._i,objet._j)));
								return;
							}
						}
					}
			}
			if (_gamePad.down) {
				if(objet.jump!=1 && checkDownLadder(objet)) climb(objet,1);
				else objet._climb=-1;
			}
			
			
			if (_gamePad.run) {
				G_Character.MAX_SPEED_X = G_Character.RUN_SPEED; 
				objet._accX = G_Character.ACCX*1.4;
			}else{
				G_Character.MAX_SPEED_X = G_Character.WALK_SPEED;
				objet._accX = G_Character.ACCX;
			}
			
			// DO JUMP
			if (objet.jump == 1) jump(objet);
			
			// Move Character
			move(objet,objet.dirX,objet.dirY, objet.jumpFlag);
					
			// Character MovieClip Animation
			if (!_gamePad.keyPressed) {
			
				if (objet._climb == 1) {
					if (objet.lastDirX ==  1) objet.mc.gotoAndStop(G_Character.CLIMB_RIGHT_FRAME);
					if (objet.lastDirX == -1) objet.mc.gotoAndStop(G_Character.CLIMB_LEFT_FRAME);
					objet.mc.clip.stop();
				}else if (objet.jump == 1) {
					if (objet.lastDirX ==  1 ) objet.mc.gotoAndStop(G_Character.JUMP_RIGHT_FRAME);
					if (objet.lastDirX == -1 ) objet.mc.gotoAndStop(G_Character.JUMP_LEFT_FRAME);
				}else{
					if (objet.lastDirX ==  1 ) objet.mc.gotoAndStop(G_Character.STOP_RIGHT_FRAME);
					if (objet.lastDirX == -1 ) objet.mc.gotoAndStop(G_Character.STOP_LEFT_FRAME);

				}
			}
		}

		private function openDoor(character:Character,door:DoorTile):void {
			stop();
						LevelManager.nextLevelChildDoor = door;
			
			var doorMC:MovieClip = door.mc.clip;
			var dir:Number;
			
			doorMC.gotoAndPlay("_open");
			
			if (character.mc.x < door.mc.x + G_Game.TILE_SIZE/2) {
				dir=1;
				character.mc.gotoAndStop("_openDoorRight");
			}else{
				dir=-1;
				character.mc.gotoAndStop("_openDoorLeft");
			}

			character.doorMask.x = door.mc.x;
			character.doorMask.x -= dir * (G_Game.TILE_SIZE/2+3);			character.doorMask.y = door.mc.y;
			character.mc.mask = character.doorMask;
			doorMC.addEventListener(CharacterEvents.DOOR_CLOSED, onEnteredDoor);
		}
		
		private function onEnteredDoor(evt:Event):void {
			trace("onEnteredDoor");
			LevelManager.nextLevelChildDoor.mc.removeEventListener(CharacterEvents.DOOR_CLOSED, onEnteredDoor);
			dispatchEvent(new GameEvent(GameEvent.CHANGE_ROOM));
		}
	
		private function checkIfOnCloud(objet:Character):Boolean {
			var bBG:Boolean;
			var bBD:Boolean;
			try {
				if (objet.jumpFlag == 1) {
					bBG = getTile(objet._bBas,objet._bGauche).cloud;
					bBD = getTile(objet._bBas,objet._bDroit).cloud;
				}else bBG = bBD = false;
			} catch (e:Error) {
				bBG = bBD = false;
			} finally {
				return ((bBG || bBD) && objet._i != objet._bBas) ? true : false;
			}
			//trace("checkIfOnCloud : BG="+bBG+" | BD="+bBD);
			//return ( (bBG || bBD) && (!objet._bHaut!= objet._bBas) ) ? true : false;
			//trace("HAUT="+objet._bHaut+" | BAS="+objet._bBas);
			//if (objet._bHaut!=objet._bBas) trace("DIFF !");
		}
	
		private function checkUpLadder(objet:Character):Boolean {
			var downY:Number = Math.floor((objet._oy+objet.halfHeight-1)/ G_Game.TILE_SIZE);
			var upY:Number = Math.floor(((objet._oy-objet.halfHeight)-objet.climbSpeed)/G_Game.TILE_SIZE);
			var upLadder:Boolean = getTile(upY,objet._j).ladder;
			var downLadder:Boolean = getTile(downY,objet._j).ladder;
			var upBlock:Boolean = getTile(upY,objet._j).walkable;
			//trace("échelle en haut ?  "+upLadder);
			return (upLadder || ( upBlock && downLadder));
		}
		
		private function checkDownLadder(objet:Character):Boolean {
			var downY:Number = Math.floor((objet.climbSpeed+objet._oy+objet.halfHeight)/ G_Game.TILE_SIZE);
			var downLadder:Boolean = getTile(downY,objet._j).ladder;
			//trace("échelle en bas ?  "+downLadder);
			var result:Boolean = false;
			//if (!downLadder) fall(objet);
			return downLadder;
		}
		
		private function checkForSlope(objet:Character, dirY:Number, dirX:Number, forceSlope:Boolean=false):void {

			if (getTile(objet._i+1,objet._j).isSlope() && (objet.jumpFlag==0 || objet.jump == -1)) {
				objet._i  += 1;
				objet._oy += G_Game.TILE_SIZE-objet._addY ;
				//forceSlope = true;
				//trace(":: slope below ! addY="+objet._addY);		
				DebugPanel.getInstance().tfIsOnSlope.text = "-1";
			}
			DebugPanel.getInstance().tfCharI.text = objet._i.toString();			DebugPanel.getInstance().tfCharJ.text = objet._j.toString();
			
			if (getTile(objet._i,objet._j).isSlope() && dirY != -1) {

				if (dirY==1) objet._oy = (objet._i + 1) * G_Game.TILE_SIZE - objet.halfHeight;

				var posX:Number = objet._ox-objet._j * G_Game.TILE_SIZE;
				objet.onSlope = getTile(objet._i,objet._j).slope;
				objet.isOnSlope = true;
				objet.jumpFlag = 0;
				objet.jump = -1;
				objet._addY = 0;
				
				if (posX<0) posX = 0;				if (posX>G_Game.TILE_SIZE) posX = G_Game.TILE_SIZE;
				
				if (objet.onSlope.left) {
					objet._addY = G_Game.TILE_SIZE-posX;

					if (objet._addY<0) objet._addY = 0;
					objet._oy = (objet._i + 1) * G_Game.TILE_SIZE-objet.halfHeight-objet._addY;

				}else if (objet.onSlope.right) {
					objet._addY = posX;

					if (objet._addY<0) objet._addY = 0;
					objet._oy = (objet._i + 1) * G_Game.TILE_SIZE-objet.halfHeight-objet._addY;

				}
				
			}else{
				if (objet.isOnSlope) {
					if( ((objet.onSlope.right && dirX==1) || (objet.onSlope.left && dirX==-1)) && forceSlope ) {
						objet._i  -= 1;
						objet.jumpFlag = 0;
						objet.jump = -1;
					}
					
				}//else objet._addY = 0;
					objet.isOnSlope = false;
			}
			
			DebugPanel.getInstance().tfIsOnSlope.text = objet.isOnSlope.toString();
		}

		private function climb(objet:Character, dirY:Number):void {
			trace("CLIMB ("+dirY+")");
			objet._climb=1;
			objet.isOnMovingTile=false;
			objet._oy += objet.climbSpeed*dirY;
			objet._ox = (objet._j * G_Game.TILE_SIZE) + G_Game.TILE_SIZE/2;
			//move(objet,0,dirY,0);
			updateChar(objet, 0, dirY,0);
			scroll(objet);
		}
		
		private function jump(objet:Character):void {	
			// Gestion de la gravité
			objet._climb  = -1; 
			objet.jumpSpeed += G;
			
			//objet.speedX -= _xFriction * effectiveDirX;
			
			if (objet.jumpSpeed > -G_Character.MAX_SPEED_Y) {
				objet.jumpSpeed = -G_Character.MAX_SPEED_Y;  
			}
			
			if (objet.jumpSpeed < 0) {
				// On monte
				objet.dirY = -1;
				objet.jumpFlag = -1;
			}else if (objet.jumpSpeed > 0) {
				// On descend
				objet.dirY = 1;
				objet.jumpFlag = 1;
//				objet.speedX -= _xFriction * effectiveDirX;
//				if (
//					(objet.speedX < 0 && effectiveDirX == 1)
//					||
//					(objet.speedX > 0 && effectiveDirX == -1)
//				   ) 
//					objet.speedX=0;
			}else objet.jumpFlag = 0;
		}

		private function fall(objet:Character):void {
			// Quand on est pas en train de sauter
			objet._climb = -1;
			if (objet.jump==-1) {
				getCharacterCorners(objet, objet._ox, objet._oy+1);
				// S'il n'y a rien en dessous
				if (objet.cornerDownLeft && objet.cornerDownRight && !checkMovingTiles(1) && !checkIfOnCloud(objet)) {
					objet.jumpSpeed = 0;
					objet.jump = 1;
					objet._climb = -1;
					objet.isOnMovingTile = false;
				}
			}
			
		}
	
		private function getTile(i:Number, j:Number):Tile {
			var tile:Tile;
			try {			
				tile = _aTilesObject[i][j];
			} catch (e:Error) {
				tile = new Tile();	
			} finally {
				return tile;
			}	
		}
		
		private function getCharacterCorners(objet:Character, x:Number=0, y:Number=0):void {
			objet._bHaut	= Math.floor( (y - objet.halfHeight) / G_Game.TILE_SIZE);
			objet._bBas 	= Math.floor( (y + objet.halfHeight-1) / G_Game.TILE_SIZE);
			objet._bGauche	= Math.floor( (x - objet.halfWidth) / G_Game.TILE_SIZE);
			objet._bDroit	= Math.floor( (x + objet.halfWidth-1) / G_Game.TILE_SIZE);
			
			try {
				objet.cornerUpLeft    = _aTilesObject[objet._bHaut][objet._bGauche].walkable;
				objet.cornerUpRight   = _aTilesObject[objet._bHaut][objet._bDroit].walkable;
				objet.cornerDownLeft  = _aTilesObject[objet._bBas][objet._bGauche].walkable;
				objet.cornerDownRight = _aTilesObject[objet._bBas][objet._bDroit].walkable;
				
			} catch (e : Error) {
				//trace("ERROR :: getCharacterCorners");
				objet.cornerUpLeft = objet.cornerDownLeft = objet.cornerUpRight = objet.cornerDownRight = false;
				
				if (Math.abs(objet.jump) == 1) {
					objet.cornerUpLeft = objet.cornerUpRight = objet.cornerDownLeft = objet.cornerDownRight = true;
					if (objet._j<=0) {
						objet.cornerUpLeft = objet.cornerDownLeft = false;
						//trace("ERROR :: blocage à gauche");
					}
					if (objet._j>=_levelChild.tileWidth-1) {
						objet.cornerUpRight = objet.cornerDownRight = false;
						//trace("ERROR :: blocage à droite");
					}
				}			
				
			} finally {
					DebugPanel.getInstance().mcDebugChar.updateCharCorner(objet);	
			}
			
			//objet._nearTop = (y + objet.halfHeight-1 <= ((objet._bBas)*G_Game.TILE_SIZE+1*G_Game.TILE_SIZE/4)) ? true: false;
			//trace(objet._nearTop);
		}
		
		private function onHitTile(i:Number, j:Number):void {
			var nom:String = "t_"+i+"_"+j;
			trace("Action sur "+nom);
			//Screen.Tiles.getChildByName(nom);
		}
		
		private function checkIfFrontSlope(objet:Character, dirX:Number):Boolean {
			var result:Boolean;
			try {
				if (dirX == 1) {
					var HD:Boolean = getTile(objet._bHaut,objet._bDroit).slope.left;
					var BD:Boolean = getTile(objet._bBas,objet._bDroit).slope.left;
					result = (HD && BD) ? true:false;						//return false;	
				}
				if (dirX == -1) {
					var HG:Boolean = getTile(objet._bHaut,objet._bGauche).slope.right;
					var BG:Boolean = getTile(objet._bBas,objet._bGauche).slope.right;
					result = (HG && BG) ? true:false;						//return false;	
				}
			} catch (e:Error) {
				result = false;
			}finally {	
				return result;
			}			
		}
		
		private function checkMovingTiles(y:Number):Boolean {
			
			var foundIt:Boolean = false;
			// on regarde que le perso n'est pas en train de monter (saut)
			if (_character.dirY!=-1  && _character._climb !=1) {
				
				var characterYMax:Number = _character._oy+_character.halfHeight+y;
				var characterYMin:Number = _character._oy-_character.halfHeight;				var characterXMax:Number = _character._ox+_character.halfWidth;
				var characterXMin:Number = _character._ox-_character.halfWidth;
				
	//			trace("characterYMax="+characterYMax);
	//			trace("characterXMax="+characterXMax);
	//			trace("characterXMin="+characterXMin);
//				trace(":: check :: l="+_aMovingTilesObject.length);		
//				trace(":: check :: e="+_aMovingTilesObject["movingTile0"]);		
				for (var i:Number=0; i<_aMovingTilesObject.length;i++) {
					
					var o:MovingTile = _aMovingTilesObject["movingTile"+i];			
					var tileYMax:Number = o.oy+o.halfHeight;
					var tileYMin:Number = o.oy-o.halfHeight;
					var tileXMax:Number = o.ox+o.halfWidth;
					var tileXMin:Number = o.ox-o.halfWidth;
					
					//for (var p in o) trace("+ "+p+" = "+o[p]); 
	//				trace("movingTile"+i+" = "+o.oy);
	//				trace("movingTile"+i+" = "+o.ox);
	//				trace("tileYMax="+tileYMax);
	//				trace("tileYMin="+tileYMin);
	//				trace("tileXMax="+tileXMax);
	//				trace("tileXMin="+tileXMin);
					
					if (_character.lastY+_character.halfHeight<=tileYMin) {
						if (characterYMax<=tileYMax && characterYMax>=tileYMin) {
							
							if(characterXMax> tileXMin && characterXMax< tileXMax) {
								//_character.onMovingTile=null;
								_character.onMovingTile=o;
								_character.isOnMovingTile=true;
								foundIt=true;
								break;
							}else if (characterXMin>tileXMin && characterXMin<tileXMax) {
								//_character.onMovingTile=null;
								_character.onMovingTile=o;
								_character.isOnMovingTile=true;
								foundIt=true;
								break;
							}
						}
					}
					if (o.block && characterYMin>=tileYMin && characterYMin<=tileYMax && 1==2) {

						try{
							if (_character._ox+_character.halfWidth*_character.dirX>=o.ox+o.halfWidth*o.dir*o.stepping.dirX ) {
								//trace("moving tile collision");
								//_character.blockMovingTile=null;
								_character.blockMovingTile=o;
								_character.isBlockMovingTile=true;
								break;
							}else{
								//_character.blockMovingTile=null;
								_character.isBlockMovingTile=false;
							}
						}catch(e:Error) {}
						
					}
							
				}
			}
			
			return(foundIt);
		}
		
		// @return speedX
		private function accelerateX(character : Character, dirX : Number, jump:Number) : Number {
			var speed : Number = 0;
			//effectiveDirX = dirX; // direction effective			
			getCharacterCorners(character, character._ox+dirX, character._oy);

			if (dirX == 0) {
				effectiveDirX = character.lastDirX;
				speed = 2*character.speedX/3;
				
				//if ( (character.lastDirX == 1 && character.speedX <= 1) || (character.lastDirX ==-1 && character.speedX>=-1) ){
				if (Math.abs(speed) < 0.01) {
					speed = 0;
					effectiveDirX = 0;
				}
			}else if ( (dirX == 1 && character.cornerDownRight && character.cornerUpRight)
					 || 
					   (dirX == -1 && character.cornerDownLeft && character.cornerUpLeft) 
					 || character.isOnSlope) {
					
				// TODO !	
				if (character.jump == 1) {
					character._accX = G_Character.ACCX*.5;
//					character._accX = 3*character._accX/5;
//					speed = character.speedX + character._accX*dirX;
				}else {
					character._accX = G_Character.ACCX;
				}
				//if ( (speed > 6 && dirX == -1) || (speed < 6 && dirX == 1) ) speed = 6*dirX;
				
					speed = character.speedX + character._accX*dirX;
				
					
					//speed -= _xFriction * dirX;
					//if ((speed + character.speedX)*dirX < 6) speed = 6 * dirX;
				//}	
				
				if (speed > 0) effectiveDirX = 1;				else if (speed < 0) effectiveDirX = -1;
				else effectiveDirX = 0;
				if (Math.abs(speed) > G_Character.MAX_SPEED_X) speed = G_Character.MAX_SPEED_X*effectiveDirX;
				
			}else{
				effectiveDirX = 0;
				speed = 0;
			}

			character.speedX = speed;
			return speed;
		}
		
		private function move(objet:Character, dirX:Number, dirY:Number, jump:Number):Boolean {
			
			objet.lastY = objet._oy;
			objet.lastJump = jump;
			
			var speedX:Number;
			var speedY:Number;
			
			// Est-ce qu'on est en train de sauter ?
			
			// vY
			speedY = objet.jumpSpeed*jump;
			
			// vX
			getCharacterCorners(objet, objet._ox, objet._oy);
			//if ( (objet.cornerDownLeft && objet.cornerUpLeft && dirX==-1) || (objet.cornerDownRight && objet.cornerUpRight && dirX==1) )
			speedX = accelerateX(objet,dirX, jump); // & update effectiveDirX
			//else speedX = objet.speedX = 0;			// Mouvement vertical //
			
			getCharacterCorners(objet, objet._ox, objet._oy+speedY*dirY);
			
			// Monte
			if (dirY == -1) {
				objet.lastDirY = objet.dirY;
				if ((objet.cornerUpLeft && objet.cornerUpRight) || (objet._climb==1 && checkUpLadder(objet))) {
					// Pas de mur !
					objet._oy += speedY*dirY;
				}else{
					// Touche le mur et place le perso proche du mur
					objet._oy = objet._i * G_Game.TILE_SIZE + objet.halfHeight;
					objet.jumpSpeed = 0;
					onHitTile(objet._i-1,objet._j);
				}
			}
	
			// Tombe
			if (dirY == 1) {
				objet.lastDirY = objet.dirY;
				if ( (objet.cornerDownLeft && objet.cornerDownRight && !checkMovingTiles(speedY*dirY) && !checkIfOnCloud(objet) ) || (objet._climb==1 && checkDownLadder(objet))) {
					objet._oy += speedY*dirY;
				}else{
					//trace("end fall");
					objet.jump = -1;
					if (objet.isOnMovingTile) objet._oy = objet.onMovingTile.oy-objet.onMovingTile.halfHeight-objet.halfHeight;
					else {
						objet._oy = (objet._i+1)*G_Game.TILE_SIZE - objet.halfHeight;
					}
				}
			}
			
			// Mouvement horizontal //
			getCharacterCorners(objet, objet._ox+speedX, objet._oy);
			
			// Gauche
			if (effectiveDirX == -1) {
				if (effectiveDirX == dirX) objet.lastDirX = effectiveDirX;
				else if (dirX != 0) objet.lastDirX = dirX;
				if ( (objet.cornerDownLeft && objet.cornerUpLeft && !checkIfFrontSlope(objet, effectiveDirX)) || objet.isOnSlope) {
					//objet._ox += vitesse*dirX;
					//accelerateX(objet);
					objet._ox += speedX;
					fall(objet);
				}else{
					objet._ox = objet._j*G_Game.TILE_SIZE + objet.halfWidth;
					effectiveDirX = 0;
					objet.speedX = 0;
				}
				
			}
			// Droite
			if (effectiveDirX == 1) {
				if (effectiveDirX == dirX) objet.lastDirX = effectiveDirX;
				else if (dirX != 0) objet.lastDirX = dirX;
				if ( (objet.cornerUpRight && objet.cornerDownRight && !checkIfFrontSlope(objet, effectiveDirX)) || objet.isOnSlope) {
					//objet._ox += vitesse*dirX;
					//accelerateX(objet);
					objet._ox += speedX;
					fall(objet);
				}else{
					objet._ox = (objet._j+1)*G_Game.TILE_SIZE - objet.halfWidth;
					effectiveDirX = 0;
					objet.speedX = 0;
				}
			}
			
			checkForSlope(objet, objet.dirY, effectiveDirX);
			
			updateChar(objet, objet.dirX, objet.dirY, objet.jumpFlag);
			
			scroll(objet);
			
			return true;
			
		} // Fin de la méthode bouge
	
		private function scroll(objet:Character):void {
//			trace("scroll");
//			trace("ELEMENTS.width=" + Screen.Layers.width);
//			trace("ELEMENTS.height="+Screen.Layers.height);
//			trace("Tiles.width=" + Screen.Tiles.width);
//			trace("Tiles.height="+Screen.Tiles.height);
			var oldXTilesMc:Number = Screen.Layers.x;
			var oldYTilesMc:Number = Screen.Layers.y;
			
			var j : Number, jnew : Number, jold : Number;
			
			// Scrolling Horizontal
			if (objet._ox >_halfVisX*G_Game.TILE_SIZE + G_Game.TILE_SIZE/2) {
				if (objet._ox<(_levelChild.tileWidth-_halfVisX)*G_Game.TILE_SIZE-G_Game.TILE_SIZE/2) {
						
						//trace("Character._ox : "+objet._ox);
						//trace("gameScreen.mcTiles._x    : "+gameScreen.mcTiles._x);
						
						// On deplace toute la scène
						Screen.Layers.x = _centreX-objet._ox;
						if (Screen.Layers.x>0) Screen.Layers.x = 0;
						//mcBackGround._x = Screen.Layers._x*(mcBackGround.ratioW);
						//mcMediumGround._x = Screen.Layers._x*(mcMediumGround.ratioW);
						_nDecalageX = (objet._ox-_centreX);
						//scrollGround(_nDecalageX,0);
						
					// On regarde les tuiles qui doivent être déplacées...
					if (objet._pasX<objet._ox-G_Game.TILE_SIZE) {
							j = Math.floor(objet._pasX/G_Game.TILE_SIZE)+1;
							jnew = j+_halfVisX+1;
							jold = j-_halfVisX-1;
							fixY = Math.round(((_centreY-objet._oy)-Screen.Layers.y)/G_Game.TILE_SIZE);
							//trace("-------- X scroll");
							for (var i:Number = objet._i-_halfVisY-1+fixY; i<=objet._i+_halfVisY+1+fixY; ++i) {
								changeTile(jold, i, jnew, i);
							}
							
							objet._pasX = objet._pasX+G_Game.TILE_SIZE;
					}else if (objet._pasX>objet._ox) {
							j = Math.floor(objet._pasX/G_Game.TILE_SIZE);
							jnew = j-_halfVisX-1;
							jold = j+_halfVisX+1;
							fixY = Math.round(((_centreY-objet._oy)-Screen.Layers.y)/G_Game.TILE_SIZE);
							//trace("-------- X scroll");
							for (var i:Number = objet._i-_halfVisY-1+fixY; i<=objet._i+_halfVisY+1+fixY; ++i) {
								changeTile(jold, i, jnew, i);
							}
							
							objet._pasX = objet._pasX-G_Game.TILE_SIZE;
						}
					}else{
						Screen.Layers.x = (_visibleX-_levelChild.tileWidth) * G_Game.TILE_SIZE;
						//mcBackGround._x = -mcBackGround._width+(_halfVisX*2+1)*G_Game.TILE_SIZE;
					}
				}else{
					Screen.Layers.x = 0;
					//mcBackGround._x = 0;
					//mcBackGround._x = _halfVisX*G_Game.TILE_SIZE;
				}
	
			
			var i : Number, inew : Number, iold : Number;
			
			// Scrolling Vertical
			if (objet._oy-objet.halfHeight-_halfVisY * G_Game.TILE_SIZE > 0) {
				if (objet._oy+objet.halfHeight+_halfVisY * G_Game.TILE_SIZE < _levelChild.tileHeight * G_Game.TILE_SIZE) {
					//trace("Character._oy : "+objet._oy);
					Screen.Layers.y = _centreY-objet._oy;
					if (Screen.Layers.y>0) Screen.Layers.y =0;
					_nDecalageY = objet._oy - _centreY;
					//scrollGround(0,_nDecalageY);
	
					if (objet._pasY<objet._oy-G_Game.TILE_SIZE) {
						i = Math.floor(objet._pasY/G_Game.TILE_SIZE)+1;
						inew = i+_halfVisY+1;
						iold = i-_halfVisY-1;
						fixX = Math.round(((_centreX-objet._ox)-Screen.Layers.x)/G_Game.TILE_SIZE);
						//trace("-------- Y scroll");
						for (var i:Number = objet._j-_halfVisX-1+fixX; i<=objet._j+_halfVisX+1+fixX; ++i) {
							changeTile(i, iold, i, inew);
						}
						objet._pasY = objet._pasY+G_Game.TILE_SIZE;
					
					}else if (objet._pasY>objet._oy) {
						i = Math.floor(objet._pasY/G_Game.TILE_SIZE);
						inew = i-_halfVisY-1;
						iold = i+_halfVisY+1;
						fixX = Math.round(((_centreX-objet._ox)-Screen.Layers.x)/G_Game.TILE_SIZE);
						//trace("-------- Y scroll 2");
						for (var i:Number = objet._j-_halfVisX-1+fixX; i<=objet._j+_halfVisX+1+fixX; ++i) {
							changeTile(i, iold, i, inew);
						}
						objet._pasY = objet._pasY-G_Game.TILE_SIZE;
						
					}
				}else Screen.Layers.y = (_visibleY-_levelChild.tileHeight) * G_Game.TILE_SIZE;
			}else{
				Screen.Layers.y = 0;
			}
			
			var newXTilesMc:Number = Screen.Layers.x;
			var newYTilesMc:Number = Screen.Layers.y;
			
			scrollGround(oldXTilesMc-newXTilesMc,oldYTilesMc-newYTilesMc);
		}
	
		private function scrollGround(scrollX:Number=0, scrollY:Number=0):void {
			//trace("scrollX="+scrollX);			//trace("scrollY="+scrollY);
			// horizontal scrolling
			if (scrollX!=0) {
				
				Screen.Background.x -= scrollX*Screen.Background.ratioW;
				Screen.Mediumground.x -= scrollX*Screen.Mediumground.ratioW;
				
				if (scrollX>0 && Screen.Background.x+Screen.Background.width < _visibleX*G_Game.TILE_SIZE) {
					Screen.Background.x = _visibleX*G_Game.TILE_SIZE-Screen.Background.width;
				}else if (scrollX<0 && Screen.Background.x > 0) {
					Screen.Background.x = 0;
				}
				//trace("test "+Screen.Background.ratioW);
				if (scrollX>0 && Screen.Mediumground.x+Screen.Mediumground.width < _visibleX*G_Game.TILE_SIZE) {
					Screen.Mediumground.x = _visibleX*G_Game.TILE_SIZE-Screen.Mediumground.width;
				}else if (scrollX<0 && Screen.Mediumground.x > 0) {
					Screen.Mediumground.x = 0;
				}
			}
			
			// vertical scrolling
			if (scrollY!=0) {
				Screen.Background.y -= scrollY*Screen.Background.ratioH;
				Screen.Mediumground.y -= scrollY*Screen.Mediumground.ratioH;
				
				if (scrollY>0 && Screen.Background.y+Screen.Background.height < _visibleY*G_Game.TILE_SIZE) {
					Screen.Background.y = _visibleY*G_Game.TILE_SIZE - Screen.Background.height;
				}else if (scrollY<0 && Screen.Background.y > 0) {
					Screen.Background.y = 0;
				}
				//trace("test "+Screen.Background.ratioW);
				if (scrollY>0 && Screen.Mediumground.y+Screen.Mediumground.height < _visibleY*G_Game.TILE_SIZE) {
					Screen.Mediumground.y = _visibleY*G_Game.TILE_SIZE - Screen.Mediumground.height;
				}else if (scrollY<0 && Screen.Mediumground.y > 0) {
					Screen.Mediumground.y = 0;
				}
			}
		}
	
		private function moveTiles():void {
		//	try {
			// Bouge les moving tiles
			for (var i:Number=0; i<_aMovingTilesObject.length;i++) {
				
				var o:MovingTile=_aMovingTilesObject["movingTile"+i];
				var bX:Boolean = false;
				var bY:Boolean = false;
				var currentX:Number = 0;
				var currentY:Number = 0;
				var maxX:Number = 0;
				var maxY:Number = 0;
				var maxJ:Number = 0;
				var maxI:Number = 0;
				
				if(o.firstLoop==true) {
					o.dir = 1;
					o.currentPoint = 0;
					o.startJ = o.j;
					o.startI = o.i;
					o.firstLoop = false;
					trace("Départ : o.stepping = "+ o.currentPoint+" ("+o.dir+")");
				}
				
				//o.stepping = new MovingTilePoint(o.points[o.currentPoint]);				o.stepping = o.points[o.currentPoint];
				
				if (o.stepping.dirX!=0) {
					currentX = o.ox+o.stepping.speedX*o.stepping.dirX*o.dir;
					maxJ = o.startJ+o.stepping.j*o.stepping.dirX*o.dir;
					maxX = maxJ*G_Game.TILE_SIZE+G_Game.TILE_SIZE/2;
					o.stepping.characterSpeedX = o.stepping.speedX*o.stepping.dirX*o.dir;
				}
				if (o.stepping.dirY!=0) {
					currentY = o.oy+o.stepping.speedY*o.stepping.dirY*o.dir;
					maxI = o.startI+o.stepping.i*o.stepping.dirY*o.dir;
					maxY = maxI*G_Game.TILE_SIZE+G_Game.TILE_SIZE/2;
					o.stepping.characterSpeedY = o.stepping.speedY*o.stepping.dirY*o.dir;
				}
				
				
				if ( (currentX>=maxX && o.dir*o.stepping.dirX==1) || (currentX<=maxX && o.dir*o.stepping.dirX==-1) ) {
					o.speedFixX = -Math.abs(currentX-maxX)*o.dir*o.stepping.dirX;
					o.stepping.characterSpeedX+=o.speedFixX;
					//trace("o.dir="+o.dir+" & dirX="+o.stepping.dirX);
					//trace("New X : "+currentX+"->"+maxX);
					currentX = maxX;
					//trace("FixX="+o.speedFixX);
				}//else trace("Old X :",currentX,maxX);
				
				if ( (currentY>=maxY && o.dir*o.stepping.dirY==1) || (currentY<=maxY && o.dir*o.stepping.dirY==-1) ) {
					o.speedFixY = -Math.abs(currentY-maxY)*o.dir*o.stepping.dirY;
					o.stepping.characterSpeedY+=o.speedFixY;
					currentY = maxY;
					//trace("FixY="+o.speedFixY);
					//trace("New Y :",currentY,maxY);
				}//else trace("Old Y :",currentY,maxY);
				
				
				if (o.stepping.dirY!=0) {
					//trace("			","bouge en Y");
					if (currentY==maxY) {
						o.startI = maxI;
						bY=true;
					}
				}else bY=true;
				
				
				if (o.stepping.dirX!=0) {
					//trace("			","bouge en X");
					if (currentX==maxX) {
						o.startJ = maxJ;
						bX=true;
					}
				}else bX=true;
				
				if (bX && bY) {
					if ( (o.currentPoint==o.points.length-1 && o.dir==1) || (o.currentPoint==0 && o.dir == -1) ) {
						//trace("Reverse !");
						o.dir*=-1;
						if (o.currentPoint==0 && o.dir == 1) {
							o.startJ = o.j;
							o.startI = o.i;
						}
					
					}else o.currentPoint+=o.dir;
				}
				
				o.mc.gotoAndStop(o.frameOut);
				
				if (o.stepping.dirX!=0) {
					o.ox = currentX;
					o.mc.x = currentX;
				}
				if (o.stepping.dirY!=0) {
					o.oy = currentY;
					o.mc.y = currentY;
				}
				
				if (o.stepping.dirY*o.dir==-1) checkMovingTiles(0);
			}
			
			//} catch (e:Error) {}
			// Vérifie si le perso est sur une moving tile
			if (_character.isOnMovingTile) {
				//trace("IS ON MV TILE !");
				_character.onMovingTile.mc.gotoAndStop(_character.onMovingTile.frameOver);
					//for (var i in _character.onMovingTile) trace("* "+i+" = "+_character.onMovingTile[i]);
					//trace("ca marche ? "+_character.onMovingTile.dir);
				getCharacterCorners(_character, _character._ox, _character._oy + _character.onMovingTile.stepping.characterSpeedY);
				
				if (_character.onMovingTile.stepping.dirY*_character.onMovingTile.dir==-1) {
					if (_character.cornerUpLeft && _character.cornerUpRight) {
						_character._oy = _character.onMovingTile.oy-_character.onMovingTile.halfHeight-_character.halfHeight;
						
					}else {
						//trace("MV TILE :: STOP");
						_character._oy			= _character._i * G_Game.TILE_SIZE + _character.halfHeight;
						_character.jumpSpeed	= 0;
						_character.jump			= 1;
						_character.isOnMovingTile = false;
						//_character.onMovingTile = null;
						fall(_character);
					}
				}
				
				if (_character.onMovingTile.stepping.dirY*_character.onMovingTile.dir == 1) {
					if (_character.cornerDownLeft && _character.cornerDownRight && !checkIfOnCloud(_character)) {
						_character._oy = _character.onMovingTile.oy - _character.onMovingTile.halfHeight - _character.halfHeight;
					}else{
						_character.isOnMovingTile=false;
						//_character.onMovingTile = null;
						_character._oy = (_character._i + 1) * G_Game.TILE_SIZE - _character.halfHeight;	
					}
				}
				
				//getCorners(_character, _character._ox + (_character.onMovingTile.stepping.speedX+_character.onMovingTile.speedFixX) * _character.onMovingTile.stepping.dirX * _character.onMovingTile.dir, _character._oy);
				getCharacterCorners(_character, _character._ox + _character.onMovingTile.stepping.characterSpeedX, _character._oy);
	
				if (_character.onMovingTile.stepping.dirX*_character.onMovingTile.dir == -1) {
					
					if (_character.cornerDownLeft && _character.cornerUpLeft) {
						//trace("update character position");
						if (_character.onMovingTile.glue == true) _character._ox += _character.onMovingTile.stepping.characterSpeedX;
						else fall(_character);
						//trace("C speed = "+o.stepping.characterSpeedX+" dirX*dir=-1");
						//_character._ox += (_character.onMovingTile._ox-_character._ox)*_character.onMovingTile.stepping.dirX*_character.onMovingTile.dir;
						//trace("diff : "+(_character.onMovingTile.old_ox-_character.onMovingTile._ox));
						
					}else{
						_character._ox = _character._j*G_Game.TILE_SIZE+_character.halfWidth;
						fall(_character);
					}
				}
				
				if (_character.onMovingTile.stepping.dirX*_character.onMovingTile.dir == 1) {
					if (_character.cornerUpRight && _character.cornerDownRight) {
						//trace("update character position");
						if (_character.onMovingTile.glue == true) _character._ox += _character.onMovingTile.stepping.characterSpeedX;
						else fall(_character);
						//trace("C speed = "+o.stepping.characterSpeedX+" dirX*dir=1");
					}else{
						_character._ox = (_character._j + 1) * G_Game.TILE_SIZE - _character.halfWidth;
						fall(_character);
					}
				}
				
				scroll(_character);
				updateChar(_character, _character.dirX, _character.dirY, 0);
			}
		}
	
		// AJOUTER LE PARAM DE LA FRAME A UPDATE CHAR !!
		private function updateChar(objet:Character, dirX:Number, dirY:Number, saut:Number):void {
			objet.mc.x = objet._ox;
			objet.mc.y = objet._oy;
			objet._j = Math.floor(objet._ox/ G_Game.TILE_SIZE);
			objet._i = Math.floor(objet._oy/ G_Game.TILE_SIZE);
			
			if (objet.jump == 1) {
				if (objet.lastDirX == 1) objet.mc.gotoAndStop(G_Character.JUMP_RIGHT_FRAME);
				else if (objet.lastDirX == -1) objet.mc.gotoAndStop(G_Character.JUMP_LEFT_FRAME);
			}else if (Math.abs(objet.dirX) == 1) {
				if (effectiveDirX == objet.dirX) {
					if (objet.dirX == 1) objet.mc.gotoAndStop(G_Character.WALK_RIGHT_FRAME);
					else if (objet.dirX == -1) objet.mc.gotoAndStop(G_Character.WALK_LEFT_FRAME);
				}else if (effectiveDirX != 0) {
					if (objet.dirX == 1) objet.mc.gotoAndStop(G_Character.DRIFT_RIGHT_FRAME);
					else if (objet.dirX == -1) objet.mc.gotoAndStop(G_Character.DRIFT_LEFT_FRAME);
				}
			}else if (objet._climb==1) {
				if (objet.lastDirX==-1) objet.mc.gotoAndStop(G_Character.CLIMB_LEFT_FRAME);
				else objet.mc.gotoAndStop(G_Character.CLIMB_RIGHT_FRAME);
				objet.mc.clip.play();
			}else{
				if (objet.lastDirX ==  1 ) objet.mc.gotoAndStop(G_Character.STOP_RIGHT_FRAME);
				if (objet.lastDirX == -1 ) objet.mc.gotoAndStop(G_Character.STOP_LEFT_FRAME);
			}
		}
		
		private function updatePlayers():void {
			if (_socketClient.updateObj.length > 0) {
				for (var i:int = 0 ; i<_socketClient.updateObj.length; i++) {
					var playerID : int = User(_socketClient.updateObj[i].sender).getPlayerId();
					var playerMc : MovieClip = Screen.getPlayerMc(playerID);
					playerMc.x = _socketClient.updateObj[i].obj.x;					playerMc.y = _socketClient.updateObj[i].obj.y;
				}
			}
		}
		
		public function get stopped():Boolean {
			return isPaused;
		}
	// FIN !
	}
	
}