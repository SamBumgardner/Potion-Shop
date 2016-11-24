package utilities;

/**
 * @author Samuel Bumgardner
 */
typedef ButtonEvent = Int;

@:enum
class EventData 
{
	public static var NO_EVENT(default, never) = -1;
	public static var OUT(default, never)      = 0;
	public static var OVER(default, never)     = 1;
	public static var DOWN(default, never)     = 2;
	public static var UP(default, never)       = 3;
}

@:enum
class ButtonTypes 
{
	public static var NO_TYPE(default, never)       = -1;
	public static var BUTTON(default, never)        = 0;
	public static var TAB(default, never)           = 1;
	public static var ING_HEX(default, never)       = 2;
	public static var SELECT_HEX(default, never)    = 3;
	public static var CAULDRON(default, never)      = 4;
	public static var ACTIVATE_BREW(default, never) = 5;
	public static var LOCK(default, never)      = 6;
	public static var NEXT_PHASE(default, never)    = 7;
	public static var SELL(default, never)          = 8;
	public static var WAIT(default, never)          = 9;
	public static var CANCEL(default, never)        = 10;
	public static var CUSTOMER(default, never)      = 11;
}