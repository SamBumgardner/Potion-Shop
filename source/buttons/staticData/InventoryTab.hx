package buttons.staticData;

import buttons.Tab;
import utilities.ShopButtonGroup;

/**
 * Data needed to instantiate an "open inventory" tab.
 * 
 * @author Samuel Bumgardner
 */
class InventoryTab extends Tab
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		image = AssetPaths.InventoryStateButton__png;
		
		buttonGroup = Inventory;
		
		super(X, Y, beginActive);
	}
}