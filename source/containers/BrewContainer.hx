package containers;
import buttonTemplates.ActiveButton;
import buttonTemplates.SimpleObservableButton;
import buttons.Cauldron;
import flixel.group.FlxGroup;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Observer;

using utilities.EventExtender;

/**
 * Container for all components of the brew state, including
 * IngredientTable (and its contents)
 * Cauldron(s) and
 * ActivateBrew
 * @author Samuel Bumgardner
 */

class BrewContainer implements Observer
{
	private var totalGrp:FlxGroup;
	private var ingTable:IngredientTable;
	private var cauldronArray:Array<Cauldron>;
	
	public function new() 
	{
		totalGrp = new FlxGroup();
		
		initIngTable();
		initCauldronButtons();
		initActivateBrewButton();
	}
	
	private function initIngTable():Void
	{
		ingTable = new IngredientTable(60, 370);
		totalGrp.add(ingTable.getTotalFlxGrp());
	}
	
	private function initCauldronButtons():Void
	{
		cauldronArray = new Array<Cauldron>();
		
		var topLeftX = 600;
		var topLeftY = 145;
		var cauldronWidth = 175;
		var xSpaceBetween = 15;
		var xInterval = cauldronWidth + xSpaceBetween;
		var numOfCauldrons = 4;
		
		for (i in 0...numOfCauldrons)
		{
			var newCaul = new Cauldron(topLeftX + xInterval * i, topLeftY);
			newCaul.sub.setID(i);
			newCaul.sub.addObserver(this);
			
			if (i == 0)
			{
				ActiveButton.activate(newCaul);
			}
			
			cauldronArray.push(newCaul);
			totalGrp.add(newCaul);
		}
	}
	
	private function initActivateBrewButton():Void
	{
		var topLeftX = 1630;
		var topLeftY = 430;
		
		var newActivateBrew = new SimpleObservableButton(topLeftX, topLeftY,
		                                                 ButtonTypes.ACTIVATE_BREW, true,
		                                                 AssetPaths.BrewButton__png, 120,
		                                                 500);
		newActivateBrew.sub.addObserver(this);
		totalGrp.add(newActivateBrew);
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
				case ButtonTypes.CAULDRON: cauldronClicked(event);
				case ButtonTypes.ACTIVATE_BREW: activateBrewClicked();
			}
		}
	}
	
	private function switchActiveCauldron(cauldron:Cauldron):Void
	{
		for (caul in cauldronArray)
		{
			ActiveButton.deactivate(caul);
		}
		ActiveButton.activate(cauldron);
	}
	
	private function cauldronClicked(event:ButtonEvent):Void
	{
		switchActiveCauldron(cauldronArray[event.getID()]);
		ingTable.switchCurrCauldron(event.getID());
	}
	
	private function activateBrewClicked():Void
	{
		ingTable.lockCurrCauldron();
	}
}