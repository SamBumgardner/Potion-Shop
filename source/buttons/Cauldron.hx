package buttons;

import buttonTemplates.ActiveButton;
import buttonTemplates.Button;
import buttonTemplates.StaySelectedButton;
import utilities.ButtonEvent.ButtonTypes;

/**
 * Button that represents one of the player's brewing stations.
 * Clicking on it changes the currently active cauldron.
 * After being activated, it plays its hover animation until
 * it is no longer the active cauldron.
 * 
 * Should be reduced to a factory pattern-esque scenario in the
 * future.
 * @author Samuel Bumgardner
 */
class Cauldron extends StaySelectedButton
{
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.CauldronButton__png;
		bWidth = 175;
		bHeight = 175;
		
		super(X, Y, ButtonTypes.CAULDRON);
	}
}