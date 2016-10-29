package buttons.staticData;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.OptionsMenu;

/**
 * Data needed to instantiate a "open options" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class OpenOptions
{
	public static var image:FlxGraphicAsset = AssetPaths.OptionsButton__png;
	public static var frameWidth:Int = 500;
	public static var frameHeight:Int = 100;

	public static function mouseUp(button:Button):Void
	{
		(cast FlxG.state).activateSubstate(OptionsMenu);
	}
	
	public static function mouseDown(button:Button):Void{}
	
	public static function mouseOver(button:Button):Void{}
	
	public static function mouseOut(button:Button):Void{}
}