package buttons;

import buttonTemplates.Tab;
import utilities.ShopButtonGroup;

/**
 * Data needed to instantiate an "open customer" tab.
 * 
 * @author Samuel Bumgardner
 */
class CustomerTab extends Tab
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?beginActive:Bool)
	{
		image = AssetPaths.CustomerStateButton__png;
		
		buttonGroup = Customer;
		
		super(X, Y, beginActive);
	}
}