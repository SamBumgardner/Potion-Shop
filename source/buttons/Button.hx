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
	private var MUp:Void->Void;
	
	/**
	 * Read-only: Function that will be called when the left mouse button is pressed while
	 * over this button. Should only be used internally. 
	 */
	private var MDown:Void->Void;
	
	/**
	 * Read-only: Function that will be called when the mouse enters this button's area.
	 * Should only be used internally. 
	 */
	private var MOver:Void->Void;
	
	/**
	 * Read-only: Function that will be called when the mouse leaves this button's area.
	 * Should only be used internally. 
	 */
	private var MOut:Void->Void;
	
	
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
		
		MUp   = buttonClass.mouseUp;
		MDown = buttonClass.mouseDown;
		MOver = buttonClass.mouseOver;
		MOut  = buttonClass.mouseOut;
		
		FlxMouseEventManager.add(this, Button.MouseDown, Button.MouseUp, 
		                         Button.MouseOver, Button.MouseOut);
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseUp(button:Button):Void
	{
		button.animation.play("Hover");
		button.MUp();
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseDown(button:Button):Void
	{
		button.animation.play("Pressed");
		button.MDown();
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public static function MouseOver(button:Button):Void
	{
		button.animation.play("Hover");
		button.MOver();
		
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
		button.MOut();
	}
}