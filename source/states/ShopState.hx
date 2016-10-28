package states;

import buttons.Button;
import buttons.functions.QuitGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class ShopState extends AdvancedState
{
	override public function create():Void
	{
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.ShopBg__png);
		
		add(new Button(720, 800, QuitGame));
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