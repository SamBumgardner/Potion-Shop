package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Button extends FlxSprite
{

	private var MDown:Void->Void;
	private var MUp:Void->Void;
	private var MOver:Void->Void;
	private var MOut:Void->Void;
	
	public function new(?X:Float = 0, ?Y:Float = 0, Graphic:FlxGraphicAsset, 
	                    FrameWidth:Int, FrameHeight:Int, OnMouseDown:Void->Void, 
						OnMouseUp:Void->Void, OnMouseOver:Void->Void, 
						OnMouseOut:Void->Void)
	{
		super(X, Y);
		
		loadGraphic(Graphic, true, FrameWidth, FrameHeight);
		animation.add("Normal", [0], 1, false);
		animation.add("Hover", [1], 1, false);
		animation.add("Pressed", [2], 1, false);
		
		MDown = OnMouseDown;
		MUp   = OnMouseUp;
		MOver = OnMouseOver;
		MOut  = OnMouseOut;
		
		FlxMouseEventManager.add(this, Button.MouseDown, Button.MouseUp, 
		                         Button.MouseOver, Button.MouseOut);
	}
	
	public static function MouseDown(button:Button):Void
	{
		button.animation.play("Pressed");
		button.MDown();
	}
	
	public static function MouseUp(button:Button):Void
	{
		button.animation.play("Hover");
		button.MUp();
	}
	
	public static function MouseOver(button:Button):Void
	{
		button.animation.play("Hover");
		button.MOver();
		
		if (FlxG.mouse.pressed)
		{ 
			Button.MouseDown(button);
		}
	}
	
	public static function MouseOut(button:Button):Void
	{
		button.animation.play("Normal");
		button.MOut();
	}
}