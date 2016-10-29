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
 * Substate that holds various objects that allow the user to change game settings.
 * @author Samuel Bumgardner
 */
class OptionsMenu extends FlxSubState
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