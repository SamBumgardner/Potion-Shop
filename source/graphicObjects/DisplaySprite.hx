package graphicObjects;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class DisplaySprite extends AdvancedSprite
{

	public function new(?X:Float = 0, ?Y:Float = 0, spriteSheet:FlxGraphicAsset, 
	                    fWidth:Int, fHeight:Int, rows:Int, columns:Int) 
	{
		super(X, Y);
		
		loadGraphic(spriteSheet, true, fWidth, fHeight);
		
		for (i in 0...(rows * columns))
		{
			animation.add(Std.string(i), [i], 1, false);
		}
	}
	
}