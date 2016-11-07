package buttons.staticData;

import buttons.Button;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * An example Button-extending class.
 * 
 * @author Samuel Bumgardner
 */
class Simple extends Button
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.PlaceholderButton__png;
		bWidth = 500;
		bHeight = 100;
		
		super(X, Y);
	}

	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		trace("Mouse was released over a simple button.");
	}
	
	override public function mouseDown(button:Button):Void
	{
		super.mouseDown(button);
		trace("Mouse was pressed over a simple button.");
	}
	
	override public function mouseOver(button:Button):Void
	{
		super.mouseOver(button);
		trace("Mouse was moved over a simple button.");
	}
	
	override public function mouseOut(button:Button):Void
	{
		super.mouseOut(button);
		trace("Mouse was moved out of a simple button.");
	}
}