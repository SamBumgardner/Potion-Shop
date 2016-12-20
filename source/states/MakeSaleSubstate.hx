package states;

import buttonTemplates.Button;
import buttonTemplates.SimpleObservableButton;
import buttons.CustomerCard;
import containers.CustContainer;
import containers.InventoryTable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import utilities.ButtonEvent;
import utilities.CustomerData;
import utilities.Observer;

using utilities.EventExtender;

/**
 * Substate that displays more detailed info about a customer.
 * @author Samuel Bumgardner
 */
class MakeSaleSubstate extends FlxSubState implements Observer
{
	private var creator:CustContainer;
	private var customerInfo:CustomerData;
	private var inactiveCustCard:CustomerCard;
	private var saleInvTable:InventoryTable;
	
	public function new(madeBy:CustContainer, dataToDisplay:CustomerData)
	{
		creator = madeBy;
		customerInfo = dataToDisplay;
		
		super(0xCC808080);
	}
	
	override public function create() 
	{
		super.create();
		
		resetMouseEventManager();
		inactiveCustCard = new CustomerCard(660, 1, customerInfo);
		FlxMouseEventManager.remove(inactiveCustCard);
		add(inactiveCustCard.getTotalFlxGrp());
		
		saleInvTable = new InventoryTable(210, 189);
		saleInvTable.grayOutInvalidPotions(customerInfo);
		add(saleInvTable.getTotalGrp());
		
		var confirmButton = new SimpleObservableButton(655, 929, LocalButtonTypes.CONFIRM, 
		                        true, AssetPaths.SellButton__png, 300, 150);
		confirmButton.sub.addObserver(this);
		
		var cancelButton = new SimpleObservableButton(965, 929, LocalButtonTypes.CANCEL,
		                   true, AssetPaths.CancelButton__png, 300, 150);
		cancelButton.sub.addObserver(this);
		
		add(confirmButton);
		add(cancelButton);
	}
	
	private function resetMouseEventManager():Void
	{
		//Currently only works on remove-logic-refactoring branch of flixel.
		FlxMouseEventManager.removeAll();
	}
	
	private function attemptPotionSale():Void
	{
		var potionIndex:Int = saleInvTable.getSelectedPotionIndex();
		if (potionIndex != -1)
		{
			GameManager.potionDataArray.remove(GameManager.potionDataArray[potionIndex]);
			GameManager.saleSucceeded(creator);
			close();
		}
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		if (event.getData() == EventData.UP)
		{
			switch(event.getType())
			{
				case LocalButtonTypes.CONFIRM: attemptPotionSale();
				case LocalButtonTypes.CANCEL: close();
			}
		}
	}
}

@:enum
class LocalButtonTypes
{
	public static var NO_TYPE(default, never)       = -1;
	public static var CONFIRM(default, never)       = 0;
	public static var CANCEL(default, never)        = 1;
}