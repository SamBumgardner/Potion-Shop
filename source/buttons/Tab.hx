package buttons;

import buttons.MovingButton;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import utilities.ShopButtonGroup;

/**
 * Data needed to instantiate an "open brew state" Button.
 * 
 * @author Samuel Bumgardner
 */
class Tab extends MovingButton
{
	private var buttonGroup:ShopButtonGroup;

	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		activeXOffset = 28;
		activeYOffset = 0;
		hoverXOffset = 30;
		hoverYOffset = 0;
		
		bWidth = 150;
		bHeight = 250;
		
		super(X, Y, beginActive);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		
		var tButton:Tab = cast button;
		
		if (!tButton.isActive)
		{
			(cast FlxG.state).switchShopMode(button, tButton.buttonGroup);
		}
	}
}