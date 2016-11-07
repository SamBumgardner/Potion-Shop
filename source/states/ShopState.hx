package states;

import buttons.Button;
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
	private var sideTabs:FlxTypedGroup<Button>;
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
		
		add(new Button(720, 800, QuitGame));
	}
	
	private function initSideTabs():Void
	{
		sideTabs = new FlxTypedGroup<Button>();
		
		var sideTabX = FlxG.width - BrewTab.frameWidth / 1.9;
		var middleSideTabY = (FlxG.height - BrewTab.frameHeight) / 2;
		var YInterval = BrewTab.frameHeight * 1.1;
		
		sideTabs.add(new Button(sideTabX, middleSideTabY - YInterval, CustomerTab, true));
		sideTabs.add(new Button(sideTabX, middleSideTabY, BrewTab));
		sideTabs.add(new Button(sideTabX, middleSideTabY + YInterval, InventoryTab));
		
		add(sideTabs);
	}
	
	private function initCustCards():Void
	{
		custCards = new FlxTypedGroup<Button>();
		
		var numOfVisibleCards = 4;
		
		var XIntervalMod = 1.01;
		var YIntervalMod = 1.01;
		var topLeftX = FlxG.width - CustomerCard.frameWidth * (2.2 * XIntervalMod);
		var topLeftY = FlxG.height - CustomerCard.frameHeight * (2.2 * YIntervalMod);
		var XInterval = CustomerCard.frameWidth * XIntervalMod;
		var YInterval = CustomerCard.frameHeight * YIntervalMod;
		
		for (row in 0...(cast numOfVisibleCards / 2))
		{
			for (col in 0...2)
			{
				custCards.add(new Button(topLeftX + col * XInterval, topLeftY + row * YInterval, CustomerCard));
			}
		}
		
		add(custCards);
	}
	
	private function initBrewButtons():Void
	{
		brewButtons = new FlxTypedGroup<Button>();
		
		var numRows = 8;
		var evenCols = 3;
		var oddCols = 4;
		
		var XIntervalMod = 1.6;
		var YIntervalMod = .55;
		
		var topLeftX = 100;
		var topLeftY = 100;
		
		var evenXOffset = IngredientHex.frameWidth * .8;
		
		var XInterval = IngredientHex.frameWidth * XIntervalMod;
		var YInterval = IngredientHex.frameHeight * YIntervalMod;
		
		for (row in 0...numRows)
		{
			if (row % 2 == 0)
			{
				for (col in 0...evenCols)
				{
					brewButtons.add(new Button(topLeftX + evenXOffset + col * XInterval, topLeftY + row * YInterval, IngredientHex));
				}
			}
			else
			{
				for (col in 0...oddCols)
				{
					brewButtons.add(new Button(topLeftX + col * XInterval, topLeftY + row * YInterval, IngredientHex));
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
	
	private function switchActiveTab(button:Button):Void
	{
		sideTabs.forEach(Button.deactivate);
		Button.activate(button);
	}
	
	public function switchShopMode(button:Button, group:ShopButtonGroup):Void
	{
		switchActiveTab(button);
		currentButtonSet.forEach(Button.hide);
		buttonGroups[group].forEach(Button.reveal);
		currentButtonSet = buttonGroups[group];
	}
}