package utilities;

/**
 * A class for holding details about a customer.
 * @author Samuel Bumgardner
 */
class CustomerData
{
	public var name:String;
	public var graphicIndex:Int;
	public var desiredPotion:PotionData;
	public var pay:Int;
	
	public function new(Name:String, GraphicIndex:Int, potionColVals:Array<Int>, Pay:Int)
	{
		name = Name;
		graphicIndex = GraphicIndex;
		desiredPotion = new PotionData(potionColVals);
		pay = Pay;
	}
	
	public function getRequestDescription():String
	{
		var colorConverter:ColorConverter = new ColorConverter();
		
		var wouldLikeA:String = "I would like a ";
		var color:String = "";
		if (desiredPotion.colorByIndex != -1)
		{
			color = colorConverter.intToColorStr[desiredPotion.colorByIndex]
							   .toLowerCase() + " ";
		}
		
		var potion:String = "potion with...\n";
		
		return wouldLikeA + color + potion + desiredPotion.description;
	}
	
	public function checkPotion(potion:PotionData):Bool
	{
		var isAcceptable:Bool = true;
		for (i in 0...desiredPotion.activeEffects.length)
		{
			for (j in 0...desiredPotion.activeEffects[i].length)
			{
				if (potion.activeEffects[i][j] < desiredPotion.activeEffects[i][j])
				{
					isAcceptable = false;
					break;
				}
			}
			if (!isAcceptable)
			{
				break;
			}
		}
		return isAcceptable;
	}
}