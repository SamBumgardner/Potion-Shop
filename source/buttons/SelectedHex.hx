package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import utilities.ButtonEvent.ButtonTypes;
import utilities.ButtonEvent.EventData;
import utilities.Subject;

/**
 * Button used to represent a selected ingredient in IngredientTable
 * @author Samuel Bumgardner
 */
class SelectedHex extends ActiveButton
{
	public var sub:Subject = new Subject(0, ButtonTypes.SELECT_HEX);

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		image = AssetPaths.SelectedHex__png;
		bWidth = 135;
		bHeight = 155;
		
		super(X, Y, false);
	}
	
	override public function mouseOver(button:Button):Void
	{
		if (isActive)
		{
			super.mouseOver(button);
			sub.notify(EventData.OVER);
		}
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		if (isActive)
		{
			sub.notify(EventData.OUT);
		}
	}
	
	override public function mouseDown(button:Button):Void
	{
		if (isActive)
		{
			super.mouseDown(button);
			sub.notify(EventData.DOWN);
		}
	}
	
	override public function mouseUp(button:Button):Void
	{
		if (isActive)
		{
			super.mouseUp(button);
			sub.notify(EventData.UP);
		}
	}
	
	override public function mDeactivate():Void
	{
		this.mouseOut(this);
	}
}