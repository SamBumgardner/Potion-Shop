package containers;

import buttonTemplates.ActiveButton;
import buttons.InvPotionButton;
import flixel.group.FlxGroup;
import utilities.ButtonEvent;
import utilities.Observer;
import utilities.PotionData;

using utilities.EventExtender;

/**
 * ...
 * @author Samuel Bumgardner
 */
class InventoryTable extends Hideable implements Observer
{
	private var totalGrp:FlxGroup = new FlxGroup();
	
	private var newEvents:Array<ButtonEvent> = new Array<ButtonEvent>();
	private var eventCallbacks:Array<Array<ButtonEvent->Void>> = new Array<Array<ButtonEvent->Void>>();
	
	private var potionRowArray:Array<PotionRow> = new Array<PotionRow>();
	private var potionDataArray:Array<PotionData> = new Array<PotionData>();
	private var selectedPotionIndex:Int = -1;
	private var selectedPotionRowIndex:Int = -1;
	
	public function new(?X:Int = 0, ?Y:Int = 0) 
	{
		super(X, Y, AssetPaths.InventoryTable__png);
		
		totalGrp.add(this);
		
		initEventSystem();
		initPotionRows();
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
	
	private function initPotionRows():Void
	{
		var numOfRows:Int = 3;
		
		var topLeftX:Int = 37;
		var topLeftY:Int = 53;
		var yInterval:Int = 160 + 10;
		
		var potionRow:PotionRow;
		var currPotionArray:Array<InvPotionButton>;
		for (i in 0...numOfRows)
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
	}
	
	public function getTotalGrp():FlxGroup
	{
		return totalGrp;
	}
	
	///////////////////////////////////////////
	//         MISC. BUTTON ACTIONS          // 
	///////////////////////////////////////////
	
	private function switchActivePotionButton(event:ButtonEvent):Void
	{
		var potionsPerRow = 9;
		if (selectedPotionIndex != -1)
		{
			ActiveButton.deactivate(potionRowArray[selectedPotionRowIndex]
			            .getPotionButtonArray()[selectedPotionIndex % potionsPerRow]);
		}
		selectedPotionIndex = event.getID();
		
		var newSelectedRow:Int = Math.floor(event.getID() / potionsPerRow);
		if (selectedPotionRowIndex != newSelectedRow && selectedPotionRowIndex != -1)
		{
			potionRowArray[selectedPotionRowIndex].unselected();
		}
		potionRowArray[newSelectedRow].selected();
		selectedPotionRowIndex = newSelectedRow;
	}
	
	///////////////////////////////////////////
	//      INV POTION BUTTON CALLBACKS      //
	///////////////////////////////////////////
	
	private function potionInvOut(event:ButtonEvent):Void
	{
		//Clear hover index
	}
	
	private function potionInvOver(event:ButtonEvent):Void
	{
		//Set hover index
	}
	
	private function potionInvDown(event:ButtonEvent):Void
	{
		//Do nothing.
	}
	
	private function potionInvUp(event:ButtonEvent):Void
	{
		switchActivePotionButton(event);
	}
	
	public function onNotify(event:ButtonEvent):Void 
	{
		newEvents[event.getData()] = event;
	}
	
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
		super.update(elapsed);
	}
}

@:enum
class LocalButtonTypes
{
	public static var NO_TYPE(default, never)       = -1;
	public static var POTION_INV(default, never)    = 0;
}