package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Class that serves as an intermediary between FlxState and this game's states.
 * @author Samuel Bumgardner
 */
class AdvancedState extends FlxState
{
	private var backgroundImg:FlxSprite;
	
	private function setUpBackground(bgImg:FlxGraphicAsset)
	{
		backgroundImg = new FlxSprite(0, 0, bgImg);
		add(backgroundImg);
	}
	
	private function resetMouseEventManager():Void
	{
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
	}
}