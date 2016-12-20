package buttons;

import buttonTemplates.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.OptionsMenu;

/**
 * Data needed to instantiate a "open options" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class OpenOptions extends Button
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.OptionsButton__png;
		bWidth = 500;
		bHeight = 100;
		
		super(X, Y);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		(cast FlxG.state).activateSubstate(this, OptionsMenu);
	}
}