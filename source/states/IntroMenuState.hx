package states;

import buttons.LoadGame;
import buttons.NewGame;
import buttons.OpenOptions;
import buttons.QuitGame;
import buttons.Simple;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import states.ShopState;
import buttonTemplates.Button;

class IntroMenuState extends AdvancedState
{
	
	private var MenuOptions:FlxTypedGroup<Button>;
	
	override public function create():Void
	{	
		super.create();
		resetMouseEventManager();
		
		setUpBackground(AssetPaths.IntroMenuBg__png);
		
		MenuOptions = new FlxTypedGroup<Button>();
		MenuOptions.add(new NewGame(720, 375)); 
		MenuOptions.add(new LoadGame(720, 500));
		MenuOptions.add(new OpenOptions(720, 625));
		MenuOptions.add(new QuitGame(720, 750));
		
		add(MenuOptions);
	}
}