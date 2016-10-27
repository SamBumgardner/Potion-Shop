package buttons.functions;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Data needed to instantiate a "load game" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class LoadGame
{
	public static var image:FlxGraphicAsset = AssetPaths.LoadGameButton__png;
	public static var frameWidth:Int = 500;
	public static var frameHeight:Int = 100;

	public static function mouseUp():Void
	{
		GameManager.startLoadGame();
	}
	
	public static function mouseDown():Void{}
	
	public static function mouseOver():Void{}
	
	public static function mouseOut():Void{}
	
}