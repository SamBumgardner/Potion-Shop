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
	private var totalGrp:FlxGroup;
	
	private var notifyCallbacks:Array<Int->Void>;
	
	private static var emptyIng:IngredientData;
	private var ingInfo:Array<IngredientData>;
	private var selectedIDs:Array<Int>;
	private var selectedHexArray:Array<SelectedHex>;
	private var numSelected:Int = 0;
	private var maxSelected:Int = 4;
	
	private var currHoverIngID:Int;
	private var displayName:FlxText;
	private var displayNameCenterX:Int = 1005;
	private var displayImage:DisplaySprite;
	private var displayDescription:FlxText;
	private var displayColorHover:ColorArray;
	private var displayColorLocked:ColorArray;
	private var displayHoverBars:Array<FlxBar>;
	private var displayLockedBars:Array<FlxBar>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, AssetPaths.IngredientTable__png);
		
		totalGrp = new FlxGroup();
		totalGrp.add(this);
		
		initNotifyCallbacks();
		initIngInfo();
		initIngredientButtons();
		initSelectedButtons();
		initDisplayComponents();
	}
	
	private function initNotifyCallbacks():Void
	{
		notifyCallbacks = new Array<Int->Void>();
		
		notifyCallbacks.push(ingHexOut);
		notifyCallbacks.push(ingHexOver);
		notifyCallbacks.push(ingHexDown);
		notifyCallbacks.push(ingHexUp);
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
		
		for (row in 0...numRows)
		{
			if (row % 2 == 0)
			{
				for (col in 0...evenCols)
				{
					ingHexArray.push(new IngredientHex(topLeftX + evenXOffset + col * XInterval,
					                                   topLeftY + row * YInterval));
				}
			}
			else
			{
				for (col in 0...oddCols)
				{
					ingHexArray.push(new IngredientHex(topLeftX + col * XInterval, 
					                                   topLeftY + row * YInterval));
				}
			}
		}
		
		//This is a bit (prob. insignificantly) inefficient, but it's more readable.
		for (i in 0...ingHexArray.length)
		{
			ingHexArray[i].sub.setID(i);
			ingHexArray[i].sub.addObserver(this);
			totalGrp.add(ingHexArray[i]);
		}
	}
	
	private function initSelectedButtons():Void
	{
		selectedIDs = new Array<Int>();
		selectedHexArray = new Array<SelectedHex>();
		displaySelectedImages = new Array<DisplaySprite>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var ingredientHexWidth = 135;
		var ingredientHexHeight = 155;
		
		var numRows = 2;
		var numCols = 2;
		
		var XIntervalMod = 1.1;
		var YIntervalMod = .8;
		
		var topLeftX = x + 900;
		var topLeftY = y + 12;
		
		var rowXOffset = ingredientHexWidth * .55;
		
		var XInterval = ingredientHexWidth * XIntervalMod;
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
		displayColorLocked = new ColorArray();
		
		displayHoverBars = new Array<FlxBar>();
		displayLockedBars = new Array<FlxBar>();
		
		var colorConvert = new ColorConverter();
		
		for (i in 0...displayColorHover.array.length)
		{
			displayLockedBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                  y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                  barHeight, displayColorLocked, 
											  colorConvert.intToColorStr[i], 0, barUnits));
			displayHoverBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                 y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                 barHeight, displayColorHover, 
											 colorConvert.intToColorStr[i], 0, barUnits));
			
			displayLockedBars[i].createFilledBar(0, colorConvert.intToColorHex[i]);
			displayHoverBars[i].createFilledBar(0, colorConvert.intToColorHex[i] - 0xAA000000);
			
			//Note: The order of adding matters!
			// Locked are added first so Hover draws in front.
			totalGrp.add(displayLockedBars[i]);
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
		
		displayImage = new DisplaySprite(x + 900, y + 340, AssetPaths.IngredientSpriteSheet__png,
		                                 145, 125, 1, 3);
		totalGrp.add(displayImage);
	}
	
	private function clearHoverInfo(ingIndex:Int):Void
	{
		//The if test below is required for the following reasons:
		
		//The FlxMouseEventManager does  callbacks in this order:
		// OVER, OUT, DOWN, UP
		// This means that if the mouse leaves a button and enters
		// a new one on the same frame, then an object responding
		// to both buttons will recieve an "OVER" event for the new
		// button, then an "OUT" event for the button that the mouse
		// just left.
		
		// Perferred behavior would be if the manager checked for events
		// on the old button first, then handled new buttons. Would be
		// an easy change in the repo, just involves moving a block of 
		// code around.
		
		if (currHoverIngID == ingIndex) 
		{
			displayName.text = "";
			displayDescription.text = "";
			displayImage.animation.play("0");
			displayColorHover.array = [0, 0, 0, 0, 0, 0, 0, 0];
			
			currHoverIngID = -1;
		}
	}
	
	private function updateHoverBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayColorHover.array.length)
		{
			displayColorHover.array[i] = ingredient.colorValues[i] + displayColorLocked.array[i];
		}
	}
	
	private function updateLockedBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayColorLocked.array.length)
		{
			displayColorLocked.array[i] += ingredient.colorValues[i];
		}
	}
	
	private function setHoverInfo(ingIndex:Int):Void
	{
		var ingredient = ingInfo[ingIndex];
		
		displayName.text = ingredient.name;
		displayName.x = x + displayNameCenterX - displayName.width/2;
		displayDescription.text = ingredient.description;
		displayImage.animation.play(Std.string(ingIndex % 2 + 1));
		
		updateHoverBars(ingredient);
		
		currHoverIngID = ingIndex;
	}
	
	private function lockIngredient(ingIndex:Int):Void
	{
		//Need to check if there is an open ingredient spot
		var ingredient = ingInfo[ingIndex];
		
		updateLockedBars(ingredient);
		updateHoverBars(ingredient);
	}
	
	private function ingHexOut(id:Int):Void
	{
		clearHoverInfo(id);
	}
	
	private function ingHexOver(id:Int):Void
	{
		setHoverInfo(id);
	}
	
	private function ingHexDown(id:Int):Void
	{
		//Do whatever happens when the mouse is pressed over an ingredient button.
		// Probably nothing, but it's nice to have in the array of notfiy callbacks.
	}

	private function ingHexUp(id:Int):Void
	{
		lockIngredient(id);
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		notifyCallbacks[event.getData()](event.getID());
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
}