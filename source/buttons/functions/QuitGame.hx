package buttons.functions;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Data needed to instantiate a "quit game" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class QuitGame
{
	public static var image:FlxGraphicAsset = AssetPaths.QuitButton__png;
	public static var frameWidth:Int = 500;
	public static var frameHeight:Int = 100;

	public static function mouseUp():Void
	{
		GameManager.quitGame();
	}
	
	public static function mouseDown():Void{}
	
	public static function mouseOver():Void{}
	
	public static function mouseOut():Void{}
}