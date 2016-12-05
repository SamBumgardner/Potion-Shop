package states;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttonTemplates.ActiveButton;
import buttonTemplates.Tab;
import buttons.BrewTab;
import buttons.CustomerCard;
import buttons.CustomerTab;
import buttons.IngredientHex;
import buttons.InventoryTab;
import buttons.QuitGame;
import containers.BrewContainer;
import containers.InventoryTable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
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
	private var custCards:FlxGroup;
	private var brewContainer:BrewContainer;
	private var brewContents:FlxGroup;
	private var inventoryContents:FlxGroup;
	
	private var buttonGroups:Map<ShopButtonGroup, FlxGroup>;
	
	override public function create():Void
	{
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.ShopBg__png);
		
		initSideTabs();
		initCustCards();
		initBrewContent();
		initinventoryContents();
		
		currentButtonSet = custCards;
		
		buttonGroups = [
			Customer => custCards,
			Brew => brewContents,
			Inventory => inventoryContents
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
	
	private function initCustCards():Void
	{
		custCards = new FlxGroup();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var customerCardWidth = 800;
		var customerCardHeight = 400;
		
		var numOfVisibleCards = 4;
		
		var XIntervalMod = 1.01;
		var YIntervalMod = 1.01;
		var topLeftX = FlxG.width - customerCardWidth * (2.2 * XIntervalMod);
		var topLeftY = FlxG.height - customerCardHeight * (2.2 * YIntervalMod);
		var XInterval = customerCardWidth * XIntervalMod;
		var YInterval = customerCardHeight * YIntervalMod;
		
		for (row in 0...(cast numOfVisibleCards / 2))
		{
			for (col in 0...2)
			{
				custCards.add(new CustomerCard(topLeftX + col * XInterval, topLeftY + row * YInterval));
			}
		}
		
		add(custCards);
	}
	
	private function initBrewContent():Void
	{
		brewContainer = new BrewContainer();
		brewContents = brewContainer.getTotalFlxGrp();
		
		brewContents.forEach(Hideable.Hide, true);
		add(brewContents);
	}
	
	private function initinventoryContents():Void
	{
		var inventoryTable = new InventoryTable(300, 215);
		
		inventoryContents = inventoryTable.getTotalGrp();
		
		inventoryContents.forEach(Hideable.Hide, true);
		add(inventoryContents);
	}
	
	private function switchActiveTab(tab:ActiveButton):Void
	{
		
		sideTabs.forEach(ActiveButton.deactivate, true);
		ActiveButton.activate(tab);
	}
	
	public function switchShopMode(tab:ActiveButton, group:ShopButtonGroup):Void
	{
		switchActiveTab(tab);
		currentButtonSet.forEach(Hideable.Hide, true);
		buttonGroups[group].forEach(Hideable.Reveal, true);
		currentButtonSet = buttonGroups[group];
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		if (event.getData() == EventData.UP)
		{
			switchShopMode(sideTabArray[event.getID()], cast event.getID());
		}
	}
}