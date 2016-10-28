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
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.ShopState;
import buttons.Button;

class IntroMenuState extends AdvancedState
{
	
	private var MenuOptions:FlxTypedGroup<Button>;
	
	override public function create():Void
	{	
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.IntroMenuBg__png);
		
		MenuOptions = new FlxTypedGroup<Button>();
		MenuOptions.add(new Button(720, 375, NewGame)); 
		MenuOptions.add(new Button(720, 500, LoadGame));
		MenuOptions.add(new Button(720, 625, OpenOptions));
		MenuOptions.add(new Button(720, 750, QuitGame));
		
		add(MenuOptions);
	}
	
	override public function switchTo(nextState:FlxState):Bool
	{
		return super.switchTo(nextState);
	}
	
	public function activateSubstate(substateClass):Void
	{
		forEachOfType(Button, Button.MouseOut); // So no button is stuck in "hover" animation
		openSubState(Type.createInstance(substateClass, []));
	}
	
	override public function closeSubState():Void
	{
		resetMouseEventManager();
		forEachOfType(Button, Button.register);
		super.closeSubState();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}