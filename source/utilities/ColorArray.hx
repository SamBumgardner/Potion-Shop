package utilities;

/**
 * A class that acts as a proxy for an Array so its fields can
 * be accessed via Haxe's Reflect API.
 * @author Samuel Bumgardner
 */
class ColorArray
{
	public var array:Array<Int>;
	
	public var red(get, null):Int;
	public var orange(get, null):Int;
	public var yellow(get, null):Int;
	public var green(get, null):Int;
	public var blue(get, null):Int;
	public var purple(get, null):Int;
	public var black(get, null):Int;
	public var white(get, null):Int;
	
	public function new()
	{
		array = [0, 0, 0, 0, 0, 0, 0, 0];
	}
	
	public function get_red():Int    { return array[0]; }
	
	public function get_orange():Int { return array[1]; }
	
	public function get_yellow():Int { return array[2]; }
	
	public function get_green():Int  { return array[3]; }
	
	public function get_blue():Int   { return array[4]; }
	
	public function get_purple():Int { return array[5]; }
	
	public function get_black():Int  { return array[6]; }
	
	public function get_white():Int  { return array[7]; }
}