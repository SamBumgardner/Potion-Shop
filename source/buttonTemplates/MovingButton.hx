package buttonTemplates;

import buttonTemplates.ActiveButton;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * Extends ActiveButton so it can move between different points when switched
 * between active and inactive.
 * Experimented with a different documentation style in this file,
 * since it's probably one of the most heavily used classes in this game.
 * 
 * @author Samuel Bumgardner
 */
class MovingButton extends ActiveButton
{
	private var anchorX:Float;
	private var anchorY:Float;
	private var activeAnchorChangeX:Int;
	private var activeAnchorChangeY:Int;
	
	private var OffsetX:Int;
	private var OffsetY:Int;
	private var activeOffsetChangeX:Int;
	private var activeOffsetChangeY:Int;
	
	private var currentTween:FlxTween;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 * @param	beginActive   Applies adjusted positioning and any other necessary changes
	 *       	              to the button so that it appears active upon instantiation.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?defaultGraphicsInit:Bool = true, ?beginActive:Bool)
	{
		anchorX = X;
		anchorY = Y;
		
		super(anchorX, anchorY, defaultGraphicsInit, beginActive);
		
		if (beginActive)
		{
			x = anchorX;
			y = anchorY;
		}
	}
	
	override public function mActivate():Void
	{
		anchorX += activeAnchorChangeX;
		anchorY += activeAnchorChangeY;
		OffsetX += activeOffsetChangeX;
		OffsetY += activeOffsetChangeY;
	}
	
	override public function mDeactivate():Void
	{
		anchorX -= activeAnchorChangeX;
		anchorY -= activeAnchorChangeY;
		OffsetX -= activeOffsetChangeX;
		OffsetY -= activeOffsetChangeY;
	}
	
	public function moveToOffset():Void
	{
		if (currentTween != null)
		{
			currentTween.cancel();
		}
		currentTween = FlxTween.tween(this, {x: this.anchorX + OffsetX , y: this.anchorY + OffsetY}, .3, {ease: FlxEase.circOut});
	}
	
	public function moveToAnchor():Void
	{
		if (currentTween != null)
		{
			currentTween.cancel();
		}
		currentTween = FlxTween.tween(this, {x: this.anchorX, y: this.anchorY}, .3, {ease: FlxEase.circOut});
	}
}