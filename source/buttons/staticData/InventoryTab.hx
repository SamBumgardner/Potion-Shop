package buttons.staticData;

import flixel.FlxG;
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
	
	private static var hoverXOffset:Int = 30;
	public static var activeXOffset:Int = 28;
	public static var activeYOffset:Int = 0;

	public static function mouseUp(button:Button):Void
	{
		(cast FlxG.state).activateInvMode(button);
	}
	
	public static function mouseDown(button:Button):Void{}
	
	public static function mouseOver(button:Button):Void
	{
		if (button.currentTween != null)
		{
			button.currentTween.cancel();
		}
		FlxTween.tween(button, {x: button.anchorX - hoverXOffset}, .3, {ease: FlxEase.circOut});
	}
	
	public static function mouseOut(button:Button):Void
	{
		if (button.currentTween != null)
		{
			button.currentTween.cancel();
		}
		FlxTween.tween(button, {x: button.anchorX}, .3, {ease: FlxEase.circOut});
	}
	
	public static function activate(button:Button):Void
	{
		button.anchorX -= activeXOffset;
		hoverXOffset -= activeXOffset;
	}
	
	public static function deactivate(button:Button):Void
	{
		button.anchorX += activeXOffset;
		hoverXOffset += activeXOffset;
		if (button.currentTween != null)
		{
			button.currentTween.cancel();
		}
		FlxTween.tween(button, {x: button.anchorX}, .3, {ease: FlxEase.circOut});
	}
}