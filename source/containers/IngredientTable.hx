package containers;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttons.IngredientHex;
import buttons.IngredientLock;
import buttons.LockCover;
import buttons.SelectedHex;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import graphicObjects.DisplaySprite;
import haxe.Json;
import sys.io.File;
import utilities.ButtonEvent;
import utilities.ButtonEvent.EventData;
import utilities.CauldronInfo;
import utilities.ColorArray;
import utilities.ColorConverter;
import utilities.ColorEnum;
import utilities.EventExtender;
import utilities.IngredientData;
import utilities.Observer;
import utilities.PotionData;

using utilities.EventExtender;

/**
 * The table that responds to events happenning to different IngredientHexes.
 * @author Samuel Bumgardner
 */
class IngredientTable extends AdvancedSprite implements Observer
{
	
	///////////////////////////////////////////
	//          DATA INITIALIZATION          //
	///////////////////////////////////////////
	
	private var totalGrp:FlxGroup;
	
	private var newEvents:Array<ButtonEvent>;
	private var eventCallbacks:Array<Array<Int->Void>>;
	
	private static var emptyIng:IngredientData;
	private var ingInfo:Array<IngredientData>;
	
	private var currCaulID:Int = 0;
	private var currCauldron:CauldronInfo;
	private var cauldronArray:Array<CauldronInfo>;
	private var selectedHexArray:Array<SelectedHex>;
	private var maxSelected:Int = 4;
	private var lockButton:IngredientLock;
	
	private var potionInfo:PotionData;
	private var potionImage:DisplaySprite;
	
	private var ingName:String;
	private var ingDescription:String;
	private var ingImage:DisplaySprite;
	
	private var currName:String;
	private var currDescription:String;
	private var displayName:FlxText;
	private var displayNameCenterX:Int = 1005;
	private var displayDescription:FlxText;
	private var displaySelectedImages:Array<DisplaySprite>;
	private var potionOn:Bool = false;
	private var potionOff:Bool = false;
	private var usePotionText:Bool = true;
	
	private var displayNormHover:ColorArray;
	private var displayNormSelected:ColorArray;
	private var displayBlendedHover:ColorArray;
	private var displayBlendedSelected:ColorArray;
	private var displayHoverBars:Array<FlxBar>;
	private var displaySelectedBars:Array<FlxBar>;
	private var displayBarTexts:Array<FlxText>;
	private var useBlended:Bool = false;
	private var colorsChanged:Bool = false;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, AssetPaths.IngredientTable__png);
		
		totalGrp = new FlxGroup();
		totalGrp.add(this);
		
		initEventSystem();
		initIngInfo();
		initIngredientButtons();
		initSelectedButtons();
		initCauldronData();
		initDisplayComponents();
		initLockButtons();
		
		potionInfo = new PotionData(); // Didn't seem to fit in any init function.
	}
	
	private function initEventSystem():Void
	{
		var numOfEventTypes = 4; // see EventData enum
		var numOfButtonTypes = 8; // see ButtonTypes enum
		
		newEvents = new Array<ButtonEvent>();
		for (i in 0...numOfEventTypes)
		{
			newEvents.push(ButtonTypes.NO_TYPE);
		}
		
		eventCallbacks = new Array<Array<ButtonEvent->Void>>();
		for (i in 0...numOfEventTypes)
		{
			eventCallbacks.push(new Array<Int->Void>());
			for (j in 0...numOfButtonTypes)
			{
				eventCallbacks[i].push(null);
			}
		}
		
		eventCallbacks[EventData.OUT][ButtonTypes.ING_HEX] = ingHexOut;
		eventCallbacks[EventData.OUT][ButtonTypes.SELECT_HEX] = selectHexOut;
		
		eventCallbacks[EventData.OVER][ButtonTypes.ING_HEX] = ingHexOver;
		eventCallbacks[EventData.OVER][ButtonTypes.SELECT_HEX] = selectHexOver;
		
		eventCallbacks[EventData.DOWN][ButtonTypes.ING_HEX] = ingHexDown;
		eventCallbacks[EventData.DOWN][ButtonTypes.SELECT_HEX] = selectHexDown;
		
		eventCallbacks[EventData.UP][ButtonTypes.ING_HEX] = ingHexUp;
		eventCallbacks[EventData.UP][ButtonTypes.SELECT_HEX] = selectHexUp;
		
		eventCallbacks[EventData.UP][ButtonTypes.LOCK] = lockButtonUp;
	}
	
	private function initIngInfo():Void
	{
		emptyIng = new IngredientData("", [0, 0, 0, 0, 0, 0, 0, 0], 0, "");
		
		ingInfo = new Array<IngredientData>();
		
		var fileHandle = File.read(AssetPaths.IngredientData__txt);
		
		for (i in 0...28)
		{
			var anonIng = Json.parse(fileHandle.readLine());
			var ingredient = new IngredientData(anonIng.name, anonIng.colorValues, 
			                                    anonIng.price, anonIng.description);
			ingInfo.push(ingredient);
		}
		
		fileHandle.close();
	}
	
	private function initIngredientButtons():Void
	{
		var ingHexArray = new Array<IngredientHex>();
		var displayIngImages = new Array<DisplaySprite>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var ingredientHexWidth = 145;
		var ingredientHexHeight = 125;
		
		var numRows = 8;
		var evenCols = 3;
		var oddCols = 4;
		
		var XIntervalMod = 1.56;
		var YIntervalMod = .545;
		
		var topLeftX = x + 12;
		var topLeftY = y + 12;
		
		var evenXOffset = ingredientHexWidth * .78;
		
		var XInterval = ingredientHexWidth * XIntervalMod;
		var YInterval = ingredientHexHeight * YIntervalMod;
		
		var locX = 0;
		var locY = 0;
		
		for (row in 0...numRows)
		{
			for (col in 0...oddCols)
			{
				if (row % 2 == 0)
				{
					if (col >= evenCols)
					{
						break;
					}
					// Need to cast Float to Int
					locX = cast (topLeftX + evenXOffset + col * XInterval);
					locY = cast (topLeftY + row * YInterval);
				}
				else
				{
					locX = cast (topLeftX + col * XInterval);
					locY = cast (topLeftY + row * YInterval);
				}
				ingHexArray.push(new IngredientHex(locX, locY));
				displayIngImages.push(new DisplaySprite(locX, locY, 
				                      AssetPaths.IngredientSpriteSheet__png,
				                      145, 125, 1, 3));
			}
		}
		
		//This is a bit (prob. insignificantly) inefficient, but it's more readable.
		for (i in 0...ingHexArray.length)
		{
			ingHexArray[i].sub.setID(i);
			ingHexArray[i].sub.addObserver(this);
			totalGrp.add(ingHexArray[i]);
			displayIngImages[i].animation.play(Std.string(i % 2 + 1));
			totalGrp.add(displayIngImages[i]);
		}
	}
	
	private function initSelectedButtons():Void
	{
		selectedHexArray = new Array<SelectedHex>();
		displaySelectedImages = new Array<DisplaySprite>();
		
		//Look at using some preprocessor stuff to do this instead (if possible:
		var selectedHexWidth = 135;
		var ingredientHexHeight = 155;
		
		var numRows = 2;
		var numCols = 2;
		
		var XIntervalMod = 1.1;
		var YIntervalMod = .8;
		
		var topLeftX = x + 845;
		var topLeftY = y + 12;
		
		var rowXOffset = -selectedHexWidth * .55;
		
		var XInterval = selectedHexWidth * XIntervalMod;
		var YInterval = ingredientHexHeight * YIntervalMod;
		
		for (row in 0...numRows)
		{
			for (col in 0...numCols)
			{
				var selHex = new SelectedHex(topLeftX + col * XInterval - row * rowXOffset, 
											 topLeftY + row * YInterval);
				selHex.sub.setID(row * numCols + col);
				selHex.sub.addObserver(this);
				
				selectedHexArray.push(selHex);
				totalGrp.add(selHex);
				
				displaySelectedImages.push(new DisplaySprite(selHex.x, selHex.y, 
				                           AssetPaths.IngredientSpriteSheet__png,
				                           145, 125, 1, 3));
				
				totalGrp.add(displaySelectedImages[row * numCols + col]); //FIX this
			}
		}
	}
	
	private function initCauldronData():Void
	{
		var numCauldrons:Int = 4;
		cauldronArray = new Array<CauldronInfo>();
		for (i in 0...numCauldrons)
		{
			cauldronArray.push(new CauldronInfo());
		}
		currCauldron = cauldronArray[currCaulID];
	}
	
	private function initDisplayBars():Void
	{
		var barInitialX = 1226;
		var barInitialY = 55;
		var barOffsetX = 33;
		
		var barWidth = 20;
		var barHeight = 156;
		
		var barUnits = 12;
		
		displayNormHover = new ColorArray();
		displayNormSelected = new ColorArray();
		displayBlendedHover = new ColorArray();
		displayBlendedSelected = new ColorArray();
		
		displayHoverBars = new Array<FlxBar>();
		displaySelectedBars = new Array<FlxBar>();
		
		displayBarTexts = new Array<FlxText>();
		
		var colorConvert = new ColorConverter();
		
		for (i in 0...displayNormHover.array.length)
		{
			displaySelectedBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                  y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                  barHeight, displayNormSelected, 
											  colorConvert.intToColorStr[i], 0, barUnits));
			displayHoverBars.push(new FlxBar(x + barInitialX + barOffsetX * i, 
			                                 y + barInitialY, BOTTOM_TO_TOP, barWidth, 
			                                 barHeight, displayNormHover, 
											 colorConvert.intToColorStr[i], 0, barUnits));
			displayBarTexts.push(new FlxText(x + barInitialX + barOffsetX * i, 
			                                  y + barInitialY + barHeight + 40, 0, "0", 20));
			
			displaySelectedBars[i].createFilledBar(0, colorConvert.intToColorHex[i] - 0x88000000);
			displaySelectedBars[i].numDivisions = barUnits;
			
			displayHoverBars[i].createFilledBar(0, colorConvert.intToColorHex[i] - 0x88000000);
			displayHoverBars[i].numDivisions = barUnits;
			
			displayBarTexts[i].color = FlxColor.BLACK;
			
			totalGrp.add(displaySelectedBars[i]);
			totalGrp.add(displayHoverBars[i]);
			totalGrp.add(displayBarTexts[i]);
		}
	}
	
	private function initDisplayComponents():Void
	{
		ingName = IngredientTable.emptyIng.name;
		ingDescription = IngredientTable.emptyIng.description;
		
		displayName = new FlxText(x + displayNameCenterX, y + 545, 240, "", 20);
		displayName.set_color(FlxColor.BLACK);
		totalGrp.add(displayName);
		displayName.alignment = FlxTextAlign.CENTER;
		
		displayDescription = new FlxText(x + 1150, y + 335, 300, "", 24);
		displayDescription.set_color(FlxColor.BLACK);
		totalGrp.add(displayDescription);
		
		initDisplayBars();
		
		ingImage = new DisplaySprite(x + 900, y + 340, 
		               AssetPaths.IngredientSpriteSheet__png,
		               145, 125, 1, 3);
					   
		potionImage = new DisplaySprite(x + 900, y + 340, 
		               AssetPaths.PotionSpriteSheet__png,
		               145, 125, 2, 5);
		
		//TEMPORARY LINE, REMOVE LATER
		potionImage.animation.play("0");
		
		totalGrp.add(ingImage);
		totalGrp.add(potionImage);
	}
	
	private function initLockButtons():Void
	{
		lockButton = new IngredientLock(x, y);
		lockButton.sub.addObserver(this);
		totalGrp.add(lockButton.getTotalFlxGrp());
	}
	
	///////////////////////////////////////////
	//           PUBLIC INTERFACE            //
	///////////////////////////////////////////
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	public function switchCurrCauldron(caulID:Int):Void
	{
		cauldronArray[currCaulID] = currCauldron;
		currCauldron = cauldronArray[caulID];
		currCaulID = caulID;
		updateSelectedImages();
		for (i in 0...maxSelected)
		{
			if (i < currCauldron.numSelected)
			{
				ActiveButton.activate(selectedHexArray[i]);
			}
			else
			{
				ActiveButton.deactivate(selectedHexArray[i]);
			}
		}
		hardUpdateBars();
		
		if (currCauldron.isLocked)
		{
			ActiveButton.activate(lockButton);
		}
		else
		{
			ActiveButton.deactivate(lockButton);
		}
	}
	
	public function lockCurrCauldron():Void
	{
		currCauldron.isLocked = true;
		ActiveButton.activate(lockButton);
	}
	
	
	///////////////////////////////////////////
	//  POTION DATA  MANIPULATION FUNCTIONS  //
	///////////////////////////////////////////
	
	private function clearHoverInfo():Void
	{
		updateIngDisplayText(IngredientTable.emptyIng);
		ingImage.animation.play("0");
		increaseHoverBars(IngredientTable.emptyIng);
	}
	
	private function updateIngDisplayText(ingredient:IngredientData):Void
	{
		ingName = ingredient.name;
		ingDescription = ingredient.description;
	}
	
	private function setBarTracking(newFadedParent:ColorArray, newSolidParent:ColorArray):Void
	{
		var colorConvert = new ColorConverter();
		for (i in 0...displayHoverBars.length)
		{
			displayHoverBars[i].setParent(newFadedParent, colorConvert.intToColorStr[i]);
			displaySelectedBars[i].setParent(newSolidParent, colorConvert.intToColorStr[i]);
		}
	}
	
	private function increaseHoverBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayNormHover.array.length)
		{
			displayNormHover.array[i] = displayNormSelected.array[i] + ingredient.colorValues[i];
		}
		colorsChanged = true;
	}
	
	private function decreaseHoverBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayNormHover.array.length)
		{
			displayNormHover.array[i] = displayNormSelected.array[i] - ingredient.colorValues[i];
		}
		colorsChanged = true;
	}
	
	private function increaseSelectedColors(ingredient:IngredientData):Void
	{
		for (i in 0...displayNormSelected.array.length)
		{
			displayNormSelected.array[i] += ingredient.colorValues[i];
		}
		colorsChanged = true;
	}
	
	private function decreaseSelectedBars(ingredient:IngredientData):Void
	{
		for (i in 0...displayNormSelected.array.length)
		{
			displayNormSelected.array[i] -= ingredient.colorValues[i];
		}
		colorsChanged = true;
	}
	
	private function hardUpdateBars():Void
	{
		displayNormHover.reset();
		displayNormSelected.reset();
		
		for (i in 0...currCauldron.numSelected)
		{
			var ingredient = ingInfo[currCauldron.selectedIDs[i]];
			increaseSelectedColors(ingredient);
		}
		increaseHoverBars(IngredientTable.emptyIng);
	}
	
	private function updateSelectedImages():Void
	{
		for (i in 0...currCauldron.selectedIDs.length)
		{	
			if (currCauldron.selectedIDs[i] != -1)
			{
				displaySelectedImages[i].animation.play(Std.string(currCauldron.selectedIDs[i] % 2 + 1)); //placeholder animation index
			}
			else
			{
				displaySelectedImages[i].animation.play("0");
			}
		}
	}
	
	
	///////////////////////////////////////////
	//         SWITCH DISPLAY MODES          //
	///////////////////////////////////////////
	
	private function blendModeOn()
	{
		useBlended = true;
		setBarTracking(displayBlendedHover, displayBlendedSelected);
	}
	
	private function blendModeOff()
	{
		useBlended = false;
		setBarTracking(displayNormHover, displayNormSelected);
	}
	
	private function potionDisplayOn()
	{
		AdvancedSprite.Hide(ingImage);
		AdvancedSprite.Reveal(potionImage);
		usePotionText = true;
	}
	
	private function potionDisplayOff()
	{
		AdvancedSprite.Hide(potionImage);
		AdvancedSprite.Reveal(ingImage);
		usePotionText = false;
	}
	
	///////////////////////////////////////////
	//         INGREDIENT HEX HOVER          //
	///////////////////////////////////////////
	
	private function setIngHoverInfo(ingIndex:Int):Void
	{
		var ingredient = ingInfo[ingIndex];
		
		updateIngDisplayText(ingredient);
		ingImage.animation.play(Std.string(ingIndex % 2 + 1));
		if (currCauldron.numSelected < maxSelected)
		{
			increaseHoverBars(ingredient);
		}
	}
	
	///////////////////////////////////////////
	//         INGREDIENT HEX CLICK          //
	///////////////////////////////////////////
	
	private function selectIngredient(ingIndex:Int):Void
	{
		if (currCauldron.numSelected < maxSelected)
		{
			currCauldron.selectedIDs[currCauldron.numSelected] = ingIndex;
			ActiveButton.activate(selectedHexArray[currCauldron.numSelected]);
			currCauldron.numSelected++;
			
			var ingredient = ingInfo[ingIndex];
			
			increaseSelectedColors(ingredient);
			if (currCauldron.numSelected < maxSelected)
			{
				increaseHoverBars(ingredient);
			}
			updateSelectedImages();
		}
		else
		{
			//Give some indication that there is no room.
		}
	}
	
	///////////////////////////////////////////
	//            SELECT HEX CLICK           //
	///////////////////////////////////////////
	
	private function deselectIngredient(selectIndex:Int):Void
	{
		var ingredient = ingInfo[currCauldron.selectedIDs[selectIndex]];
		
		currCauldron.selectedIDs.splice(selectIndex, 1);
		currCauldron.selectedIDs.push(-1);
		currCauldron.numSelected--;
		ActiveButton.deactivate(selectedHexArray[currCauldron.numSelected]);
		
		decreaseSelectedBars(ingredient);
		clearHoverInfo();
		updateSelectedImages();
	}
	
	///////////////////////////////////////////
	//            SELECT HEX HOVER           //
	///////////////////////////////////////////
	
	private function setSelectHoverInfo(selectIndex:Int):Void
	{
		var ingredient = ingInfo[currCauldron.selectedIDs[selectIndex]];
		
		updateIngDisplayText(ingredient);
		
		decreaseHoverBars(ingredient);
		ingImage.animation.play(Std.string(currCauldron.selectedIDs[selectIndex] % 2 + 1));
	}
	
	///////////////////////////////////////////
	//        INGREDIENT HEX CALLBACKS       //
	///////////////////////////////////////////
	
	private function ingHexOut(id:ButtonEvent):Void
	{
		clearHoverInfo();
	}
	
	private function ingHexOver(id:ButtonEvent):Void
	{
		setIngHoverInfo(id);
	}
	
	private function ingHexDown(id:ButtonEvent):Void
	{
		//Do whatever happens when the mouse is pressed over an ingredient button.
		// Probably nothing, but it's nice to have in the array of notfiy callbacks.
	}

	private function ingHexUp(id:ButtonEvent):Void
	{
		selectIngredient(id);
	}
	
	
	///////////////////////////////////////////
	//          SELECT HEX CALLBACKS         //
	///////////////////////////////////////////
	
	private function selectHexOut(id:Int):Void
	{
		clearHoverInfo();
	}
	
	private function selectHexOver(id:Int):Void
	{
		setSelectHoverInfo(id);
	}
	
	private function selectHexDown(id:ButtonEvent):Void
	{
		//Do whatever happens when the mouse is pressed over an ingredient button.
		// Probably nothing, but it's nice to have in the array of notfiy callbacks.
	}

	private function selectHexUp(id:ButtonEvent):Void
	{
		deselectIngredient(id);
		if (currCauldron.numSelected > id)
		{
			selectHexOver(id);
		}
	}
	
	
	///////////////////////////////////////////
	//         LOCK BUTTON CALLBACKS         //
	///////////////////////////////////////////
	
	private function lockButtonUp(id:ButtonEvent):Void
	{
		currCauldron.isLocked = false;
		ActiveButton.deactivate(lockButton);
	}
	
	
	///////////////////////////////////////////
	//          ORIGIN OF CALLBACKS          //
	///////////////////////////////////////////
	
	public function onNotify(event:ButtonEvent):Void
	{
		newEvents[event.getData()] = event;
	}
	
	
	///////////////////////////////////////////
	//                UPDATE                 //
	///////////////////////////////////////////
	
	private function updateDisplayText():Void
	{
		if (usePotionText)
		{
			currName = potionInfo.name;
			currDescription = potionInfo.description;
		}
		else
		{
			currName = ingName;
			currDescription = ingDescription;
		}
		displayDescription.text = currDescription;
		displayName.text = currName;
		displayName.x = x + displayNameCenterX - displayName.width / 2;
	}
	
	private function updateBarTexts(SelectedColorArray:ColorArray, HoverColorArray:ColorArray):Void
	{
		for (i in 0...displayBarTexts.length)
		{
			displayBarTexts[i].text = Std.string(HoverColorArray.array[i]);
			if (HoverColorArray.array[i] > SelectedColorArray.array[i])
			{
				displayBarTexts[i].color = FlxColor.GREEN - 0x00333333;
			}
			else if (HoverColorArray.array[i] < SelectedColorArray.array[i])
			{
				displayBarTexts[i].color = FlxColor.RED - 0x00333333;
			}
			else
			{
				displayBarTexts[i].color = FlxColor.BLACK; 
			}
		}
	}
	
	private function updatePotionData():Void
	{
		// Copy unblended arrays
		displayBlendedSelected.array = displayNormSelected.array.concat([]);
		displayBlendedHover.array = displayNormHover.array.concat([]);
		
		// Used ColorEnum to map the colors to indexes.
		displayBlendedSelected.blendColors([ColorEnum.R, ColorEnum.Y, ColorEnum.B], ColorEnum.K);
		displayBlendedSelected.blendColors([ColorEnum.R, ColorEnum.Y], ColorEnum.O);
		displayBlendedSelected.blendColors([ColorEnum.Y, ColorEnum.B], ColorEnum.G);
		displayBlendedSelected.blendColors([ColorEnum.B, ColorEnum.R], ColorEnum.P);
		displayBlendedSelected.blendColors([ColorEnum.O, ColorEnum.G, ColorEnum.P], ColorEnum.W);
		
		displayBlendedHover.blendColors([ColorEnum.R, ColorEnum.Y, ColorEnum.B], ColorEnum.K);
		displayBlendedHover.blendColors([ColorEnum.R, ColorEnum.Y], ColorEnum.O);
		displayBlendedHover.blendColors([ColorEnum.Y, ColorEnum.B], ColorEnum.G);
		displayBlendedHover.blendColors([ColorEnum.B, ColorEnum.R], ColorEnum.P);
		displayBlendedHover.blendColors([ColorEnum.O, ColorEnum.G, ColorEnum.P], ColorEnum.W);
		
		potionInfo.updatePotion(displayBlendedHover.array);
		potionImage.animation.play(Std.string(potionInfo.colorByIndex + 1));
	}
	
	override public function update(elapsed:Float):Void 
	{
		// Respond to mouse events
		for (eventData in 0...newEvents.length)
		{
			if (newEvents[eventData].getType() != ButtonTypes.NO_TYPE)
			{
				var event = newEvents[eventData];
				eventCallbacks[eventData][event.getType()](event.getID());
				newEvents[eventData] = ButtonTypes.NO_TYPE;
			}
		}
		
		// Update blended color values.
		if (colorsChanged)
		{
			updatePotionData();
			colorsChanged = false;
		}
		
		// Determine if norm/alt display should be presented.
		if (FlxG.keys.justPressed.ALT)
		{
			blendModeOn();
			potionOn = true;
		}
		else if (useBlended && !FlxG.keys.pressed.ALT)
		{
			blendModeOff();
		}
		
		if (usePotionText && !FlxG.keys.pressed.ALT && ingName != IngredientTable.emptyIng.name)
		{
			potionOff = true;
		}
		else if (!usePotionText && ingName == IngredientTable.emptyIng.name)
		{
			potionOn = true;
		}
		
		// Set display to norm/alt mode.
		if (potionOn)
		{
			potionDisplayOn();
			potionOn = false;
		}
		else if (potionOff)
		{
			potionDisplayOff();
			potionOff = false;
		}
		
		// Update display.
		updateDisplayText();
		
		// Update color number text.
		if (useBlended)
		{
			updateBarTexts(displayBlendedSelected, displayBlendedHover);
		}
		else
		{
			updateBarTexts(displayNormSelected, displayNormHover);
		}
		
		super.update(elapsed);
	}
}