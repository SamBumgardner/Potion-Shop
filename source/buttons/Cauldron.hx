package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import utilities.ButtonEvent.ButtonTypes;
import utilities.ButtonEvent.EventData;
import utilities.Subject;

/**
 * Button that represents one of the player's brewing stations.
 * Clicking on it changes the currently active cauldron.
 * After being activated, it plays its hover animation until
 * it is no longer the active cauldron.
 * @author Samuel Bumgardner
 */
class Cauldron extends ActiveButton
{
	public var sub:Subject = new Subject(0, ButtonTypes.CAULDRON); 
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.CauldronButton__png;
		bWidth = 175;
		bHeight = 175;
		
		super(X, Y);
	}
	
	override public function mouseOver(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOver(button);
		}
	}
	
	override public function mouseOut(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOut(button);
		}
	}
	
	override public function mouseDown(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseDown(button);
		}
	}
	
	override public function mouseUp(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseUp(button);
			sub.notify(EventData.UP);
			ActiveButton.activate(this);
		}
	}
	
		
	override private function mActivate():Void 
	{
		animation.play("Hover");
	}
	
	override private function mDeactivate():Void 
	{
		animation.play("Normal");
	}
}