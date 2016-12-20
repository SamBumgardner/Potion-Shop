package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttons.CustomerLock.LockTypes;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import graphicObjects.DisplaySprite;
import states.MakeSaleSubstate;
import utilities.ButtonEvent;
import utilities.CustomerData;
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
	public var lockButton:CustomerLock;
	private var totalGrp:FlxGroup = new FlxGroup();
	public var customerInfo:CustomerData;
	private var displayName:FlxText;
	private var displayRequest:FlxText;
	private var displayPrice:FlxText;
	private var displayFace:DisplaySprite;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ?initialCustData:CustomerData)
	{
		image = AssetPaths.CustomerCard__png;
		bWidth = 600;
		bHeight = 225;
		
		super(X, Y);
		
		totalGrp.add(this);
		
		initDisplayComponents(initialCustData);
		initLockButton();
	}
	
	private function initDisplayComponents(?initialCustData:CustomerData):Void
	{	
		var faceXOffset = 17;
		var faceYOffset = 17;
		
		displayFace = new DisplaySprite(x + faceXOffset, y + faceYOffset, 
		                  AssetPaths.CustomerSpriteSheet__png, 128, 128, 1, 3);
		displayFace.animation.play("0");
		totalGrp.add(displayFace);
		
		var textSize = 16;
		
		var nameXOffset = 20;
		var nameYOffset = 155;
		var nameWidth = 130;
		displayName = new FlxText(x + nameXOffset, y + nameYOffset, nameWidth, "Customer Name Here", textSize);
		displayName.color = FlxColor.BLACK;
		totalGrp.add(displayName);
		
		var requestXOffset = 170;
		var requestYOffset = 25;
		var requestWidth = 420;
		displayRequest = new FlxText(x + requestXOffset, y + requestYOffset, requestWidth, 
		                 "Big Request goes here...\nblah\nblah\nblah\nblah", textSize);
		displayRequest.color = FlxColor.BLACK;
		totalGrp.add(displayRequest);
		
		var priceXOffset = 170;
		var priceYOffset = 175;
		var priceWidth = 420;
		displayPrice = new FlxText(x + priceXOffset, y + priceYOffset, priceWidth,
		               "I'm willing to pay 1000000 dollars", textSize);
		displayPrice.color = FlxColor.BLACK;
		totalGrp.add(displayPrice);
		
		if (initialCustData == null)
		{
			initialCustData = new CustomerData("Customer Name Here", 0, [0, 0, 0, 0, 0, 0, 0, 0], 0);
		}
		changeCustomerData(initialCustData);
	}
	
	private function initLockButton():Void
	{
		lockButton = new CustomerLock(x, y);
		lockButton.sub.addObserver(this);
		lockButton.getTotalFlxGrp().forEach(AdvancedSprite.Hide, true);
		totalGrp.add(lockButton.getTotalFlxGrp());
	}
	
	public function changeCustomerData(newData:CustomerData):Void
	{
		displayFace.animation.play(Std.string(newData.graphicIndex));
		displayName.text = newData.name;
		displayRequest.text = newData.getRequestDescription();
		displayPrice.text = "and I'm willing to pay " + Std.string(newData.pay) + " dollars.";
		customerInfo = newData;
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