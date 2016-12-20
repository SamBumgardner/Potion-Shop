package utilities;

/**
 * Simple class for holding data about one of the BrewState's
 * cauldrons. The Ingredient table switches between displaying
 * one cauldron's info and another's using these variables.
 * @author Samuel Bumgardner
 */
class CauldronData
{
	public var selectedIDs:Array<Int>;
	public var numSelected:Int;
	public var isLocked:Bool;
	
	public function new() 
	{
		numSelected = 0;
		selectedIDs = new Array<Int>();
		
		var maxSelected = 4;
		for (i in 0...maxSelected)
		{
			selectedIDs.push( -1);
		}
	}
	
	public function resetData()
	{
		numSelected = 0;
		isLocked = false;
		
		for (i in 0...selectedIDs.length)
		{
			selectedIDs[i] = -1;
		}
	}
}