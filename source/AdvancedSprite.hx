package;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class AdvancedSprite extends FlxSprite
{
	/**
	 * Function used to temporarily un-register and hide a hideable. Used in tandem
	 * with Hideable.reveal() to temporarily remove & add hideables to the play area.
	 * 
	 * @param	hideable	The instance of hideable that should be hidden.
	 */
	public function hide():Void
	{
		set_visible(false);
		set_active(false);
	}
	
	/**
	 * Function used to register and reveal a hideable. Used in tandem
	 * with Hideable.hide() to temporarily remove & add hideables to the play area.
	 * 
	 * @param	hideable	The instance of hideable that should be revealed.
	 */
	public function reveal():Void
	{
		set_visible(true);
		set_active(true);
	}
	
	public static function Hide(object:FlxBasic):Void
	{
		if (Std.is(object, AdvancedSprite))
		{
			(cast object).hide();
		}
		else if (Std.is(object, FlxSprite))
		{
			(cast object).set_visible(false);
			(cast object).set_active(false);
		}
	}
	
	public static function Reveal(object:FlxBasic)
	{
		if (Std.is(object, AdvancedSprite))
		{
			(cast object).reveal();
		}
		else if (Std.is(object, FlxSprite))
		{
			(cast object).set_visible(true);
			(cast object).set_active(true);
		}
	}
	
	/**
	 * Function used to reset any variables or call any functions necessary
	 *   to reset the AdvancedSprite for the next part of the day.
	 * Internal logic of the function is up to the child class, which should
	 *   override the function.
	 * Of course, objects that do not need to reset anything do not need to 
	 *   override this.
	 */
	public function advanceTimeReset():Void{}
	
	public static function AdvanceTimeReset(object:FlxBasic)
	{
		if (Std.is(object, AdvancedSprite))
		{
			(cast object).advanceTimeReset();
		}
	}
}