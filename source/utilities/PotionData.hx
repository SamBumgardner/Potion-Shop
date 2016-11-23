package utilities;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Class for translating an array of color values into
 * a potion. Holds variables about the potion until they
 * are replaced, so can be used to hold display text after
 * finishing translations.
 * @author Samuel Bumgardner
 */
class PotionData
{
	public var name:String;
	public var colorByIndex:Int;
	public var activeEffects:Array<Array<Int>>;
	public var description:String;
	
	public function new() 
	{
		name = "Tasteless clear potion";
		description = "";
		colorByIndex = -1;
		initActiveEffects();
	}
	
	private function initActiveEffects()
	{
		var numOfColors = 8;
		var numOfEffects = 4;
		
		activeEffects = new Array<Array<Int>>();
		
		for (i in 0...numOfColors)
		{
			activeEffects.push(new Array<Int>());
			for (j in 0...numOfEffects)
			{
				activeEffects[i].push(0);
			}
		}
	}
	
	public function updatePotion(colorValues:Array<Int>)
	{   // It's a bit inefficient to do these two functions separately,
		// but the number of iterations is small enough that it shouldn't
		// matter.
		updateActiveEffects(colorValues);
		updateText();
	}
	
	private function updateActiveEffects(colorValues:Array<Int>)
	{
		var numOfColors = 8;
		var numOfEffects = 4;
		var effectPrices = [10, 5, 3, 1];
		var colorValuesCopy = 0;
		
		activeEffects = new Array<Array<Int>>();
		
		for (i in 0...numOfColors)
		{
			activeEffects.push(new Array<Int>());
			colorValuesCopy = colorValues[i];
			for (j in 0...numOfEffects)
			{
				activeEffects[i][j] = 0;
				while (effectPrices[j] <= colorValuesCopy)
				{ // The colorValue is big enough to "purchase" the effect.
					colorValuesCopy -= effectPrices[j];
					activeEffects[i][j] += 1;
				}
			}
		}
	}
	
	private function updateText()
	{
		var intensity:String = "Tasteless";
		var dominantColor:String = "clear";
		var maxIntensity = 0;
		var maxColorIndex = -1;
		var thisColorIntesity = 0;
		
		var effectPrices = [10, 5, 3, 1];
		var possibleIntensities = ["Tasteless", "Weak", "", "Ordinary", "Flavorful", "", "Hearty", 
		                           "", "Extra-strength", "Intense", "Overpowering", "", ""];
		var colorConverter = new ColorConverter();
		
		description = "";
		
		for (i in 0...activeEffects.length)
		{
			thisColorIntesity = 0;
			for (j in 0...activeEffects[0].length)
			{
				if (activeEffects[i][j] > 0)
				{
					thisColorIntesity += effectPrices[j] * activeEffects[i][j];
					
					description += colorConverter.intToColorStr[i] + " " + Std.string(4 - j); //placeholder.
					if (activeEffects[i][j] > 1)
					{
						description += "++";
					}
					description += "\n";
				}
			}
			if (thisColorIntesity > maxIntensity)
			{
				maxIntensity = thisColorIntesity;
				maxColorIndex = i;
			}
		}
		
		if (maxColorIndex != -1)
		{
			dominantColor = colorConverter.intToColorStr[maxColorIndex];
			do 
			{
				intensity = possibleIntensities[maxIntensity];
				maxIntensity--;
			} 
			while (intensity == "");
		}
		
		colorByIndex = maxColorIndex;
		name = intensity + " " + dominantColor + " potion";
	}
}