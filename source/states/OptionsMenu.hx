package states;

import buttons.Button;
import buttons.functions.ExitSubstate;
import buttons.functions.QuitGame;
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
		FlxG.plugins.removeType(FlxMouseEventManager); // Necessary due to a bug in HaxeFlixel
		FlxMouseEventManager.init();
		
		add(new Button(800, 400, QuitGame));
		add(new Button(800, 525, ExitSubstate));
		
		super.create();
	}
	
	
	
}