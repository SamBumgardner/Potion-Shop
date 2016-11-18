package buttons;

import buttonTemplates.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Button used to represent an ingredient.
 * @author Samuel Bumgardner
 */

class IngredientHex extends Button
{	
	public var sub:Subject = new Subject(0, ButtonTypes.ING_HEX); //using tink_lang Syntactic Delegation.
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.HexButton__png;
		bWidth = 145;
		bHeight = 125;
		
		super(X, Y);
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(this);
		sub.notify(EventData.OVER);
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		sub.notify(EventData.OUT);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		sub.notify(EventData.UP);
	}
}