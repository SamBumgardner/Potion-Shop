package buttons;

import buttons.Button;

/**
 * Extends Buttons for any that need different active/inactive behavior
 * Experimented with a different documentation style in this file,
 * since it's probably one of the most heavily used classes in this game.
 * 
 * @author Samuel Bumgardner
 */
class ActiveButton extends Button
{
	
	/**
	 * Boolean flag that tracks whether this button is "active" or not.
	 * Up to the button implementer how to use this, exactly.
	 */
	public var isActive:Bool = false;
	
	/**
	 * @param	X             The initial X position of the button.
	 * @param	Y             The initial Y position of the button.
	 * @param	beginActive   Determines the button's starting state.
	 */
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		super(X, Y);
		
		if (beginActive)
		{
			ActiveButton.activate(this);
		}
	}
	
	/**
	 * Internal function that executes when the button is activated.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	private function mActivate(aButton:ActiveButton):Void{}
	
	/**
	 * Internal function that executes when the button is deactivated.
	 * @param	button	The instance of button that was acted upon by the mouse.
	 */
	private function mDeactivate(aButton:ActiveButton):Void{}
	
	/**
	 * Function that "activates" the button. 
	 * The logic of what this does is pretty much all on the button function class.
	 * @param	button	The instance of button that was activated.
	 */
	public static function activate(button:ActiveButton):Void
	{
		if (!button.isActive)
		{
			button.isActive = true;
			button.mActivate(button);
		}
	}
	
	/**
	 * Function that "deactivates" the button. 
	 * The logic of what this does is pretty much all on the button function class.
	 * @param	button	The instance of button that was deactivated.
	 */
	public static function deactivate(button:ActiveButton):Void
	{
		if (button.isActive)
		{
			button.isActive = false;
			button.mDeactivate(button);
		}
	}
}