package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import flixel.group.FlxGroup;
import utilities.ButtonEvent;
import utilities.Subject;

/**
 * Button that appears when CustomerCard is locked.
 * Largely copied from IngredientLock. If this is 
 * some sort of standard solution to problems, I
 * should probably make a buttonTemplate version
 * of the lock class for them both to inherit from.
 * @author Samuel Bumgardner
 */
class CustomerLock extends ActiveButton
{
	private var cover:CustomerCover;
	private var totalGrp:FlxGroup;
	public var lockType:Int;
	public var sub:Subject = new Subject(0, ButtonTypes.LOCK);
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X + 233, Y + 45, false);
		
		totalGrp = new FlxGroup();
		lockType = LockTypes.NONE;
		
		cover = new CustomerCover(X, Y);
		totalGrp.add(cover);
		totalGrp.add(this);
		
		image = AssetPaths.CustCoverLabel__png;
		bWidth = 144;
		bHeight = 150;
		
		loadGraphic(image, true, bWidth, bHeight);
		for (i in 0...3)
		{
			animation.add(Std.string(i), [i], 1, false);
		}
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	public function setLockType(lType:Int)
	{
		lockType = lType;
		if (lockType != LockTypes.NONE)
		{
			animation.play(Std.string(lockType));
		}
	}
	
	override public function mouseUp(button:Button):Void
	{
		if (lockType == LockTypes.WAIT)
		{
			sub.notify(EventData.UP);
		}
	}
	
	override public function mouseDown(button:Button):Void{}
	
	override public function mouseOver(button:Button):Void{}
	
	override public function mouseOut(button:Button):Void{}
	
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

@:enum 
class LockTypes
{
	public static var NONE  (default, never) = -1;
	public static var SOLD  (default, never) = 0;
	public static var WAIT  (default, never) = 1;
	public static var CANCEL(default, never) = 2;	
}