package org.stg.game {	
	/**
	 * @author japanese cake
	 */
	import fl.transitions.Fade;
	import fl.transitions.TransitionManager;
	import fl.transitions.easing.Regular;
	
	import org.stg.core.Main;
	import org.stg.events.ScreenEvent;
	import org.stg.globals.G_Screen;
	import org.stg.managers.LibraryManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;	

	final public class Screen extends MovieClip {
	
		private static var _instance: Screen;
		public var tm			: TransitionManager;
		public var displayElts	: Array;
		public var bg			: Sprite;
		
		private var tmCallBack	: Function = null;
		
		// CONTRUCTOR
		public function Screen() {
			super();
			_instance = this;
			bg.x = bg.y = x = y = 0;
			displayElts = new Array();
		}
		
		public function destroy():void {
			clean();
			tmCallBack = null;
			_instance = null;
			tm = null;
			displayElts = null;
			bg = null;
			delete(this);
		}
				
		public static function getInstance():Screen {
			return _instance == null ? new Screen() : _instance;	
		}
		
		public static function setInstance(screen : DisplayObject) : void {
			_instance = Screen(screen);
		}
		
		public function initialize(playerID:uint):void {
			trace("Screen: Création des MovieClips du GameScreen");
			
			// CREATION DU FOND NOIR (MASQUE)			var screenBackground:MovieClip = new MovieClip();
			screenBackground.graphics.beginFill(0x000000);
			screenBackground.graphics.drawRect(0, 0, G_Screen.SCREEN_WIDTH, G_Screen.SCREEN_HEIGHT);
			addChild(screenBackground);
						this.mask = screenBackground;
						displayElts[G_Screen.CONTAINER] = this.addChild(new MovieClip());
			displayElts[G_Screen.BACKGROUND] = displayElts[G_Screen.CONTAINER].addChild(new LibraryManager.BackgroundClassRef());
			displayElts[G_Screen.MEDIUMGROUND] = displayElts[G_Screen.CONTAINER].addChild(new LibraryManager.MediumgroundClassRef());			displayElts[G_Screen.ELEMENTS] = displayElts[G_Screen.CONTAINER].addChild(new Sprite());
			displayElts[G_Screen.LAYERS] = displayElts[G_Screen.CONTAINER].addChild(new Sprite());			//displayElts[G_Screen.FOREGROUND] = movieClips[G_Screen.ELEMENTS].addChild(new LibraryManager.FG_CLASS_REF());			displayElts[G_Screen.TILES] = displayElts[G_Screen.LAYERS].addChild(new Sprite());
			displayElts[G_Screen.MOVING_TILES] = displayElts[G_Screen.LAYERS].addChild(new Sprite());
			displayElts[G_Screen.CHARACTERS] = displayElts[G_Screen.LAYERS].addChild(new Sprite());			displayElts[G_Screen.PLAYER+playerID] = displayElts[G_Screen.CHARACTERS].addChild(new LibraryManager.CharacterClassRef());
			initTM(displayElts[G_Screen.CONTAINER]);

			setVisibility = false;

			dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_INITIALIZED));
		}
		
		public function addPlayer(playerid:uint) : DisplayObject {
			displayElts[G_Screen.PLAYER + playerid] = displayElts[G_Screen.CHARACTERS].addChild(new LibraryManager.CharacterClassRef());
			return displayElts[G_Screen.PLAYER + playerid];
		}
		
		private function initTM(mc:MovieClip):void {
			tm = new TransitionManager(mc);
			tm.addEventListener("allTransitionsInDone", onTransitionCompleted);	
			tm.addEventListener("allTransitionsOutDone", onTransitionCompleted);
		}
		
		public function playTransition(type:uint = 0,callBack:Function = null):void {
			tmCallBack = callBack;
			try{
				tm.startTransition({type:Fade, direction:type, duration:1.2, easing:Regular.easeOut});
			}catch (e:Error) {}	
		}
		
		private function onTransitionCompleted(evt:Event):void {
			trace("Screen :: onTransitionCompleted->"+evt.type);
			try{
				removeEventListener(ScreenEvent.SCREEN_CLEAN, GameBuilder.make);
				if (evt.type == "allTransitionsOutDone") {
					displayElts[G_Screen.LAYERS].visible = false;					displayElts[G_Screen.ELEMENTS].visible = false;
				}else if (evt.type == "allTransitionsInDone") {
					displayElts[G_Screen.LAYERS].visible = true;
					displayElts[G_Screen.ELEMENTS].visible = true;
				}
				
				if (tmCallBack != null) tmCallBack();
			}catch (e:Error) {}
		}
		
		public function clean():void {
			for (var i:Number=0;i<numChildren;i++) {
				removeChildAt(i);
			}
			dispatchEvent(new ScreenEvent(ScreenEvent.SCREEN_CLEAN));
		}
	
		public function set setVisibility(b:Boolean):void {
			displayElts[G_Screen.CONTAINER].visible = b;			displayElts[G_Screen.BACKGROUND].visible = b;			displayElts[G_Screen.MEDIUMGROUND].visible = b;
		}
	
		public static function getPlayerMc(playerID:uint):MovieClip { return getInstance().displayElts[G_Screen.PLAYER + playerID]; }
	
		// GETTER
		public static function get Game():Sprite { return getInstance().displayElts[G_Screen.GAME]; }		public static function get Container():MovieClip { return getInstance().displayElts[G_Screen.CONTAINER]; }
		public static function get Layers():Sprite { return getInstance().displayElts[G_Screen.LAYERS]; }		public static function get Characters():Sprite { return getInstance().displayElts[G_Screen.CHARACTERS]; }		public static function get Player():MovieClip { return getInstance().displayElts[G_Screen.PLAYER]; }		public static function get Debug():MovieClip { return getInstance().displayElts[G_Screen.DEBUG]; }		public static function get Debug_Panel():MovieClip { return getInstance().displayElts[G_Screen.DEBUG_PANEL]; }		public static function get Grid():MovieClip { return getInstance().displayElts[G_Screen.GRID]; }		public static function get Elements():Sprite { return getInstance().displayElts[G_Screen.ELEMENTS]; }		public static function get Tiles():Sprite { return getInstance().displayElts[G_Screen.TILES]; }		public static function get MovingTiles():Sprite { return getInstance().displayElts[G_Screen.MOVING_TILES]; }		public static function get Frame():MovieClip { return getInstance().displayElts[G_Screen.FRAME]; }		public static function get Background():MovieClip { return getInstance().displayElts[G_Screen.BACKGROUND]; }		public static function get Mediumground():MovieClip { return getInstance().displayElts[G_Screen.MEDIUMGROUND]; }
		
		// SETTER
		public static function set Game(mc:Sprite):void { getInstance().displayElts[G_Screen.GAME]=mc; }
		public static function set Characters(mc:Sprite):void { getInstance().displayElts[G_Screen.CHARACTERS]=mc; }
		public static function set Player(mc:MovieClip):void { getInstance().displayElts[G_Screen.PLAYER]=mc; }
		public static function set Debug(mc:MovieClip):void { getInstance().displayElts[G_Screen.DEBUG]=mc; }		public static function set Debug_Panel(mc:MovieClip):void { getInstance().displayElts[G_Screen.DEBUG_PANEL]=mc; }		public static function set Grid(mc:MovieClip):void { getInstance().displayElts[G_Screen.GRID]=mc; }
		public static function set Elements(mc:Sprite):void { getInstance().displayElts[G_Screen.ELEMENTS]=mc; }
		public static function set Tiles(mc : Sprite) : void { getInstance().displayElts[G_Screen.TILES]=mc; }		public static function set MovingTiles(mc:Sprite):void { getInstance().displayElts[G_Screen.MOVING_TILES]=mc; }
		public static function set Frame(mc:MovieClip):void { getInstance().displayElts[G_Screen.FRAME]=mc; }		public static function set Background(mc:MovieClip):void { getInstance().displayElts[G_Screen.BACKGROUND]=mc; }
		public static function set Mediumground(mc:MovieClip):void { getInstance().displayElts[G_Screen.MEDIUMGROUND]=mc; }
	}
	
}
