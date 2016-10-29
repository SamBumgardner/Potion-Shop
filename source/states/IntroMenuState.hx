package states;

import buttons.staticData.LoadGame;
import buttons.staticData.NewGame;
import buttons.staticData.OpenOptions;
import buttons.staticData.QuitGame;
import buttons.staticData.Simple;
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
}