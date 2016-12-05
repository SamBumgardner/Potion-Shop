package buttons;

import buttonTemplates.Button;
import buttonTemplates.StaySelectedButton;
import flixel.system.FlxAssets.FlxGraphicAsset;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Button used to represent a potion in the inventory.
 * @author Samuel Bumgardner
 */

class InvPotionButton extends StaySelectedButton
{		
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.InventoryPotionButton__png;
		bWidth = 125;
		bHeight = 145;
		
		super(X, Y, ButtonTypes.POTION_INV);
	}
	
	override public function mouseOver(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOver(button);
			sub.notify(EventData.OVER);
		}
	}
	
	override public function mouseOut(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOut(button);
			sub.notify(EventData.OUT);
		}
	}
	
	/**
	 * Special logic needed for buttons that may need to not react to 
	 * mouse events, but are already using active/inactive logic for 
	 * something else.
	 * 
	 * This leaves it up to whatever is managing the button to decide
	 * whether to re-enable this button in the mouse event manager when
	 * this button is revealed.
	 */
	override public function reveal():Void
	{
		set_visible(true);
		set_active(true);
	}
}