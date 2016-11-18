package utilities;
import flixel.util.FlxColor;

/**
 * Handly little class that can be used to convert Ints to
 * their corresponding colors in the game.
 * @author Samuel Bumgardner
 */
class ColorConverter
{

	public var intToColorStr:Array<String>;
	public var intToColorHex:Array<Int>;
	
	public function new()
	{
		intToColorStr = ["red", "orange", "yellow", "green", 
						 "blue", "purple", "black", "white"];
		intToColorHex = [FlxColor.RED, FlxColor.ORANGE, FlxColor.YELLOW, FlxColor.GREEN,
						 FlxColor.BLUE, FlxColor.PURPLE, FlxColor.BLACK, FlxColor.WHITE];	
	}
}