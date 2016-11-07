package states;

import buttonTemplates.Button;
import buttons.ExitSubstate;
import buttons.QuitGame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;

/**
 * Substate that holds various objects that allow the user to change game settings.
 * @author Samuel Bumgardner
 */
class OptionsMenu extends FlxSubState
{
	
	override public function create() 
	{
		super.create();
		
		resetMouseEventManager();
		
		add(new QuitGame(800, 400));
		add(new ExitSubstate(800, 525));
	}
	
	private function resetMouseEventManager():Void
	{
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
	}
}