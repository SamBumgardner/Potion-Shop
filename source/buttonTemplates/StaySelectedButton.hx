package buttonTemplates;
import utilities.ButtonEvent.ButtonTypes;
import utilities.ButtonEvent.EventData;
import utilities.Subject;

/**
 * Template class for buttons that become "selected" when
 * clicked and remain selected until deactivated by another
 * object, probably the thing that created it.
 * @author Samuel Bumgardner
 */
class StaySelectedButton extends ActiveButton
{
	public var sub:Subject = new Subject(0, ButtonTypes.NO_TYPE);

	public function new(?X:Float=0, ?Y:Float=0, ?type:Int, ?defaultGraphicsInit:Bool=true, ?beginActive:Bool) 
	{
		sub.setType(type);
		super(X, Y, defaultGraphicsInit, beginActive);
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