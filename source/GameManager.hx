package;

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
}