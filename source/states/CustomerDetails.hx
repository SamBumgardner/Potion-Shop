package states;

import buttons.Button;
import buttons.staticData.ExitSubstate;
import buttons.staticData.QuitGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;

/**
 * Substate that displays more detailed info about a customer.
 * @author Samuel Bumgardner
 */
class CustomerDetails extends FlxSubState
{
	
	override public function create() 
	{
		super.create();
		
		resetMouseEventManager();
		
		add(new Button(800, 400, QuitGame));
		add(new Button(800, 525, ExitSubstate));
	}
	
	private function resetMouseEventManager():Void
	{
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
	}
}