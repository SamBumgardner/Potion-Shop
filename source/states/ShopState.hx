package states;

import buttons.Button;
import buttons.staticData.BrewTab;
import buttons.staticData.CustomerTab;
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

class ShopState extends AdvancedState
{
	private var sideTabs:FlxTypedGroup<Button>;
	
	override public function create():Void
	{
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.ShopBg__png);
		
		initSideTabs();
		
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
	
	private function switchActiveTab(button:Button)
	{
		sideTabs.forEach(Button.deactivate);
		Button.activate(button);
	}
	
	public function activateCustMode(button:Button):Void
	{
		switchActiveTab(button);
	}
	
	public function activateBrewMode(button:Button):Void
	{
		switchActiveTab(button);
	}
	
	public function activateInvMode(button:Button):Void
	{
		switchActiveTab(button);
	}
}