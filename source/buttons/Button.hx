package buttons;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;

/**
 * Sets default animation and functions behavior
 * Experimented with a different documentation style in this file,
 * since it's probably one of the most heavily used classes in this game.
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
	
	public var currentTween:FlxTween;
	
	/**
	 * Boolean flag that tracks whether this button is "active" or not.
	 * Up to the button implementer how to use this, exactly.
	 */
	public var isActive:Bool = false;
	
	/**
	 * Read-only: Function called when button is activated.
	 * Should only be used internally. 
	 */
	private var MActivate:Button->Void;
	
	/**
	 * Read-only: Function called when button is deactivated.
	 * Should only be used internally. 
	 */
	private var MDeactivate:Button->Void;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 * @param	buttonClass   The class that contains the static variables and functions 
	 *                        the button should use - e.g. Button(500, 450, Simple)
	 * @param	beginActive   Applies adjusted positioning and any other necessary changes
	 *       	              to the button so that it appears active upon instantiation.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, buttonClass, ?beginActive:Bool)
	{
		anchorX = X;
		anchorY = Y;
		
		if (beginActive)
		{
			X -= buttonClass.activeXOffset;
			Y -= buttonClass.activeYOffset;
		}
		
		super(X, Y);
		
		loadGraphic(buttonClass.image, true, buttonClass.frameWidth, buttonClass.frameHeight);
		animation.add("Normal", [0], 1, false);
		animation.add("Hover", [1], 1, false);
		animation.add("Pressed", [2], 1, false);
		
		MUp   = buttonClass.mouseUp;
		MDown = buttonClass.mouseDown;
		MOver = buttonClass.mouseOver;
		MOut  = buttonClass.mouseOut;
		
		MActivate   = buttonClass.activate;
		MDeactivate = buttonClass.deactivate;
		
		if (beginActive)
		{
			Button.activate(this);
		}
		
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
	 * Function used to temporarily un-register and hide a button. Used in tandem
	 * with Button.reveal() to temporarily remove & add buttons to the play area.
	 * 
	 * @param	button	The instance of button that should be re-registered.
	 */
	public static function hide(button:Button):Void
	{
		FlxMouseEventManager.remove(button);
		button.set_visible(false);
		button.set_active(false);
	}
	
	/**
	 * Function used to register and reveal a button. Used in tandem
	 * with Button.hide() to temporarily remove & add buttons to the play area.
	 * 
	 * @param	button	The instance of button that should be re-registered.
	 */
	public static function reveal(button:Button):Void
	{
		Button.register(button);
		button.set_visible(true);
		button.set_active(true);
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
	
	/**
	 * Function that "activates" the button. 
	 * The logic of what this does is pretty much all on the button function class.
	 * @param	button	The instance of button that was activated.
	 */
	public static function activate(button:Button):Void
	{
		if (!button.isActive)
		{
			button.isActive = true;
			button.MActivate(button);
		}
	}
	
	/**
	 * Function that "deactivates" the button. 
	 * The logic of what this does is pretty much all on the button function class.
	 * @param	button	The instance of button that was deactivated.
	 */
	public static function deactivate(button:Button):Void
	{
		if (button.isActive)
		{
			button.isActive = false;
			button.MDeactivate(button);
		}
	}
}