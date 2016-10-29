package states;

import buttons.Button;
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
		
		add(new Button(720, 800, QuitGame));
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
	
	override public function switchTo(nextState:FlxState):Bool
	{
		return super.switchTo(nextState);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}