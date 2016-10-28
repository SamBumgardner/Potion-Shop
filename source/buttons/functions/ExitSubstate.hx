package buttons.functions;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.OptionsMenu;

/**
 * Data needed to instantiate an "exit sub-menu" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class ExitSubstate
{
	public static var image:FlxGraphicAsset = AssetPaths.DoneButton__png;
	public static var frameWidth:Int = 500;
	public static var frameHeight:Int = 100;

	public static function mouseUp():Void
	{
		FlxG.state.closeSubState();
	}
	
	public static function mouseDown():Void{}
	
	public static function mouseOver():Void{}
	
	public static function mouseOut():Void{}
}