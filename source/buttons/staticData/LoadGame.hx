package buttons.staticData;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Data needed to instantiate a "load game" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class LoadGame extends Button
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.LoadGameButton__png;
		bWidth = 500;
		bHeight = 100;
		
		super(X, Y);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		GameManager.startLoadGame();
	}
}