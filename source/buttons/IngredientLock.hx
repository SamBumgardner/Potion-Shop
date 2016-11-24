package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import flixel.group.FlxGroup;
import utilities.ButtonEvent;
import utilities.Subject;

/**
 * Button that appears when IngredientTable is locked,
 * can be clicked to unlock the table again. Is responsible
 * for keeping track of an instance of LockCover as well.
 * @author Samuel Bumgardner
 */
class IngredientLock extends ActiveButton
{
	private var cover:LockCover;
	private var totalGrp:FlxGroup;
	public var sub:Subject = new Subject(0, ButtonTypes.LOCK);
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		totalGrp = new FlxGroup();
		
		cover = new LockCover(X, Y);
		totalGrp.add(cover);
		totalGrp.add(this);
		
		image = AssetPaths.LockButton__png;
		bWidth = 190;
		bHeight = 225;
		
		super(X + 500, Y + 100);
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	override public function mouseUp(button:Button):Void
	{
		sub.notify(EventData.UP);
		super.mouseUp(button);
	}
	
	override public function mActivate():Void
	{
		ActiveButton.activate(cover);
		reveal();
	}
	
	override public function mDeactivate():Void
	{
		ActiveButton.deactivate(cover);
		mouseOut(this);
		hide();
	}
	
	override public function reveal():Void
	{
		if (isActive)
		{
			super.reveal();
		}
	}
}