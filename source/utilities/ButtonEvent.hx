package utilities;

/**
 * @author Samuel Bumgardner
 */
typedef ButtonEvent = Int;

@:enum
class EventData {
	public static var OUT = 0;
	public static var OVER = 1;
	public static var DOWN = 2;
	public static var UP = 3;
}