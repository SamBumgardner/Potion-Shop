package containers;

import buttons.InvPotionButton;
import flixel.group.FlxGroup;
import graphicObjects.DisplaySprite;
import utilities.ButtonEvent;
import utilities.Observer;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Container for a row of potionButtons. 
 * When a potion in its row becomes selected, the row also changes
 * graphics. Also is responsible for passing events up to its 
 * container.
 * @author Samuel Bumgardner
 */
class PotionRow extends AdvancedSprite
{
	private var totalGrp:FlxGroup = new FlxGroup();
	private var potionButtonArray:Array<InvPotionButton> = new Array<InvPotionButton>();
	private var potionImagesArray:Array<DisplaySprite> = new Array <DisplaySprite>();
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.InventoryPotionRow__png, true, 1425, 160);
		animation.add("normal", [1], 1, false);
		animation.add("selected", [0], 1, false);
		animation.play("normal");
		
		totalGrp.add(this);
		initPotionButtons();
	}
	
	private function initPotionButtons():Void
	{
		var numOfPotionsInRow = 9;
		
		var topLeftX = 108;
		var topLeftY = 8;
		var xInterval = 125 + 10;
		
		var currPotionButton:InvPotionButton;
		var currPotionImg:DisplaySprite;
		
		for (i in 0...numOfPotionsInRow)
		{
			currPotionButton = new InvPotionButton(x + topLeftX + xInterval * i, y + topLeftY);
			potionButtonArray.push(currPotionButton);
			totalGrp.add(currPotionButton);
			
			currPotionImg = new DisplaySprite(x + topLeftX + xInterval * i, y + topLeftY,
			                    AssetPaths.PotionSpriteSheet__png,
		                        145, 125, 2, 5);
			currPotionImg.animation.play("0");
			potionImagesArray.push(currPotionImg);
			totalGrp.add(currPotionImg);
		}
	}
	
	public function getPotionButtonArray():Array<InvPotionButton>
	{
		return potionButtonArray;
	}
	
	public function getPotionImgArray():Array<DisplaySprite>
	{
		return potionImagesArray;
	}
	
	public function getTotalFlxGrp():FlxGroup
	{
		return totalGrp;
	}
	
	public function selected():Void
	{
		animation.play("selected");
	}
	
	public function unselected():Void
	{
		animation.play("normal");
	}
}