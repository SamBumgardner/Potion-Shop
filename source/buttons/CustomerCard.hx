package buttons;

import buttonTemplates.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.CustomerDetails;

/**
 * Data needed to instantiate a "open options" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class CustomerCard extends Button
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.CustomerCard__png;
		bWidth = 800;
		bHeight = 400;
		
		super(X, Y);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		(cast FlxG.state).activateSubstate(CustomerDetails);
	}
}