package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;

/**
 * Dumb solution to the locking-ingredientTable problem.
 * Mouse events are only detected by the top button, so this
 * cover is a button with no functionality that intercepts
 * all mouse events before they reach ingredient buttons.
 * @author Samuel Bumgardner
 */
class LockCover extends ActiveButton
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, false);
		
		image = AssetPaths.LockCover__png;
		bWidth = 1215;
		bHeight = 615;
		
		loadGraphic(image, false, 1215, 615);
	}
	
	override public function mouseUp(button):Void{}
	
	override public function mouseDown(button:Button):Void{}
	
	override public function mouseOver(button:Button):Void{}
	
	override public function mouseOut(button:Button):Void{}
	
	override public function reveal():Void
	{
		if (isActive)
		{
			super.reveal();
		}
	}
	
	override public function mActivate():Void
	{
		reveal();
	}
	
	override public function mDeactivate():Void
	{
		hide();
	}
}