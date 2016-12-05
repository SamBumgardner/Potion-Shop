package states;

import buttonTemplates.Button;
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
		//Currently only works on remove-logic-refactoring branch of flixel.
		FlxMouseEventManager.removeAll();
	}
	
	public function activateSubstate(caller:Button, substateClass):Void
	{
		caller.mouseOut(caller);
		openSubState(Type.createInstance(substateClass, []));
	}
	
	override public function closeSubState():Void
	{
		resetMouseEventManager();
		forEachOfType(Button, Button.register, true);
		super.closeSubState();
	}
}