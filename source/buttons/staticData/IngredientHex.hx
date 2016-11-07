package buttons.staticData;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Data needed to instantiate an "ingredient hexagon" Button.
 * This class's fields should only be accessed from within the Button class. 
 * @author Samuel Bumgardner
 */

class IngredientHex
{
	public static var image:FlxGraphicAsset = AssetPaths.HexButton__png;
	public static var frameWidth:Int = 145;
	public static var frameHeight:Int = 125;
	
	public static var activeXOffset:Int = 0;
	public static var activeYOffset:Int = 0;

	public static function mouseUp(button:Button):Void{}
	
	public static function mouseDown(button:Button):Void{}
	
	public static function mouseOver(button:Button):Void{}
	
	public static function mouseOut(button:Button):Void{}
	
	public static function activate(button:Button):Void{}
	
	public static function deactivate(button:Button):Void{}
}