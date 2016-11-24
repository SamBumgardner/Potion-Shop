package buttonTemplates;

import buttonTemplates.Button;
import flixel.system.FlxAssets.FlxGraphicAsset;
import utilities.ButtonEvent.ButtonTypes;
import utilities.ButtonEvent.EventData;
import utilities.Subject;

/**
 * A very simple template for buttons that want
 * to emit an event upon mouseUp and not much else.
 * @author Samuel Bumgardner
 */
class SimpleObservableButton extends Button
{
	public var sub:Subject = new Subject(0, 0); 
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?type:Int = -1,
	                    ?InitFromParameters:Bool = false, ?img:FlxGraphicAsset,
						?frameWidth:Int, ?frameHeight:Int)
	{
		if (InitFromParameters)
		{
			image = img;
			bWidth = frameWidth;
			bHeight = frameHeight;
		}
		super(X, Y);
		sub.setType(type);
	}
	
	public override function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		sub.notify(EventData.UP);
	}
}