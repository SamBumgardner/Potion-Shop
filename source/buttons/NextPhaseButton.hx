package buttons;

import buttonTemplates.Button;
import buttonTemplates.MovingButton;
import utilities.ButtonEvent;
import utilities.Subject;

/**
 * Button in ShopState used to advanced to the next
 * block of time, afternoon/evening/next morning.
 * @author Samuel Bumgardner
 */
class NextPhaseButton extends MovingButton
{
	public var sub:Subject = new Subject(0, ButtonTypes.NEXT_PHASE);
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		image = AssetPaths.NextPhaseButton__png;
		bWidth = 230;
		bHeight = 130;
		
		OffsetX = -25;
		OffsetY = -25;
		
		super(X, Y, true, false);
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
		moveToOffset();
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		moveToAnchor();
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		
		if (!isActive)
		{
			sub.notify(EventData.UP);
		}
	}
}