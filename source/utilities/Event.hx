package utilities;

/**
 * @author Samuel Bumgardner
 */
typedef Event = Int;

// Assumes that IDs in range from 0 - 255;
// Assumes that data in range from 0 - 255;

class EventExtender 
{
	static public function setID(event:Event, id:Int):Event
	{
		return (event & 0xFFFFFF00) | id;
	}
	
	static public function returnID(event:Event):Int
	{
		return event & 0x000000FF;
	}
	
	static public function setData(event:Int, data:Int):Event
	{
		return (event & 0x000000FF) | (data << 8);
	}
	
	static public function returnData(event:Event):Int
	{
		return event >> 8;
	}
}