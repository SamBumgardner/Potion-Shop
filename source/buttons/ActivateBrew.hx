package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import utilities.ButtonEvent.ButtonTypes;
import utilities.ButtonEvent.EventData;
import utilities.Subject;

/**
 * Button used to lock in a potion for brewing.
 * @author Samuel Bumgardner
 */
class ActivateBrew extends ActiveButton
{
	public var sub:Subject = new Subject(0, ButtonTypes.ACTIVATE_BREW); 
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.BrewButton__png;
		bWidth = 120;
		bHeight = 500;
		
		super(X, Y);
	}
	
	public override function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
	}
	
	public override function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
	}
	
	public override function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		sub.notify(EventData.UP);
	}
}