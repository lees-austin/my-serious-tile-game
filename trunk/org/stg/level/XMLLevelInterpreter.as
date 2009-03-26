package org.stg.level {
	import org.stg.game.elts.tile.DoorTile;
	import org.stg.game.elts.tile.MovingTile;
	import org.stg.game.elts.tile.SlopeObject;
	import org.stg.game.elts.tile.Tile;
	import org.stg.globals.G_Level;
	import org.stg.managers.LibraryManager;	

	/**
	 * @author japanese cake
	 */
	public class XMLLevelInterpreter {
					
		public static function parseAndCreateLevel(level:Level, levelData:XML, callBack:Function):void {
			
			// INITIALIZE LEVEL ATTRIBUTES WITH XML'S LEVEL ATTRIBUTES
			level.initialize(levelData);
			
			var levelChilds:XMLList = levelData.levelChild;
			
			for (var i:Number=0;i<levelChilds.length();i++) {
				
				var currentLevelChild : XMLList = levelChilds.(@id == i);
				trace("XMLLevelInterpreter :: parseAndBuild->levelChildNo " + levelChilds.(@id == i).@id);
				
				LibraryManager.setClassDefinition(i, currentLevelChild.class_definition);
				
				// INITIALIZE LEVELCHILD ATTRIBUTES
				var newLevelChild:LevelChild = new LevelChild(currentLevelChild);

				// PARSE GAME OBJECTS
				newLevelChild.tiles = parseTilesRawData(currentLevelChild.tiles, newLevelChild.tileHeight, newLevelChild.tileWidth);				newLevelChild.movingTiles = parseMovingTilesData(currentLevelChild.movingTiles);
				newLevelChild.doorsTiles = parseDoorsTilesData(currentLevelChild.doorsTiles.doorTile, newLevelChild.tiles);				newLevelChild.characters = parseCharactersData(currentLevelChild.players.player);
				
				// ADD LEVELCHILD TO LEVEL
				level.addChild(newLevelChild);
			}
			
			callBack(level);
		}
		
		private static function parseTilesRawData(tilesData:String, levelChildHeight:Number, levelChildWidth:Number):Array {
			var colId:Number = 0;
			var rowId:Number = 0;
			var currentTile:String="";
			var tiles:Array = new Array(levelChildHeight);
			tiles[rowId] = new Array(levelChildWidth);
			//trace("parseTilesRawData : "+tilesData.length);
			for (var charIndex:Number=0;charIndex<=tilesData.length;charIndex++) {
				
				var char:String = tilesData.charAt(charIndex);
				var charCode:Number = Number(tilesData.charCodeAt(charIndex));
				
				if (charCode!=13 && charCode!=10 && charCode!=9) {
					
					if (currentTile.length < G_Level.TILE_HEX_LENGTH) currentTile += char;
					else if (currentTile.length == G_Level.TILE_HEX_LENGTH) {
						//trace("tile found (i="+rowId+" , j="+colId+") -> 0x"+currentTile);
						tiles[rowId][colId] = createTileObject(currentTile);
						//tiles[rowId][colId].toString();
						currentTile = char;
						colId++;
					}
					
					if ( colId>levelChildWidth-1) {
						colId=0;
						rowId++;
						if (rowId<levelChildHeight) tiles[rowId] = new Array(levelChildWidth);
					}
					//trc("char->"+char+" code:"+charCode);
				}
				
			}
	
			return tiles;
		}
		
		private static function parseMovingTilesData(movingTilesData:XMLList):Array {
			var movingTiles:Array = new Array(movingTilesData.movingTile.length());
			for (var i:Number=0;i<movingTilesData.movingTile.length();i++) {
				var newMovingTile:MovingTile = new MovingTile(movingTilesData.movingTile.(@id == i));
				movingTiles["movingTile"+i] = newMovingTile;
			}
	
			return movingTiles;
		}
		
		// Ajoute et écrase les tiles existantes par les monvingTiles
		private static function parseDoorsTilesData(doorsTilesData:XMLList, tiles:Array):Array {
			var doorsTiles:Array = new Array(doorsTilesData.length());
			for (var n:Number=0;n<doorsTilesData.length();n++) {
				var temp:Tile = tiles[doorsTilesData[n].i][doorsTilesData[n].j];
				tiles[doorsTilesData[n].i][doorsTilesData[n].j] = new DoorTile(temp);
				tiles[doorsTilesData[n].i][doorsTilesData[n].j].addDoorProperties(doorsTilesData[n]);
				doorsTiles[n] = tiles[doorsTilesData[n].i][doorsTilesData[n].j];
			}
			return doorsTiles;
		}

		private static function createTileObject(tileValue:String):Tile {
			var o:Tile;
			var nTileProperties:Number=Number("0x"+tileValue.substr(G_Level.PROPERTIES_OFFSET, G_Level.PROPERTIES_HEX_LENGTH));
	
			// Walkable = 0x01
			// Cloud = 0x03
			// ??? = 0x05
			// Ladder = 0x07
			// Door = 0x09
			
			// SlopeLeft = 0x0C
			// SlopeRight = 0x0E					
			switch (nTileProperties) {
				case 0x01:
					o = new Tile(true);
					//o.walkable	= true;
				break;
				case 0x04:
					o = new Tile(true,true);
//					o.walkable	= true;
//					o.cloud		= true;				break;
				case 0x06:
					//o.walkable	= true;
					//o.slope		= true;				break;
				case 0x07:
					o = new Tile(false,false,false,true);
					//o.ladder	= true;
				break;
				case 0x08:
					o = new Tile(true,false,false,true);
//					o.walkable	= true;
//					o.ladder	= true;				break;
				case 0x09:
					//o.walkable	= true;
					//o.slope		= true;
					//o.cloud		= true;				break;
				case 0x10:
					o = new Tile(true,false,true);
//					o.walkable	= true;
//					o.door		= true;
				break;
				case 0x0C:
					o = new Tile(true,false,false,false, new SlopeObject(true));
//					o.walkable	= true;
//					o.slope.left= true;
				break;
				case 0x0E:
					o = new Tile(true,false,false,false, new SlopeObject(false,true));
//					o.walkable	= true;
//					o.slope 	= new SlopeObject(false,true);
				break;
				case 0x0F:
					o = new Tile(true,true,false,false, new SlopeObject(true));
//					o.walkable	= true;
//					o.cloud		= true;
//					o.slope 	= new SlopeObject(true);
				break;
				case 0x11:
					o = new Tile(true,true,false,false, new SlopeObject(false,true));
//					o.walkable	= true;
//					o.cloud		= true;
//					o.slope 	= new SlopeObject(false,true);
				break;
				default:
					o = new Tile();
				break;
			}
	
			o.frameNumber	= Number("0x"+tileValue.substr(G_Level.FRAME_OFFSET, G_Level.FRAME_HEX_LENGTH));
			
			return o;	
		}
	
		private static function parseCharactersData(charactersData:XMLList):Array {
			//trc("parseCharactersData");
			var charactersPosition : Array = new Array(charactersData.length()+1);	
			charactersPosition[0] = null;
			for (var i:Number=0;i<charactersData.length();i++) {
				charactersPosition[i+1] = {id:charactersData[i].@id,i:charactersData[i].@i,j:charactersData[i].@j};
				//for (var o in charactersPosition[i+1]) trc(o+"->"+charactersPosition[i+1][o]);
			}
			return charactersPosition;
		}
		
		private static function createLevelChild():LevelChild {
			var levelChild:LevelChild;
			return levelChild;
		}
		
	}
	
}