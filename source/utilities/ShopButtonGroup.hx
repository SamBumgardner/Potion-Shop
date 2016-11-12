package utilities;

/**
 * Enum that serves as an intermediary between tab buttons (which need to specify which
 * button group should be activated) and ShopState.
 * @author Samuel Bumgardner
 */

 @:enum
abstract ShopButtonGroup(Int) 
{
	var Customer = 0;
	var Brew = 1;
	var Inventory = 2;
}