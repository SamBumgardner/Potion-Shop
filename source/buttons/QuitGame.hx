package buttons;

import buttonTemplates.Button;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Button for quitting the game. 
 * 
 * @author Samuel Bumgardner
 */
class QuitGame extends Button
{	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.QuitButton__png;
		bWidth = 500;
		bHeight = 100;
		
		super(X, Y);
	}
	
	override public function mouseUp(button:Button):Void
	{
		super.mouseUp(button);
		GameManager.quitGame();
	}
}