package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;

/**
 * Proliferation of the LockCover-type solution.
 * It worked once, and it'll work again here.
 * @author Samuel Bumgardner
 */
class CustomerCover extends ActiveButton
{
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, false);
		
		image = AssetPaths.CustCover__png;
		bWidth = 600;
		bHeight = 225;
		
		loadGraphic(image, false, bWidth, bHeight);
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