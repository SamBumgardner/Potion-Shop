package;

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
		add(new Button(720, 350, AssetPaths.PlaceholderButton__png, 500, 100, function(){}, function(){FlxG.switchState(new IntroMenuState()); }, function(){}, function(){}));
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