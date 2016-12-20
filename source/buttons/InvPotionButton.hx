package buttons;

import buttonTemplates.Button;
import buttonTemplates.GrayOutable;
import buttonTemplates.StaySelectedButton;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;
import graphicObjects.DisplaySprite;
import utilities.ButtonEvent;
import utilities.EventExtender;
import utilities.Subject;

using utilities.EventExtender;

/**
 * Button used to represent a potion in the inventory.
 * @author Samuel Bumgardner
 */

class InvPotionButton extends StaySelectedButton implements GrayOutable
{		
	public var isGrayedOut:Bool = false;
	private var totalFlxGrp:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	private var potionImg:DisplaySprite;
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		image = AssetPaths.InventoryPotionButton__png;
		bWidth = 125;
		bHeight = 145;
		
		super(X, Y, ButtonTypes.POTION_INV);
		
		totalFlxGrp.add(this);
		
		potionImg = new DisplaySprite(X, Y,
			                    AssetPaths.PotionSpriteSheet__png,
		                        125, 145, 3, 3);
		potionImg.animation.play("0");
		totalFlxGrp.add(potionImg);
	}
	
	public function getTotalFlxGrp():FlxTypedGroup<FlxSprite>
	{
		return totalFlxGrp;
	}
	
	public function changePotionImg(newPotionAnim:String):Void
	{
		potionImg.animation.play(newPotionAnim);
	}
	
	override public function mouseOver(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOver(button);
			sub.notify(EventData.OVER);
		}
	}
	
	override public function mouseOut(button:Button):Void
	{
		if (!isActive)
		{
			super.mouseOut(button);
			sub.notify(EventData.OUT);
		}
	}
	
	/**
	 * Special logic needed for buttons that may need to not react to 
	 * mouse events, but are already using active/inactive logic for 
	 * something else.
	 * 
	 * This leaves it up to whatever is managing the button to decide
	 * whether to re-enable this button in the mouse event manager when
	 * this button is revealed.
	 */
	override public function reveal():Void
	{
		set_visible(true);
		set_active(true);
		if (isGrayedOut)
		{
			FlxMouseEventManager.setObjectMouseEnabled(this, false);
		}
	}
	
	public function grayOut():Void
	{
		FlxMouseEventManager.setObjectMouseEnabled(this, false);
		totalFlxGrp.forEach(function(subObject:FlxSprite){ subObject.color = 0x999999; });
		isGrayedOut = true;
	}
	
	public function unGrayOut():Void
	{
		FlxMouseEventManager.setObjectMouseEnabled(this, true);
		color = 0xFFFFFF;
		isGrayedOut = false;
	}
}