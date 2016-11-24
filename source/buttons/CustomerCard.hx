package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.CustomerDetails;
import utilities.ButtonEvent;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Container-Button that holds a customer's data and
 * responds to different gameplay situations.
 * 
 * @author Samuel Bumgardner
 */
class CustomerCard extends ActiveButton implements Observer
{
	public var sub:Subject = new Subject(0, ButtonTypes.CUSTOMER);
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.CustomerCard__png;
		bWidth = 600;
		bHeight = 225;
		
		super(X, Y);
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