package states;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttonTemplates.ActiveButton;
import buttonTemplates.Tab;
import buttons.BrewTab;
import buttons.CustomerTab;
import buttons.InventoryTab;
import containers.BrewContainer;
import containers.CustContainer;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Observer;
import utilities.ShopButtonGroup;

using utilities.EventExtender;

class ShopState extends AdvancedState implements Observer
{
	private var sideTabs:FlxTypedGroup<ActiveButton>;
	private var sideTabArray:Array<Tab>;
	private var currentButtonSet:FlxGroup;
	private var custContainer:CustContainer;
	private var custContents:FlxGroup;
	private var brewContainer:BrewContainer;
	private var brewContents:FlxGroup;
	private var inventoryButtons:FlxGroup;
	
	private var buttonGroups:Map<ShopButtonGroup, FlxGroup>;
	
	override public function create():Void
	{
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.ShopBg__png);
		
		initSideTabs();
		initCustContents();
		initBrewContent();
		initInventoryButtons();
		
		currentButtonSet = custContents;
		
		buttonGroups = [
			Customer => custContents,
			Brew => brewContents,
			Inventory => inventoryButtons
		];
	}
	
	private function initSideTabs():Void
	{
		sideTabArray = new Array<Tab>();
		sideTabs = new FlxTypedGroup<ActiveButton>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var tabWidth = 150;
		var tabHeight = 250;
		
		var sideTabX = FlxG.width - tabWidth / 1.9;
		var middleSideTabY = (FlxG.height - tabHeight) / 2;
		var YInterval = tabHeight * 1.1;
		
		sideTabArray.push(new CustomerTab(sideTabX, middleSideTabY - YInterval, true));
		sideTabArray.push(new BrewTab(sideTabX, middleSideTabY));
		sideTabArray.push(new InventoryTab(sideTabX, middleSideTabY + YInterval));
		
		for (i in 0...sideTabArray.length)
		{
			sideTabArray[i].sub.setID(i);
			sideTabArray[i].sub.addObserver(this);
			sideTabs.add(sideTabArray[i]);
		}
		
		add(sideTabs);
	}
	
	private function initCustContents():Void
	{
		custContainer = new CustContainer();
		custContainer.sub.addObserver(this);
		
		custContents = custContainer.getTotalFlxGrp();
		
		add(custContents);
	}
	
	private function initBrewContent():Void
	{
		brewContainer = new BrewContainer();
		brewContents = brewContainer.getTotalFlxGrp();
		
		brewContents.forEach(AdvancedSprite.Hide, true);
		add(brewContents);
	}
	
	private function initInventoryButtons():Void
	{
		inventoryButtons = new FlxGroup();
		
		add(inventoryButtons);
	}
	
	private function switchActiveTab(tab:ActiveButton):Void
	{
		
		sideTabs.forEach(ActiveButton.deactivate, true);
		ActiveButton.activate(tab);
	}
	
	private function switchShopMode(tab:ActiveButton, group:ShopButtonGroup):Void
	{
		switchActiveTab(tab);
		currentButtonSet.forEach(AdvancedSprite.Hide, true);
		buttonGroups[group].forEach(AdvancedSprite.Reveal, true);
		currentButtonSet = buttonGroups[group];
	}
	
	private function advanceTime():Void
	{
		brewContainer.advanceTime();
		forEach(AdvancedSprite.AdvanceTimeReset, true);
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		if (event.getData() == EventData.UP)
		{
			switch event.getType()
			{
				case ButtonTypes.TAB: 
					switchShopMode(sideTabArray[event.getID()], cast event.getID());
				case ButtonTypes.NEXT_PHASE:
					advanceTime();
			}
			
		}
	}
}