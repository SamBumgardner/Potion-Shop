package states;

import buttons.ActiveButton;
import buttons.Button;
import buttons.ActiveButton;
import buttons.staticData.BrewTab;
import buttons.staticData.CustomerCard;
import buttons.staticData.CustomerTab;
import buttons.staticData.IngredientHex;
import buttons.staticData.InventoryTab;
import buttons.staticData.QuitGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import utilities.ShopButtonGroup;

class ShopState extends AdvancedState
{
	private var sideTabs:FlxTypedGroup<ActiveButton>;
	private var currentButtonSet:FlxTypedGroup<Button>;
	private var custCards:FlxTypedGroup<Button>;
	private var brewButtons:FlxTypedGroup<Button>;
	private var inventoryButtons:FlxTypedGroup<Button>;
	
	private var buttonGroups:Map<ShopButtonGroup, FlxTypedGroup<Button>>;
	
	override public function create():Void
	{
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.ShopBg__png);
		
		initSideTabs();
		initCustCards();
		initBrewButtons();
		initInventoryButtons();
		
		currentButtonSet = custCards;
		
		buttonGroups = [
			Customer => custCards,
			Brew => brewButtons,
			Inventory => inventoryButtons
		];
		
		add(new QuitGame(720, 800));
	}
	
	private function initSideTabs():Void
	{
		sideTabs = new FlxTypedGroup<ActiveButton>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var tabWidth = 150;
		var tabHeight = 250;
		
		var sideTabX = FlxG.width - tabWidth / 1.9;
		var middleSideTabY = (FlxG.height - tabHeight) / 2;
		var YInterval = tabHeight * 1.1;
		
		sideTabs.add(new CustomerTab(sideTabX, middleSideTabY - YInterval, true));
		sideTabs.add(new BrewTab(sideTabX, middleSideTabY));
		sideTabs.add(new InventoryTab(sideTabX, middleSideTabY + YInterval));
		
		add(sideTabs);
	}
	
	private function initCustCards():Void
	{
		custCards = new FlxTypedGroup<Button>();
		
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
	
	private function initBrewButtons():Void
	{
		brewButtons = new FlxTypedGroup<Button>();
		
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
					brewButtons.add(new IngredientHex(topLeftX + evenXOffset + col * XInterval, topLeftY + row * YInterval));
				}
			}
			else
			{
				for (col in 0...oddCols)
				{
					brewButtons.add(new IngredientHex(topLeftX + col * XInterval, topLeftY + row * YInterval));
				}
			}
		}
		
		brewButtons.forEach(Button.hide);
		add(brewButtons);
	}
	
	private function initInventoryButtons():Void
	{
		inventoryButtons = new FlxTypedGroup<Button>();
		
		add(inventoryButtons);
	}
	
	private function switchActiveTab(tab:ActiveButton):Void
	{
		sideTabs.forEach(ActiveButton.deactivate);
		ActiveButton.activate(tab);
	}
	
	public function switchShopMode(tab:ActiveButton, group:ShopButtonGroup):Void
	{
		switchActiveTab(tab);
		currentButtonSet.forEach(Button.hide);
		buttonGroups[group].forEach(Button.reveal);
		currentButtonSet = buttonGroups[group];
	}
}