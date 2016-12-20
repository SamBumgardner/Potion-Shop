package buttons;

import buttonTemplates.Tab;
import utilities.ShopButtonGroup;

/**
 * Data needed to instantiate an "open brew" tab.
 * 
 * @author Samuel Bumgardner
 */
class BrewTab extends Tab
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		image = AssetPaths.BrewStateButton__png;
		
		buttonGroup = Brew;
		
		super(X, Y, false, beginActive);
		
		loadGraphic(image, true, bWidth, bHeight);
		animation.add("Normal", [0], 1, false);
		animation.add("Hover", [0,1,0,2], 5, true);
		animation.add("Pressed", [3], 1, false);
	}
}