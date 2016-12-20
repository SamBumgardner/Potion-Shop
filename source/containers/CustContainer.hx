package containers;
import buttonTemplates.ActiveButton;
import buttonTemplates.SimpleObservableButton;
import buttons.CustomerCard;
import buttons.CustomerLock;
import buttons.NextPhaseButton;
import flixel.FlxG;
import flixel.group.FlxGroup;
import states.MakeSaleSubstate;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Observer;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Container for all components of the customer state, including
 * customer cards
 * Sell, Wait, and Cancel buttons (for customers) and
 * Next Phase button
 * @author Samuel Bumgardner
 */
class CustContainer implements Observer
{
	private var totalGrp:FlxGroup = new FlxGroup();
	private var custArray:Array<CustomerCard>;
	private var currCustID:Int = -1;
	private var sellButton:SimpleObservableButton;
	public var sub:Subject = new Subject(0, ButtonTypes.NEXT_PHASE);
	
	public function new() 
	{
		initCustCards();
		initAuxButtons();
	}
	
	private function initCustCards():Void
	{
		custArray = new Array<CustomerCard>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var customerCardWidth = 600;
		var customerCardHeight = 225;
		
		var numOfVisibleCards = 6;
		var numCols = 2;
		
		var topLeftX = 390;
		var topLeftY = 140;
		var XInterval = customerCardWidth + 60;
		var YInterval = customerCardHeight + 40;
		
		for (row in 0...(cast numOfVisibleCards / numCols))
		{
			for (col in 0...numCols)
			{
				custArray.push(new CustomerCard(topLeftX + col * XInterval, topLeftY + row * YInterval));
				custArray[row * numCols + col].sub.addObserver(this);
				custArray[row * numCols + col].sub.setID(row * numCols + col);
				
				totalGrp.add(custArray[row * numCols + col].getTotalFlxGrp());
			}
		}
		
		moveOnCustomers();
	}
	
	private function initAuxButtons():Void
	{
		var startX = 420;
		var startY = 915;
		var xInterval = 450;
		
		sellButton = new SimpleObservableButton(420, 915, ButtonTypes.SELL, true,
		                                            AssetPaths.SellButton__png, 300, 150);
		sellButton.sub.addObserver(this);
		totalGrp.add(sellButton);
		
		var waitButton = new SimpleObservableButton(420 + xInterval, 915, ButtonTypes.WAIT, 
		                                            true, AssetPaths.WaitButton__png, 300, 150);
		waitButton.sub.addObserver(this);
		totalGrp.add(waitButton);
		
		var cancelButton = new SimpleObservableButton(420 + xInterval * 2, 915, 
		                                              ButtonTypes.CANCEL, true,
		                                              AssetPaths.CancelButton__png, 300, 150);
		cancelButton.sub.addObserver(this);
		totalGrp.add(cancelButton);
		
		var nextPhase = new NextPhaseButton(1720, 980);
		nextPhase.sub.addObserver(this);
		totalGrp.add(nextPhase);
	}
	
	private function moveOnCustomers():Void
	{
		var numOfVisibleCards = 6;
		var numCols = 2;
		
		GameManager.resetSelectedNames();
		for (row in 0...(cast numOfVisibleCards / numCols))
		{
			for (col in 0...numCols)
			{
				if (custArray[row * numCols + col].lockButton.lockType != LockTypes.WAIT)
				{
					custArray[row * numCols + col].changeCustomerData(GameManager.generateRandomCustomer());
				}
			}
		}
	}
	
	public function saleSucceeded():Int
	{
		custArray[currCustID].lockCustomer(LockTypes.SOLD);
		ActiveButton.deactivate(custArray[currCustID]);
		var moneyEarned = custArray[currCustID].customerInfo.pay; // should match what customer was willing to pay.
		currCustID = -1;
		
		return moneyEarned;
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	public function onNotify(event:ButtonEvent):Void
	{
		if (event.getData() == EventData.UP)
		{
			switch(event.getType())
			{
				case ButtonTypes.CUSTOMER: customerClicked(event);
				case ButtonTypes.SELL: sellClicked(event);
				case ButtonTypes.WAIT: waitClicked(event);
				case ButtonTypes.CANCEL: cancelClicked(event);
				case ButtonTypes.NEXT_PHASE: nextPhaseClicked(event);
			}
		}
	}
	
	private function customerClicked(event:ButtonEvent):Void
	{
		switchActiveCustomer(custArray[event.getID()]);
		currCustID = event.getID();
	}
	
	private function switchActiveCustomer(customer:CustomerCard):Void
	{
		for (cust in custArray)
		{
			ActiveButton.deactivate(cust);
		}
		ActiveButton.activate(customer);
	}
	
	private function sellClicked(event:ButtonEvent):Void
	{
		if (currCustID != -1)
		{
			(cast FlxG.state).activateSubstate(sellButton, MakeSaleSubstate, [this]);
		}
	}
	
	private function waitClicked(event:ButtonEvent):Void
	{
		if (currCustID != -1)
		{
			custArray[currCustID].lockCustomer(LockTypes.WAIT);
			ActiveButton.deactivate(custArray[currCustID]);
			currCustID = -1;
		}
	}
	
	private function cancelClicked(event:ButtonEvent):Void
	{
		if (currCustID != -1)
		{
			custArray[currCustID].lockCustomer(LockTypes.CANCEL);
			ActiveButton.deactivate(custArray[currCustID]);
			currCustID = -1;
		}
	}
	
	private function nextPhaseClicked(event:ButtonEvent):Void
	{	// Passes the event notification up, since the state is 
		//   responsible for moving on to the next part of the day.
		sub.notify(EventData.UP);
	}
}