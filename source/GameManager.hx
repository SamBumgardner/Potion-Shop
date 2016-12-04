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
}