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

class ShopState extends FlxState
{
	override public function create():Void
	{
		FlxG.plugins.removeType(FlxMouseEventManager); 
		FlxMouseEventManager.init(); // Hard resets the FlxMouseEventManager
		
		add(new Button(720, 800, QuitGame));
		
		super.create();
	}
	
	override public function switchTo(nextState:FlxState):Bool
	{
		FlxMouseEventManager.removeAll();
		return super.switchTo(nextState);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}