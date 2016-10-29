package buttons;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Sets default animation and functions behavior
 * 
 * @author Samuel Bumgardner
 */
class Button extends FlxSprite
{
	/**
	 * Read-only: Function that will be called when the left mouse button is released while
	 * over this button. Should only be used internally. 
	 */
	private var MUp:Button->Void;
	
	/**
	 * Read-only: Function that will be called when the left mouse button is pressed while
	 * over this button. Should only be used internally. 
	 */
	private var MDown:Button->Void;
	
	/**
	 * Read-only: Function that will be called when the mouse enters this button's area.
	 * Should only be used internally. 
	 */
	private var MOver:Button->Void;
	
	/**
	 * Read-only: Function that will be called when the mouse leaves this button's area.
	 * Should only be used internally. 
	 */
	private var MOut:Button->Void;
	
	/**
	 * The original X position of this button.
	 * Used by tweening/animating buttons so they have an unchanging point of reference.
	 */
	public var anchorX:Float;
	
	/**
	 * The original Y position of this button.
	 * Used by  tweening/animating buttons so they have an unchanging point of reference.
	 */
	public var anchorY:Float;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 * @param	buttonClass   The class that contains the static variables and functions 
	 *                        the button should use - e.g. Button(500, 450, Simple)
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, buttonClass)
	{
		super(X, Y);
		
		loadGraphic(buttonClass.image, true, buttonClass.frameWidth, buttonClass.frameHeight);
		animation.add("Normal", [0], 1, false);
		animation.add("Hover", [1], 1, false);
		animation.add("Pressed", [2], 1, false);
		
		anchorX = X;
		anchorY = Y;
		
		MUp   = buttonClass.mouseUp;
		MDown = buttonClass.mouseDown;
		MOver = buttonClass.mouseOver;
		MOut  = buttonClass.mouseOut;
		
		Button.register(this);
	}
	
	/**
	 * Callback function used to re-register all buttons inside a particular FlxGroup.
	 * Useful when returning to a main state after activating a substate.
	 * @param	button	The instance of button that should be re-registered.
	 */
	public static function register(button:Button):Void
	{
		FlxMouseEventManager.add(button, Button.MouseDown, Button.MouseUp, 
		                         Button.MouseOver, Button.MouseOut);
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseUp(button:Button):Void
	{
		button.animation.play("Hover");
		button.MUp(button);
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseDown(button:Button):Void
	{
		button.animation.play("Pressed");
		button.MDown(button);
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseOver(button:Button):Void
	{
		button.animation.play("Hover");
		button.MOver(button);
		
		if (FlxG.mouse.pressed)
		{ 
			Button.MouseDown(button);
		}
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseOut(button:Button):Void
	{
		button.animation.play("Normal");
		button.MOut(button);
	}
}