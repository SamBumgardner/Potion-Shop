package states;

import buttons.functions.Simple;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.ShopState;
import buttons.Button;

class IntroMenuState extends FlxState
{
	override public function create():Void
	{
		add(new Button(720, 375, Simple));
		super.create();
	}
	
	override public function switchTo(nextState:FlxState):Bool
	{
		FlxMouseEventManager.removeAll();
		return super.switchTo(nextState);
	}
	override public function closeSubState():Void
	{
		super.closeSubState();
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
		
		forEachOfType(Button, Button.register);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}