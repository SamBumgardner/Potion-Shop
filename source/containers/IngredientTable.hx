package containers;

import buttonTemplates.Button;
import buttons.IngredientHex;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import utilities.ButtonEvent;
import utilities.ButtonEvent.EventData;
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
	private var ingHexArray:Array<IngredientHex>;
	private var totalGrp:FlxGroup;
	
	private var notifyCallbacks:Array<Int->Void>;
	
	private var ingInfo:Array<IngredientData>;
	
	private var currHoverIngID:Int;
	private var displayDescription:FlxText;
	private var displayColorHover:Array<Int>;
	private var displayColorLocked:Array<Int>;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		totalGrp = new FlxGroup();
		
		initNotifyCallbacks();
		initIngInfo();
		initIngredientButtons();
		
		displayDescription = new FlxText(50, 50, 0, "HI", 24);
		displayDescription.set_color(FlxColor.BLACK);
		totalGrp.add(displayDescription);
		
		displayColorHover = [0, 0, 0, 0, 0, 0, 0, 0];
		displayColorLocked = [0, 0, 0, 0, 0, 0, 0, 0];
		
		totalGrp.add(this);
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
		ingInfo = new Array<IngredientData>();
		
		// Just setting up an array of dummy ingredient info,
		// making sure that I can get the other components working first.
		for (i in 0...28)
		{
			ingInfo.push(new IngredientData([1, 1, 1, 1, 1, 1, 1, 1], 300, "Description for " + Std.string(i) + " Here!", AssetPaths.HexButton__png));
		}
	}
	
	private function initIngredientButtons():Void
	{
		ingHexArray = new Array<IngredientHex>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var ingredientHexWidth = 145;
		var ingredientHexHeight = 125;
		
		var numRows = 8;
		var evenCols = 3;
		var oddCols = 4;
		
		var XIntervalMod = 1.6;
		var YIntervalMod = .55;
		
		var topLeftX = 100;
		var topLeftY = 100;
		
		var evenXOffset = ingredientHexWidth * .8;
		
		var XInterval = ingredientHexWidth * XIntervalMod;
		var YInterval = ingredientHexHeight * YIntervalMod;
		
		for (row in 0...numRows)
		{
			if (row % 2 == 0)
			{
				for (col in 0...evenCols)
				{
					ingHexArray.push(new IngredientHex(topLeftX + evenXOffset + col * XInterval, topLeftY + row * YInterval));
				}
			}
			else
			{
				for (col in 0...oddCols)
				{
					ingHexArray.push(new IngredientHex(topLeftX + col * XInterval, topLeftY + row * YInterval));
				}
			}
		}
		
		//This is a bit (prob. insignificantly) inefficient, but it's more readable.
		for (i in 0...ingHexArray.length)
		{
			ingHexArray[i].setID(i);
			ingHexArray[i].addObserver(this);
			totalGrp.add(ingHexArray[i]);
		}
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
			displayDescription.text = "";
			displayColorHover = [0, 0, 0, 0, 0, 0, 0, 0];
			
			currHoverIngID = -1;
		}
	}
	
	private function setHoverInfo(ingIndex:Int):Void
	{
		var ingredient = ingInfo[ingIndex];
		displayDescription.text = ingredient.description;
		displayColorHover = ingredient.colorValues;
		
		currHoverIngID = ingIndex;
	}
	
	private function lockIngredient(ingIndex:Int):Void
	{
		//Need to check if there is an open ingredient spot
		var ingredient = ingInfo[ingIndex];
		
		for (i in 0...displayColorLocked.length)
		{
			displayColorLocked[i] += ingredient.colorValues[i];
		}
		
		// also need to add the ingredient's graphic to the proper hexagon.
		
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