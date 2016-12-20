package;

import containers.CustContainer;
import flash.system.System;
import flixel.FlxG;
import flixel.FlxSubState;
import states.OptionsMenu;
import states.ShopState;
import utilities.PotionData;

/**
 * Object responsible for managing data about the game as a whole.
 * Also responsible for saving/loading data and switching between scenes.
 * 
 * Should addthis to the set of FlxG plugins.
 * 
 * @author Samuel Bumgardner
 */
class GameManager
{
	private static var maleCustomerNames:Array<String>;
	private static var femaleCustomerNames:Array<String>;
	private static var alreadyPickedNames:Array<Array<Int>>;
	public static var potionDataArray:Array<PotionData>;
	public static var currentMoney:Int;
	
	public function new(){}
	
	public static function startNewGame():Void
	{
		potionDataArray = new Array<PotionData>();
		
		var numOfPotions = FlxG.random.int(0, 27);
		
		for (i in 0...numOfPotions)
		{
			addPotionToInventory(generateRandomPotion(4));
		}
		
		currentMoney = 0;
		
		FlxG.switchState(new ShopState());
	}
	
	public static function startLoadGame():Void
	{
		//Need to do extra steps to load data.
		FlxG.switchState(new ShopState());
	}
	
	public static function quitGame():Void
	{
		System.exit(0);
	}
	
	public static function loadCustomerNames():Void
	{
		var linesPerFile:Int = 50;
		
		maleCustomerNames = new Array<String>();
		femaleCustomerNames = new Array<String>();
		
		var fileHandle = File.read(AssetPaths.MaleCustomerNames__txt);
		for (i in 0...linesPerFile)
		{
			maleCustomerNames.push(fileHandle.readLine());
		}
		fileHandle.close();
		
		fileHandle = File.read(AssetPaths.FemaleCustomerNames__txt);
		for (i in 0...linesPerFile)
		{
			femaleCustomerNames.push(fileHandle.readLine());
		}
		fileHandle.close();
	}
	
	public static function addPotionToInventory(newPotion:PotionData):Void
	{
		potionDataArray.push(newPotion);
	}
	
	public static function generateRandomPotion(maxIntensity:Int):PotionData
	{
		var newColorArray:Array<Int> = new Array<Int>();
		for (j in 0...8)
		{
			for (k in 0...4)
			{
				newColorArray.push(FlxG.random.int(0, maxIntensity));
			}
		}
		return new PotionData(newColorArray);
	}
	
	public static function generateRandomCustomer():CustomerData
	{
		var linesPerFile:Int = 50;
		var custName:String = "";
		
		if (FlxG.random.bool())
		{
			var randomSelection = FlxG.random.int(0, linesPerFile - 1, GameManager.alreadyPickedNames[0]);
			custName = maleCustomerNames[randomSelection];
			GameManager.alreadyPickedNames[0].push(randomSelection);
			
		}
		else
		{
			var randomSelection = FlxG.random.int(0, linesPerFile - 1, GameManager.alreadyPickedNames[1]);
			custName = femaleCustomerNames[randomSelection];
			GameManager.alreadyPickedNames[1].push(randomSelection);
		}
		
		var custPicIndex:Int = FlxG.random.int(0, 2);
		
		//Can definitely generate potions that aren't creatable.
		// Address in future changes.
		var custPotionValues:Array<Int> = [0, 0, 0, 0, 0, 0, 0, 0];
		
		var bigColorIndex:Int = FlxG.random.int(0, 7);
		var medColorIndex:Int = FlxG.random.int(0, 7, [bigColorIndex]);
		var smallColorIndex:Int = FlxG.random.int(0, 7, [bigColorIndex, medColorIndex]);
		
		var bigColorValue:Int = FlxG.random.int(1, 10);
		var medColorValue:Int = FlxG.random.int(0, cast Math.min(10 - bigColorValue, 3));
		var smallColorValue:Int = FlxG.random.int(0, cast Math.min(10 - medColorValue, 3));
		
		custPotionValues[bigColorIndex] = bigColorValue;
		custPotionValues[medColorIndex] = medColorValue;
		custPotionValues[smallColorIndex] = smallColorValue;
		
		var totalColorValue:Int = bigColorValue + medColorValue + smallColorValue;
		return new CustomerData(custName, custPicIndex, custPotionValues, FlxG.random.int(totalColorValue * 15, totalColorValue * 25)); 
	}
	
	public static function resetSelectedNames():Void
	{
		alreadyPickedNames[0] = new Array<Int>();
		alreadyPickedNames[1] = new Array<Int>();
	}
	
	public static function saleSucceeded(objectOfOrigin:CustContainer):Void
	{
		//Do whatever happens when sale succeeded.
		currentMoney += objectOfOrigin.saleSucceeded();
	}
}