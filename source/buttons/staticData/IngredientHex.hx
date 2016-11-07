package buttons.staticData;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Data needed to instantiate an "ingredient hexagon" Button.
 * This class's fields should only be accessed from within the Button class. 
 * @author Samuel Bumgardner
 */

class IngredientHex extends Button
{	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.HexButton__png;
		bWidth = 145;
		bHeight = 125;
		
		super(X, Y);
	}
}