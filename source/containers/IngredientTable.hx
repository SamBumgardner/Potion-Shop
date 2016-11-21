package containers;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttons.IngredientHex;
import buttons.SelectedHex;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import graphicObjects.DisplaySprite;
import haxe.Json;
import sys.io.File;
import utilities.ButtonEvent;
import utilities.ButtonEvent.EventData;
import utilities.ColorArray;
import utilities.ColorConverter;
import utilities.EventExtender;
import utilities.IngredientData;
import utilities.Observer;

using utilities.EventExtender;

/**
 * The table that responds to events happenning to different IngredientHexes.
 * @author Samuel Bumgardner
 */
class IngredientTable extends Hideable implements Observer
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private var totalGrp:FlxGroup;
	
	private var newEvents:Array<ButtonEvent>;
	private var eventCallbacks:Array<Array<Int->Void>>;
	
	private static var emptyIng:IngredientData;
	private var ingInfo:Array<IngredientData>;
	private var selectedIDs:Array<Int>;
	private var selectedHexArray:Array<SelectedHex>;
	private var numSelected:Int = 0;
	private var maxSelected:Int = 4;
	
	private var displayName:FlxText;
	private var displayNameCenterX:Int = 1005;
	private var displayImage:DisplaySprite;
	private var displayDescription:FlxText;
	private var displayColorHover:ColorArray;
	private var displayColorSelected:ColorArray;
	private var displayHoverBars:Array<FlxBar>;
	private var displaySelectedBars:Array<FlxBar>;
	private var displaySelectedImages:Array<DisplaySprite>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, AssetPaths.IngredientTable__png);
		
		totalGrp = new FlxGroup();
		totalGrp.add(this);
		
		initEventSystem();
		initIngInfo();
		initIngredientButtons();
		initSelectedButtons();
		initDisplayComponents();
	}
	
	private function initEventSystem():Void
	{
		var numOfEventTypes = 4; // see EventData enum
		var numOfButtonTypes = 4; // see ButtonTypes enum
		
		newEvents = new Array<ButtonEvent>();
		for (i in 0...numOfEventTypes)
		{
			newEvents.push(ButtonTypes.NO_TYPE);
		}
		
		eventCallbacks = new Array<Array<ButtonEvent->Void>>();
		for (i in 0...numOfEventTypes)
		{
			eventCallbacks.push(new Array<Int->Void>());
			for (j in 0...numOfButtonTypes)
			{
				eventCallbacks[i].push(null);
			}
		}
		
		eventCallbacks[EventData.OUT][ButtonTypes.ING_HEX] = ingHexOut;
		eventCallbacks[EventData.OUT][ButtonTypes.SELECT_HEX] = selectHexOut;
		
		eventCallbacks[EventData.OVER][ButtonTypes.ING_HEX] = ingHexOver;
		eventCallbacks[EventData.OVER][ButtonTypes.SELECT_HEX] = selectHexOver;
		
		eventCallbacks[EventData.DOWN][ButtonTypes.ING_HEX] = ingHexDown;
		eventCallbacks[EventData.DOWN][ButtonTypes.SELECT_HEX] = selectHexDown;
		
		eventCallbacks[EventData.UP][ButtonTypes.ING_HEX] = ingHexUp;
		eventCallbacks[EventData.UP][ButtonTypes.SELECT_HEX] = selectHexUp;
	}
	
	private function initIngInfo():Void
	{
		emptyIng = new IngredientData("", [0, 0, 0, 0, 0, 0, 0, 0], 0, "");
		
		ingInfo = new Array<IngredientData>();
		
		var fileHandle = File.read(AssetPaths.IngredientData__txt);
		
		for (i in 0...28)
		{
			var anonIng = Json.parse(fileHandle.readLine());
			var ingredient = new IngredientData(anonIng.name, anonIng.colorValues, 
			                                    anonIng.price, anonIng.description);
			ingInfo.push(ingredient);
		}
		
		fileHandle.close();
	}
	
	private function initIngredientButtons():Void
	{
		var ingHexArray = new Array<IngredientHex>();
		var displayIngImages = new Array<DisplaySprite>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var ingredientHexWidth = 145;
		var ingredientHexHeight = 125;
		
		var numRows = 8;
		var evenCols = 3;
		var oddCols = 4;
		
		var XIntervalMod = 1.56;
		var YIntervalMod = .545;
		
		var topLeftX = x + 12;
		var topLeftY = y + 12;
		
		var evenXOffset = ingredientHexWidth * .78;
		
		var XInterval = ingredientHexWidth * XIntervalMod;
		var YInterval = ingredientHexHeight * YIntervalMod;
		
		var locX = 0;
		var locY = 0;
		
		for (row in 0...numRows)
		{
			for (col in 0...oddCols)
			{
				if (row % 2 == 0)
				{
					if (col >= evenCols)
					{
						break;
					}
					// Need to cast Float to Int
					locX = cast (topLeftX + evenXOffset + col * XInterval);
					locY = cast (topLeftY + row * YInterval);
				}
				else
				{
					locX = cast (topLeftX + col * XInterval);
					locY = cast (topLeftY + row * YInterval);
				}
				ingHexArray.push(new IngredientHex(locX, locY));
				displayIngImages.push(new DisplaySprite(locX, locY, 
				                      AssetPaths.IngredientSpriteSheet__png,
				                      145, 125, 1, 3));
			}
		}
		
		//This is a bit (prob. insignificantly) inefficient, but it's more readable.
		for (i in 0...ingHexArray.length)
		{
			ingHexArray[i].sub.setID(i);
			ingHexArray[i].sub.addObserver(this);
			totalGrp.add(ingHexArray[i]);
			displayIngImages[i].animation.play(Std.string(i % 2 + 1));
			totalGrp.add(displayIngImages[i]);
		}
	}
	
	private function initSelectedButtons():Void
	{
		selectedIDs = new Array<Int>();
		selectedHexArray = new Array<SelectedHex>();
		displaySelectedImages = new Array<DisplaySprite>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var selectedHexWidth = 135;
		var ingredientHexHeight = 155;
		
		var numRows = 2;
		var numCols = 2;
		
		var XIntervalMod = 1.1;
		var YIntervalMod = .8;
		
		var topLeftX = x + 845;
		var topLeftY = y + 12;
		
		var rowXOffset = -selectedHexWidth * .55;
		
		var XInterval = selectedHexWidth * XIntervalMod;
		var YInterval = ingredientHexHeight * YIntervalMod;
		
		for (row in 0...numRows)
		{
			for (col in 0...numCols)
			{
				var selHex = new SelectedHex(topLeftX + col * XInterval - row * rowXOffset, 
											 topLeftY + row * YInterval);
				selHex.sub.setID(row * numCols + col);
				selHex.sub.addObserver(this);
				
				selectedHexArray.push(selHex);
				totalGrp.add(selHex);
				
				displaySelectedImages.push(new DisplaySprite(selHex.x, selHex.y, 
				                           AssetPaths.IngredientSpriteSheet__png,
				                           145, 125, 1, 3));
				
				totalGrp.add(displaySelectedImages[row * numCols + col]); //FIX this
			}
		}
	}
	
	private function initDisplayBars():Void
	{
		var barInitialX = 1226;
		var barInitialY = 55;
		var barOffsetX = 33;
		
		var barWidth = 20;
		var barHeight = 156;
		
		var barUnits = 12;
		
		displayColorHover = new ColorArray();
		displayColorSelected = new ColorArray();
		
		displayHoverBars = new Array<FlxBar>();
		displaySelectedBars = new Array<FlxBar>();
		
		var colorConvert = new ColorConverter();
		
		for (i in 0...displayColorHover.array.length)
		{
			displaySelectedBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                  y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                  barHeight, displayColorSelected, 
											  colorConvert.intToColorStr[i], 0, barUnits));
			displayHoverBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                 y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                 barHeight, displayColorHover, 
											 colorConvert.intToColorStr[i], 0, barUnits));
			
			displaySelectedBars[i].createFilledBar(0, colorConvert.intToColorHex[i]);
			displayHoverBars[i].createFilledBar(0, colorConvert.intToColorHex[i] - 0xAA000000);
			
			//Note: The order of adding matters!
			// Locked are added first so Hover draws in front.
			totalGrp.add(displaySelectedBars[i]);
			totalGrp.add(displayHoverBars[i]);
		}
	}
	
	private function initDisplayComponents():Void
	{
		displayName = new FlxText(x + displayNameCenterX, y + 545, 0, "", 20);
		displayName.set_color(FlxColor.BLACK);
		totalGrp.add(displayName);
		
		displayDescription = new FlxText(x + 1150, y + 335, 300, "", 24);
		displayDescription.set_color(FlxColor.BLACK);
		totalGrp.add(displayDescription);
		
		initDisplayBars();
		
		displayImage = new DisplaySprite(x + 900, y + 340, 
		               AssetPaths.IngredientSpriteSheet__png,
		               145, 125, 1, 3);
		
		totalGrp.add(displayImage);
	}
	
	
	///////////////////////////////////////////
	//           PUBLIC INTERFACE            //
	///////////////////////////////////////////
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	
	///////////////////////////////////////////
	//  POTION DATA  MANIPULATION FUNCTIONS  //
	///////////////////////////////////////////
	
	private function clearHoverInfo():Void
	{
		updateIngDisplayText(IngredientTable.emptyIng);
		displayImage.animation.play("0");
		updateHoverBars(IngredientTable.emptyIng);
	}
	
	private function updateIngDisplayText(ingredient:IngredientData):Void
	{
		displayName.text = ingredient.name;
		displayName.x = x + displayNameCenterX - displayName.width / 2;
		displayDescription.text = ingredient.description;
	}
	
	private function updateHoverBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayColorHover.array.length)
		{
			displayColorHover.array[i] = ingredient.colorValues[i] + displayColorSelected.array[i];
		}
	}
	
	private function increaseSelectedColors(ingredient:IngredientData):Void
	{
		for (i in 0...displayColorSelected.array.length)
		{
			displayColorSelected.array[i] += ingredient.colorValues[i];
		}
	}
	
	private function decreaseSelectedColors(ingredient:IngredientData):Void
	{
		for (i in 0...displayColorSelected.array.length)
		{
			displayColorSelected.array[i] -= ingredient.colorValues[i];
		}
	}
	
	private function updateSelectedImages():Void
	{
		for (i in 0...selectedIDs.length)
		{	
			if (selectedIDs[i] != -1)
			{
				displaySelectedImages[i].animation.play(Std.string(selectedIDs[i] % 2 + 1)); //placeholder animation index
			}
			else
			{
				displaySelectedImages[i].animation.play("0");
			}
		}
	}
	
	///////////////////////////////////////////
	//         INGREDIENT HEX HOVER          //
	///////////////////////////////////////////
	
	private function setIngHoverInfo(ingIndex:Int):Void
	{
		var ingredient = ingInfo[ingIndex];
		
		updateIngDisplayText(ingredient);
		displayImage.animation.play(Std.string(ingIndex % 2 + 1));
		if (numSelected < maxSelected)
		{
			updateHoverBars(ingredient);
		}
	}
	
	///////////////////////////////////////////
	//         INGREDIENT HEX CLICK          //
	///////////////////////////////////////////
	
	private function selectIngredient(ingIndex:Int):Void
	{
		if (numSelected < maxSelected)
		{
			selectedIDs[numSelected] = ingIndex;
			ActiveButton.activate(selectedHexArray[numSelected]);
			numSelected++;
			
			var ingredient = ingInfo[ingIndex];
			
			increaseSelectedColors(ingredient);
			if (numSelected < maxSelected)
			{
				updateHoverBars(ingredient);
			}
			updateSelectedImages();
		}
		else
		{
			//Give some indication that there is no room.
		}
	}
	
	///////////////////////////////////////////
	//            SELECT HEX CLICK           //
	///////////////////////////////////////////
	
	private function deselectIngredient(selectIndex:Int):Void
	{
		selectedIDs.splice(selectIndex, 1);
		selectedIDs.push(-1);
		numSelected--;
		ActiveButton.deactivate(selectedHexArray[numSelected]);
		
		clearHoverInfo();
		updateSelectedImages();
	}
	
	///////////////////////////////////////////
	//            SELECT HEX HOVER           //
	///////////////////////////////////////////
	
	private function setSelectHoverInfo(selectIndex:Int):Void
	{
		var ingredient = ingInfo[selectedIDs[selectIndex]];
		
		updateIngDisplayText(ingredient);
		decreaseSelectedColors(ingredient);
		updateHoverBars(ingredient);
		displayImage.animation.play(Std.string(selectedIDs[selectIndex] % 2 + 1));
	}
	
	private function unsetSelectHoverInfo(selectIndex:Int):Void
	{
		var ingredient = ingInfo[selectedIDs[selectIndex]];
		
		increaseSelectedColors(ingredient);
	}
	
	
	///////////////////////////////////////////
	//        INGREDIENT HEX CALLBACKS       //
	///////////////////////////////////////////
	
	private function ingHexOut(id:ButtonEvent):Void
	{
		clearHoverInfo();
	}
	
	private function ingHexOver(id:ButtonEvent):Void
	{
		setIngHoverInfo(id);
	}
	
	private function ingHexDown(id:ButtonEvent):Void
	{
		//Do whatever happens when the mouse is pressed over an ingredient button.
		// Probably nothing, but it's nice to have in the array of notfiy callbacks.
	}

	private function ingHexUp(id:ButtonEvent):Void
	{
		selectIngredient(id);
	}
	
	
	///////////////////////////////////////////
	//          SELECT HEX CALLBACKS         //
	///////////////////////////////////////////
	
	private function selectHexOut(id:Int):Void
	{
		unsetSelectHoverInfo(id);
		clearHoverInfo();
	}
	
	private function selectHexOver(id:Int):Void
	{
		setSelectHoverInfo(id);
	}
	
	private function selectHexDown(id:ButtonEvent):Void
	{
		//Do whatever happens when the mouse is pressed over an ingredient button.
		// Probably nothing, but it's nice to have in the array of notfiy callbacks.
	}

	private function selectHexUp(id:ButtonEvent):Void
	{
		deselectIngredient(id);
		if (numSelected > id)
		{
			selectHexOver(id);
		}
	}
	
	
	///////////////////////////////////////////
	//          ORIGIN OF CALLBACKS          //
	///////////////////////////////////////////
	
	public function onNotify(event:ButtonEvent):Void
	{
		newEvents[event.getData()] = event;
	}
	
	
	///////////////////////////////////////////
	//                UPDATE                 //
	///////////////////////////////////////////
	
	override public function update(elapsed:Float):Void 
	{
		for (eventData in 0...newEvents.length)
		{
			if (newEvents[eventData] != ButtonTypes.NO_TYPE)
			{
				var event = newEvents[eventData];
				eventCallbacks[eventData][event.getType()](event.getID());
				newEvents[eventData] = ButtonTypes.NO_TYPE;
			}
		}
		super.update(elapsed);
	}
}