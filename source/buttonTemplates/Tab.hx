package buttonTemplates;

import buttonTemplates.MovingButton;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.ShopButtonGroup;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Data needed to instantiate an "open brew state" Button.
 * 
 * @author Samuel Bumgardner
 */
@:tink class Tab extends MovingButton
{
	private var buttonGroup:ShopButtonGroup;
	@:forward var sub:Subject = new Subject(); //using tink_lang Syntactic Delegation.
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		activeAnchorChangeX = -28;
		activeAnchorChangeY = 0;
		activeOffsetChangeX = 28;
		activeOffsetChangeY = 0;
		OffsetX = -30;
		OffsetY = 0;
		
		bWidth = 150;
		bHeight = 250;
		
		super(X, Y, beginActive);
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
		moveToOffset();
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		moveToAnchor();
	}
	
	override public function mDeactivate():Void
	{
		super.mDeactivate();
		moveToAnchor();
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		
		if (!isActive)
		{
			notify(EventData.UP);
		}
	}
}