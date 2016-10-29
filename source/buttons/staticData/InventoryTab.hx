package buttons.staticData;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * Data needed to instantiate an "open inventory state" Button.
 * This class's fields should usually be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class InventoryTab
{
	public static var image:FlxGraphicAsset = AssetPaths.InventoryStateButton__png;
	public static var frameWidth:Int = 150;
	public static var frameHeight:Int = 250;

	public static function mouseUp(button:Button):Void{}
	
	public static function mouseDown(button:Button):Void{}
	
	public static function mouseOver(button:Button):Void
	{
		FlxTween.tween(button, {x: button.anchorX - 25}, .3, {ease: FlxEase.circOut});
	}
	
	public static function mouseOut(button:Button):Void
	{
		FlxTween.tween(button, {x: button.anchorX}, .3, {ease: FlxEase.circOut});
	}
	
}