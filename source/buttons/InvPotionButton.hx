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
}