package utilities;

/**
 * @author Samuel Bumgardner
 */
typedef ButtonEvent = Int;

@:enum
class EventData 
{
	public static var NO_EVENT = -1;
	public static var OUT = 0;
	public static var OVER = 1;
	public static var DOWN = 2;
	public static var UP = 3;
}

@:enum
class ButtonTypes 
{
	public static var NO_TYPE(default, never) = -1;
	public static var BUTTON(default, never) = 0;
	public static var TAB(default, never) = 1;
	public static var ING_HEX(default, never) = 2;
	public static var SELECT_HEX(default, never) = 3;
}