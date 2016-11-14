package buttons;

import buttonTemplates.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Data needed to instantiate an "ingredient hexagon" Button.
 * This class's fields should only be accessed from within the Button class. 
 * @author Samuel Bumgardner
 */

@:tink class IngredientHex extends Button
{	
	@:forward var sub:Subject = new Subject(); //using tink_lang Syntactic Delegation.
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.HexButton__png;
		bWidth = 145;
		bHeight = 125;
		
		super(X, Y);
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
		notify(EventData.OVER);
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		notify(EventData.OUT);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		notify(EventData.UP);
	}
}