package utilities;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Simple struct-like class for holding data about an ingredient.
 * @author Samuel Bumgardner
 */
class IngredientData
{

	public var name:String;
	public var colorValues:Array<Int>;
	public var price:Int;
	public var description:String;
	public var graphic:FlxGraphicAsset;
	
	public function new(nm:String, cVal:Array<Int>, pr:Int, desc:String) 
	{
		name = nm;
		colorValues = cVal;
		price = pr;
		description = desc;
	}
	
}