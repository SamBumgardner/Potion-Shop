package buttons.functions;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.ShopState;

/**
 * Data needed to instantiate a "new game" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class NewGame
{
	public static var image:FlxGraphicAsset = AssetPaths.NewGameButton__png;
	public static var frameWidth:Int = 500;
	public static var frameHeight:Int = 100;

	public static function mouseUp():Void
	{
		GameManager.startNewGame();
	}
	
	public static function mouseDown():Void{}
	
	public static function mouseOver():Void{}
	
	public static function mouseOut():Void{}
	
}