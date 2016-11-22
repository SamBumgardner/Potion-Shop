package buttonTemplates;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Sets default animation and functions behavior
 * Experimented with a different documentation style in this file,
 * since it's probably one of the most heavily used classes in this game.
 * 
 * @author Samuel Bumgardner
 */
class Button extends Hideable
{
	
	private var image:FlxGraphicAsset;
	private var bWidth:Int;
	private var bHeight:Int;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?defaultGraphicsInit:Bool = true)
	{
		super(X, Y);
		
		if (defaultGraphicsInit)
		{
			loadGraphic(image, true, bWidth, bHeight);
			animation.add("Normal", [0], 1, false);
			animation.add("Hover", [1], 1, false);
			animation.add("Pressed", [2], 1, false);
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
		FlxMouseEventManager.add(button, button.mouseDown, button.mouseUp, 
		                         button.mouseOver, button.mouseOut);
	}
	
	/**
	 * Function used to temporarily un-register and hide a button. Used in tandem
	 * with Button.reveal() to temporarily remove & add buttons to the play area.
	 * 
	 * @param	button	The instance of button that should be re-registered.
	 */
	override public function hide():Void
	{
		FlxMouseEventManager.remove(this);
		super.hide();
	}
	
	/**
	 * Function used to register and reveal a button. Used in tandem
	 * with Button.hide() to temporarily remove & add buttons to the play area.
	 * 
	 * @param	button	The instance of button that should be re-registered.
	 */
	override public function reveal():Void
	{
		Button.register(this);
		super.reveal();
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public function mouseUp(button):Void
	{
		animation.play("Hover");
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public function mouseDown(button:Button):Void
	{
		animation.play("Pressed");
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public function mouseOver(button:Button):Void
	{
		animation.play("Hover");
		
		if (FlxG.mouse.pressed)
		{ 
			mouseDown(button);
		}
	}
	
	/**
	 * Callback function registered to the FlxMouseEventManager.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	public function mouseOut(button:Button):Void
	{
		animation.play("Normal");
	}
}