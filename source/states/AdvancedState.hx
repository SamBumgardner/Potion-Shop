package states;

import buttons.Button;
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
	
	public function activateSubstate(substateClass):Void
	{
		forEachOfType(Button, function(button){button.mouseOut(button);}, true); // So no button is stuck in "hover" animation
		openSubState(Type.createInstance(substateClass, []));
	}
	
	override public function closeSubState():Void
	{
		resetMouseEventManager();
		forEachOfType(Button, Button.register, true);
		super.closeSubState();
	}
}