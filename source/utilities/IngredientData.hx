package utilities;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Simple struct-like class for holding data about an ingredient.
 * @author Samuel Bumgardner
 */
class IngredientData
{

	public var colorValues:Array<Int>;
	public var price:Int;
	public var description:String;
	public var graphic:FlxGraphicAsset;
	
	public function new(cVal:Array<Int>, pr:Int, desc:String, img:FlxGraphicAsset) 
	{
		colorValues = cVal;
		price = pr;
		description = desc;
		graphic = img;
	}
	
}