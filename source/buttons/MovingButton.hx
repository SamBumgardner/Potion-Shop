package buttons;

import buttons.ActiveButton;
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
	/**
	 * The original X position of this button.
	 * Used by tweening/animating buttons so they have an unchanging point of reference.
	 */
	private var anchorX:Float;
	
	/**
	 * The original Y position of this button.
	 * Used by  tweening/animating buttons so they have an unchanging point of reference.
	 */
	private var anchorY:Float;
	
	private var activeXOffset:Int;
	private var activeYOffset:Int;
	private var hoverXOffset:Int;
	private var hoverYOffset:Int;
	
	private var currentTween:FlxTween;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 * @param	beginActive   Applies adjusted positioning and any other necessary changes
	 *       	              to the button so that it appears active upon instantiation.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		anchorX = X;
		anchorY = Y;
		
		if (beginActive)
		{
			X -= activeXOffset;
			Y -= activeYOffset;
		}
		
		super(X, Y, beginActive);
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
		
		var mButton:MovingButton = cast button;
		
		if (mButton.currentTween != null)
		{
			mButton.currentTween.cancel();
		}
		mButton.currentTween = FlxTween.tween(button, {x: mButton.anchorX - hoverXOffset}, .3, {ease: FlxEase.circOut});
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		
		var mButton:MovingButton = cast button;
		
		if (mButton.currentTween != null)
		{
			mButton.currentTween.cancel();
		}
		mButton.currentTween = FlxTween.tween(button, {x: mButton.anchorX}, .3, {ease: FlxEase.circOut});
	}
	
	override public function mActivate(button:ActiveButton):Void
	{
		var mButton:MovingButton = cast button;
		
		mButton.anchorX -= activeXOffset;
		hoverXOffset -= activeXOffset;
	}
	
	override public function mDeactivate(button:ActiveButton):Void
	{
		var mButton:MovingButton = cast button;
		
		mButton.anchorX += activeXOffset;
		hoverXOffset += activeXOffset;
		if (mButton.currentTween != null)
		{
			mButton.currentTween.cancel();
		}
		mButton.currentTween = FlxTween.tween(mButton, {x: mButton.anchorX}, .3, {ease: FlxEase.circOut});
	}
}