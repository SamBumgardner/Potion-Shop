package containers;

import buttonTemplates.ActiveButton;
import buttons.InvPotionButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import graphicObjects.DisplaySprite;
import utilities.ButtonEvent;
import utilities.Observer;
import utilities.PotionData;

using utilities.EventExtender;

/**
 * Table that represents the player's available inventory.
 * May be extended in the future to represent potions and
 * ingredients.
 * @author Samuel Bumgardner
 */
class InventoryTable extends Hideable implements Observer
{
	private var totalGrp:FlxGroup = new FlxGroup();
	
	private var newEvents:Array<ButtonEvent> = new Array<ButtonEvent>();
	private var eventCallbacks:Array<Array<ButtonEvent->Void>> = new Array<Array<ButtonEvent->Void>>();
	
	private static var noPotion:PotionData;
	private var currentPotionPage:Int = 0;
	private var potionRowArray:Array<PotionRow> = new Array<PotionRow>();
	private var potionDataArray:Array<PotionData> = new Array<PotionData>();
	private var selectedPotionIndex:Int = -1;
	private var selectedPotionRowIndex:Int = -1;
	
	private var hoverIndex:Int = -1;
	private var selectedIndex:Int = -1;
	private var displayIndex:Int = -1;
	private var displayName:FlxText;
	private var displayPotionImg:DisplaySprite;
	private var displayPotionDesc:Array<FlxText> = new Array<FlxText>();
	private var displayIndexChanged:Bool = true;
	private var useSelectedDisplay:Bool = true;
	
	public function new(?X:Int = 0, ?Y:Int = 0) 
	{
		super(X, Y, AssetPaths.InventoryTable__png);
		
		totalGrp.add(this);
		
		initEventSystem();
		initPotionData();
		initPotionRows();
		updatePotionButtons();
		initDisplayComponents();
	}
	
	private function initEventSystem():Void
	{
		var numOfEventTypes = 4;
		
		for (i in 0...numOfEventTypes)
		{
			newEvents.push(LocalButtonTypes.NO_TYPE);
		}
		
		var numOfButtonTypes = 1; //see LocalButtonTypes
		for (i in 0...numOfEventTypes)
		{
			eventCallbacks.push(new Array<Int->Void>());
			for (j in 0...numOfButtonTypes)
			{
				eventCallbacks[i].push(null);
			}
		}
		
		eventCallbacks[EventData.OUT][LocalButtonTypes.POTION_INV] = potionInvOut;
		eventCallbacks[EventData.OVER][LocalButtonTypes.POTION_INV] = potionInvOver;
		eventCallbacks[EventData.DOWN][LocalButtonTypes.POTION_INV] = potionInvDown;
		eventCallbacks[EventData.UP][LocalButtonTypes.POTION_INV] = potionInvUp;
	}
	
	private function initPotionData():Void
	{
		if (noPotion == null)
		{
			var maxPotionEffects = 9;
			noPotion = new PotionData();
			noPotion.name = "";
		}
		
		//Makes the local potionDataArray automatically track GameManager's potionDataArray.
		potionDataArray =  Reflect.field(Type.resolveClass("GameManager"), "potionDataArray");
	}
	
	
	/**
	 * Should only be run if initPotionData has already completed.
	 * Relies on potionDataArray already being filled.
	 */
	private function initPotionRows():Void
	{
		var numOfRows:Int = 3;
		
		var topLeftX:Int = 37;
		var topLeftY:Int = 53;
		var yInterval:Int = 160 + 10;
		
		var potionRow:PotionRow;
		var currPotionArray:Array<InvPotionButton>;
		for (i in 0...(numOfRows + 1))
		{
			if (i < numOfRows)
			{
				potionRow = new PotionRow(x + topLeftX, y + topLeftY + yInterval * i);
				totalGrp.add(potionRow.getTotalFlxGrp());
				potionRowArray.push(potionRow);
				
				currPotionArray = potionRow.getPotionButtonArray();
				for (j in 0...currPotionArray.length)
				{
					currPotionArray[j].sub.setID(i * currPotionArray.length + j);
					currPotionArray[j].sub.setType(LocalButtonTypes.POTION_INV);
					currPotionArray[j].sub.addObserver(this);
				}
			}
			else
			{
				stamp(new FlxSprite(0, 0, AssetPaths.InventoryPotionInfo__png), topLeftX, 
				      topLeftY + yInterval * i);
			}
		}
	}
	
	private function initDisplayComponents():Void
	{
		hoverIndex = -1;
		selectedIndex = -1;
		
		var infoRowX = x + 37;
		var infoRowY = y + 53 + (160 + 10) * 3;
		var offsetY = 14;
		
		var nameTextOffsetX = 102;
		var nameTextOffsetY = offsetY + 40;
		
		var imgOffsetX = 325;
		
		var descTextOffsetX = imgOffsetX + 200;
		var descTextIntervalX = 260;
		var descTextIntervalY = 40;
		
		displayName = new FlxText(infoRowX + nameTextOffsetX, infoRowY + nameTextOffsetY, 200, "Overpowering yellow potion", 20);
		displayName.set_color(FlxColor.BLACK);
		totalGrp.add(displayName);
		displayName.alignment = FlxTextAlign.CENTER;
		
		displayPotionImg = new DisplaySprite(infoRowX + imgOffsetX, infoRowY + offsetY,
		                                     AssetPaths.PotionSpriteSheet__png, 145, 125,
		                                     2, 5);
		displayPotionImg.animation.play("1");
		totalGrp.add(displayPotionImg);
		
		var maxPotionEffects = 9;
		var cols = 3;
		var rows = 3;
		var tempFlxText:FlxText;
		for (i in 0...maxPotionEffects)
		{
			tempFlxText = new FlxText(infoRowX + descTextOffsetX + descTextIntervalX * (i % cols),
			                          10 + infoRowY + offsetY + descTextIntervalY * Math.floor(i / 3), 
			                          0, "description", 24);
			tempFlxText.set_color(FlxColor.BLACK);
			displayPotionDesc.push(tempFlxText);
			totalGrp.add(tempFlxText);
		}
	}
	
	
	///////////////////////////////////////////
	//           PUBLIC INTERFACE            //
	///////////////////////////////////////////
	
	/**
	 * Function that updates the appearance of the potion buttons
	 * to match the current contents of the potionDataArray.
	 */
	public function updatePotionButtons():Void
	{
		
		var numOfRows:Int = 3;
		
		var potionRow:PotionRow;
		var currPotionArray:Array<InvPotionButton>;
		var currPotionImgArray:Array<DisplaySprite>;
		
		for (i in 0...numOfRows)
		{
			potionRow = potionRowArray[numOfRows * currentPotionPage + i];
			
			currPotionArray = potionRow.getPotionButtonArray();
			currPotionImgArray = potionRow.getPotionImgArray();
			
			for (j in 0...currPotionArray.length)
			{
				if (potionDataArray[i * currPotionArray.length + j] != null)
				{
					FlxMouseEventManager.setObjectMouseEnabled(currPotionArray[j], true);
					currPotionImgArray[j].animation.play(Std.string(
										 potionDataArray[i * currPotionArray.length + j]
										 .colorByIndex + 1));
				}
				else
				{
					FlxMouseEventManager.setObjectMouseEnabled(currPotionArray[j], false);
					currPotionImgArray[j].animation.play("0");
				}
			}
		}
	}
	
	override public function hide():Void
	{
		super.hide();
		clearActivePotionButton();
		clearActivePotionRow();
		clearPotionHoverInfo();
	}
	
	override public function reveal():Void
	{
		super.reveal();
		updatePotionButtons();
	}
	
	public function getTotalGrp():FlxGroup
	{
		return totalGrp;
	}
	
	
	///////////////////////////////////////////
	//         MISC. BUTTON ACTIONS          // 
	///////////////////////////////////////////
	
	private function clearActivePotionButton():Void
	{
		var potionsPerRow = 9;
		if (selectedPotionIndex != -1)
		{
			ActiveButton.deactivate(potionRowArray[selectedPotionRowIndex]
			            .getPotionButtonArray()[selectedPotionIndex % potionsPerRow]);
			selectedPotionIndex = -1;
		}
	}
	
	private function clearActivePotionRow():Void
	{
		if (selectedPotionRowIndex != -1)
		{
			potionRowArray[selectedPotionRowIndex].unselected();
			selectedPotionRowIndex = -1;
		}
	}
	
	private function switchActivePotionButton(event:ButtonEvent):Void
	{
		var potionsPerRow = 9;
		clearActivePotionButton();
		selectedPotionIndex = event.getID();
		
		var newSelectedRow:Int = Math.floor(selectedPotionIndex / potionsPerRow);
		if (selectedPotionRowIndex != newSelectedRow)
		{
			clearActivePotionRow();
		}
		potionRowArray[newSelectedRow].selected();
		selectedPotionRowIndex = newSelectedRow;
	}
	
	
	///////////////////////////////////////////
	//  POTION DATA  MANIPULATION FUNCTIONS  //
	///////////////////////////////////////////
	
	private function clearPotionHoverInfo():Void
	{
		updatePotionDisplay(-1);
		displayPotionImg.animation.play("0");
	}
	
	private function updatePotionDisplay(potionIndex:Int):Void
	{
		var potion:PotionData;
		if (potionIndex != -1)
		{
			potion = potionDataArray[potionIndex];
		}
		else
		{
			potion = noPotion;
		}
		
		displayName.text = potion.name;
		var effectList:Array<String> = potion.description.split('\n');
		for (i in 0...9)
		{
			if (effectList[i] != null)
			{
				displayPotionDesc[i].text = effectList[i];
			}
			else
			{
				displayPotionDesc[i].text = "";
			}
		}
		displayPotionImg.animation.play(Std.string(potion.colorByIndex + 1));
	}
	
	///////////////////////////////////////////
	//      INV POTION BUTTON CALLBACKS      //
	///////////////////////////////////////////
	
	private function potionInvOut(event:ButtonEvent):Void
	{
		hoverIndex = -1;
	}
	
	private function potionInvOver(event:ButtonEvent):Void
	{
		hoverIndex = event.getID();
	}
	
	private function potionInvDown(event:ButtonEvent):Void
	{
		//Do nothing.
	}
	
	private function potionInvUp(event:ButtonEvent):Void
	{
		switchActivePotionButton(event);
		selectedIndex = event.getID();
	}
	
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
			if (newEvents[eventData].getType() != LocalButtonTypes.NO_TYPE)
			{
				var event:ButtonEvent = newEvents[eventData];
				eventCallbacks[eventData][event.getType()](event.getID());
				newEvents[eventData] = LocalButtonTypes.NO_TYPE;
			}
		}
		
		if (FlxG.keys.justPressed.ALT || (!useSelectedDisplay && hoverIndex == -1))
		{
			if (displayIndex != selectedIndex)
			{
				displayIndexChanged = true;
			}
			displayIndex = selectedIndex;
			useSelectedDisplay = true;
		}
		if (!FlxG.keys.pressed.ALT && hoverIndex != -1)
		{
			if (displayIndex != hoverIndex)
			{
				displayIndexChanged = true;
			}
			displayIndex = hoverIndex;
			useSelectedDisplay = false;
		}
		
		if (displayIndexChanged)
		{
			updatePotionDisplay(displayIndex);
			displayIndexChanged = false;
		}
		
		super.update(elapsed);
	}
}

@:enum
class LocalButtonTypes
{
	public static var NO_TYPE(default, never)       = -1;
	public static var POTION_INV(default, never)    = 0;
}