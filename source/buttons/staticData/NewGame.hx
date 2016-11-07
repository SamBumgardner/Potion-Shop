package buttons.staticData;

import buttons.Button;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.ShopState;

/**
 * Data needed to instantiate a "new game" Button.
 * This class's fields should only be accessed from within the Button class. 
 * 
 * @author Samuel Bumgardner
 */
class NewGame extends Button
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.NewGameButton__png;
		bWidth = 500;
		bHeight = 100;
		
		super(X, Y);
	}

	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		GameManager.startNewGame();
	}
}