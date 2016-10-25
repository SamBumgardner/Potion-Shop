package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class IntroMenuState extends FlxState
{
	override public function create():Void
	{
		add(new Button(720, 375, AssetPaths.PlaceholderButton__png, 500, 100, function(){}, function(){FlxG.switchState(new ShopState()); }, function(){}, function(){}));
		add(new Button(720, 500, AssetPaths.PlaceholderButton__png, 500, 100, function(){}, function(){}, function(){}, function(){}));
		add(new Button(720, 625, AssetPaths.PlaceholderButton__png, 500, 100, function(){}, function(){System.exit(0);}, function(){}, function(){}));
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