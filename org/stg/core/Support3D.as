package org.stg.core {
	import gs.TweenLite;
	import gs.easing.Expo;
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import de.polygonal.ds.DListNode;
	
	import org.papervision3d.core.effects.view.ReflectionView;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.BitmapColorMaterial;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.stg.game.GameEngine;
	import org.stg.game.Screen;
	import org.stg.globals.G_Screen;
	import org.stg.level.Level;
	import org.stg.managers.LevelManager;
	import org.stg.net.GameUser;
	import org.stg.ui.menu3d.LevelPlane;
	import org.stg.ui.menu3d.asset.LevelPlaneAsset;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	import org.papervision3d.core.proto.CameraObject3D;	

	/**
	 * @author japanese cake
	 */
	public class Support3D extends ReflectionView {

		public static const LEVEL_SELECTED	: String ="level_selected";

		private static const COVERFLOW	: String = "coverFlow";		private static const GAMECUBE	: String = "gameCube";
				private static const SPACING	: Number = 400;
		private static const TIME		: Number = .5;
		private static const Z_FOCUS	: Number = -500;
		private static const ROTATION_Y	: Number = 45;
				private static var NUMBER_OF_PLANES	: int;
		private static var _instance		: Support3D;		private static var _mode			: String;
		private var _gameCube		: Cube;
		private var _container		: MovieClip;
		private var _planeList		: DLinkedList;

		public static function getInstance():Support3D {
			return _instance;	
		}
		
		public function Support3D(container : MovieClip) {
			x = y = 0;
			_instance = this;
			_container = container;
			viewportReflection.filters = [new BlurFilter(3,3,3)];
			_container.addChild(this);
			startRendering();
		}
		
		public function createCoverFlow(planeNumber:int):void {
			
			destroyActiveMode();
			
			_mode = COVERFLOW;
			NUMBER_OF_PLANES = planeNumber;
			
			viewport.interactive = true;
			
			camera.zoom = 30;
			camera.focus = 20;
			
			_planeList = new DLinkedList();	
			
			for(var i:int = 1; i <= NUMBER_OF_PLANES; i++)
			{
				var level : Level = LevelManager.getLevelById(i);
				var levelPlaneAsset : LevelPlaneAsset = new LevelPlaneAsset(level.id,level.name);				levelPlaneAsset.addEventListener(LEVEL_SELECTED, levelSelectedHandler,false,0,true);
				
				var levelPlaneMaterial:MovieMaterial = new MovieMaterial(levelPlaneAsset);
				levelPlaneMaterial.name = "levelAsset";
				levelPlaneMaterial.interactive = true;
				levelPlaneMaterial.animated = true;
				
				var plane:LevelPlane = new LevelPlane(levelPlaneMaterial, 400, 400, 4, 4);
				plane.id = level.id;
				plane.asset = levelPlaneAsset;
				plane.x = i * SPACING;				
				plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, plane_objectClickHandler);				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOver);				plane.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOut);
				
				_planeList.append(plane);
				scene.addChild(plane);
			}
				
			var firstPlane : LevelPlane = _planeList.head.data;
			firstPlane.asset.active = true;
			flow(firstPlane);
		}
		
		public function createGameSupport():void {
			
			destroyActiveMode();
			
			_mode = GAMECUBE;
			viewport.interactive = true;
			
			var planeMaterialLoadingSide:MovieAssetMaterial = new MovieAssetMaterial("org.stg.ui.LoadingScreen",true,true);
			planeMaterialLoadingSide.interactive = true;
			planeMaterialLoadingSide.doubleSided = false;
			
			var planeMaterialGameSide:MovieMaterial = new MovieMaterial(Screen.getInstance(),false,true,false, new Rectangle(0,0,G_Screen.SCREEN_WIDTH,G_Screen.SCREEN_HEIGHT));
			planeMaterialGameSide.interactive = true;
			planeMaterialGameSide.doubleSided = false;
			
			var cubeMatList:MaterialsList = new MaterialsList({all:new BitmapColorMaterial(0x000000)});
			cubeMatList.addMaterial(planeMaterialLoadingSide, "back");
			cubeMatList.addMaterial(planeMaterialGameSide, "front");
			
			_gameCube = new Cube(cubeMatList,G_Screen.SCREEN_WIDTH,5,G_Screen.SCREEN_HEIGHT,6,6,6);
			_gameCube.name = "gameContainer";
			
			// OK !
			trace("Support3D :: ","zoom="+camera.zoom,"focus="+ camera.focus);
			camera.zoom = 30;
			camera.focus = 48;
			
			scene.addChild(_gameCube);
			camera.target = _gameCube;
		}
		
		public function flowTo(planeId:int, forceColor:Boolean=false, disableEventDispatching:Boolean=false):void {
			var it : DListIterator = _planeList.getListIterator();
			
			while (it.hasNext()) {
				if (LevelPlane(it.node.data).id == planeId) {
					if (forceColor) LevelPlane(it.node.data).asset.chooseMe(null, !disableEventDispatching);
					flow(LevelPlane(it.node.data));
					//break;
				}else LevelPlane(it.node.data).asset.gotoAndStop(1);
						
				it.next();
			}
		}
		
		public function tweenIn(dir:Number, callBack:Function=null):void {
			var rY : Number = 0;
			
			if (Math.abs(dir) == 1) rY = _gameCube.rotationY+180*dir;
			
			TweenLite.to(_gameCube, 0.9, {rotationY:rY, ease:Expo.easeOut, onComplete: tweenOver, onCompleteParams:[callBack]});
		}
		
		public function destroyActiveMode():void {
			if (_mode == COVERFLOW) {
				_mode = "";
				destroyCoverFlow();
			}else if (_mode == GAMECUBE) {
				_mode = "";
				destroyGameCube();
			}
		}
		
		public function destroy():void {
			stopRendering();
			destroyActiveMode();
			_instance = null;
			delete(this);
		}
			
		/* Private methods */
		
		override protected function onRenderTick(event:Event = null):void {
			super.onRenderTick();
			try {
				GameEngine.getInstance().onEnterFrame();
			} catch (e:Error) {
			}
		}

		private function flow(plane:LevelPlane):void {
			plane.asset.active = true;
			
			var xPosition:Number = 0;
			TweenLite.to(plane, TIME, {x:xPosition, z:Z_FOCUS, rotationY:0});
			
			var current:DListNode = _planeList.nodeOf(plane).node;
									
			var walkLeft:DListNode = current.prev;
			while(walkLeft)
			{
				plane = LevelPlane(walkLeft.data);
				plane.asset.active = false;
				xPosition -= SPACING;
				TweenLite.to(plane, TIME, {x:xPosition, z:0, rotationY:-ROTATION_Y});
				walkLeft = walkLeft.prev;
			}
			
			xPosition = 0;
			var walkRight:DListNode = current.next;
			while(walkRight)
			{
				plane = LevelPlane(walkRight.data);
				plane.asset.active = false;
				xPosition += SPACING;
				TweenLite.to(plane, TIME, {x:xPosition, z:0, rotationY:ROTATION_Y});
				walkRight = walkRight.next;
			}
		}
		
		private function tweenOver(callBack:Function = null):void {
			if (callBack != null) callBack();
		}
		
		
		private function destroyCoverFlow():void {		
			var it : DListIterator = _planeList.getListIterator();
			
			while (it.hasNext()) {
				scene.removeChild(LevelPlane(it.node.data));				
				it.next();
			}
		}
		
		private function destroyGameCube():void {
			scene.removeChild(_gameCube);
		}
		
		/* Private Event Handlers */
		
		private function plane_objectClickHandler(event:InteractiveScene3DEvent):void {
			var plane:LevelPlane = LevelPlane(event.target);
			flow(plane);			
		}
		
		private function levelSelectedHandler(event:Event):void {
			var it : DListIterator = _planeList.getListIterator();
			
			while (it.hasNext()) {
				LevelPlane(it.node.data).removeEventListener(InteractiveScene3DEvent.OBJECT_CLICK, plane_objectClickHandler);							LevelPlane(it.node.data).removeEventListener(InteractiveScene3DEvent.OBJECT_OVER, onOver);							LevelPlane(it.node.data).removeEventListener(InteractiveScene3DEvent.OBJECT_OUT, onOut);			
				it.next();
			}
			
			var planeAsset:LevelPlaneAsset = LevelPlaneAsset(event.target);
			GameUser.LEVELID = planeAsset.id;
			dispatchEvent(new Event(LEVEL_SELECTED));
		}
		
		private function onOver(event:InteractiveScene3DEvent):void {
			var plane:LevelPlane = LevelPlane(event.target);
			plane.asset.gotoAndStop(2);
		}
		
		private function onOut(event:InteractiveScene3DEvent):void {
			var plane:LevelPlane = LevelPlane(event.target);
			plane.asset.gotoAndStop(1);
		}
	}
}
