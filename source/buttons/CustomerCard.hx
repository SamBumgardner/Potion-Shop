package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttons.CustomerLock.LockTypes;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import states.CustomerDetails;
import utilities.ButtonEvent;
import utilities.Observer;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Container-Button that holds a customer's data and
 * responds to different gameplay situations.
 * 
 * @author Samuel Bumgardner
 */
class CustomerCard extends ActiveButton implements Observer
{
	public var sub:Subject = new Subject(0, ButtonTypes.CUSTOMER);
	private var lockButton:CustomerLock;
	private var totalGrp:FlxGroup = new FlxGroup();
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.CustomerCard__png;
		bWidth = 600;
		bHeight = 225;
		
		super(X, Y);
		
		totalGrp.add(this);
		
		initLockButton();
	}
	
	private function initLockButton():Void
	{
		lockButton = new CustomerLock(x, y);
		lockButton.sub.addObserver(this);
		lockButton.getTotalFlxGrp().forEach(AdvancedSprite.Hide, true);
		totalGrp.add(lockButton.getTotalFlxGrp());
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	public function lockCustomer(lockType:Int):Void
	{
		lockButton.setLockType(lockType);
		ActiveButton.activate(lockButton);
	}
	
	public function unlockCustomer():Void
	{
		lockButton.setLockType(LockTypes.NONE);
		ActiveButton.deactivate(lockButton);
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		// lockButton is the only thing that should trigger this.
		if (event.getType() == ButtonTypes.LOCK)
		{
			unlockCustomer();
		}
	}
	
	override public function mouseOver(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOver(button);
		}
	}
	
	override public function mouseOut(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOut(button);
		}
	}
	
	override public function mouseDown(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseDown(button);
		}
	}
	
	override public function mouseUp(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseUp(button);
			sub.notify(EventData.UP);
		}
	}
	
	override private function mActivate():Void 
	{
		animation.play("Hover");
	}
	
	override private function mDeactivate():Void 
	{
		animation.play("Normal");
	}
	
	override public function advanceTimeReset():Void 
	{
		
		if (lockButton.lockType != LockTypes.WAIT)
		{
			unlockCustomer();
			//Also need to reduce customer satisfaction, or whatever
			//  happens when they have to wait.
		}
		else
		{
			unlockCustomer();
			//Also need to do whatever random generation that is needed
			//  to create the new customer data & variables.
		}
	}
}