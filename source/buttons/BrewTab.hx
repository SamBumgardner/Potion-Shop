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
		
		super(X, Y, beginActive);
	}
}