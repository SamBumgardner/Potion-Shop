package buttons.staticData;

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
	
	public static var activeXOffset:Int = 0;
	public static var activeYOffset:Int = 0;

	public static function mouseUp(button:Button):Void
	{
		GameManager.quitGame();
	}
	
	public static function mouseDown(button:Button):Void{}
	
	public static function mouseOver(button:Button):Void{}
	
	public static function mouseOut(button:Button):Void{}
	
	public static function activate(button:Button):Void{}
	
	public static function deactivate(button:Button):Void{}
}