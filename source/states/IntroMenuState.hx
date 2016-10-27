package states;

import buttons.functions.LoadGame;
import buttons.functions.NewGame;
import buttons.functions.OpenOptions;
import buttons.functions.QuitGame;
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
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
		
		add(new Button(720, 375, NewGame)); 
		add(new Button(720, 500, LoadGame));
		add(new Button(720, 625, OpenOptions));
		add(new Button(720, 750, QuitGame));
		
		super.create();
	}
	
	override public function switchTo(nextState:FlxState):Bool
	{
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
		
		return super.switchTo(nextState);
	}
	
	public function activateSubstate(substateClass):Void
	{
		forEachOfType(Button, Button.MouseOut); // So no button is stuck in "hover" animation
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
		
		openSubState(Type.createInstance(substateClass, []));
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