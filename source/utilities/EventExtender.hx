package utilities;
import utilities.ButtonEvent.EventData;

/**
 * ...
 * @author Samuel Bumgardner
 */
 
// Assumes that IDs in range from 0 - 255;
// Assumes that data in range from 0 - 255;
 
class EventExtender 
{	
	static public function setID(event:ButtonEvent, id:Int):ButtonEvent
	{
		return (event & 0xFFFFFF00) | id;
	}
	
	static public function getID(event:ButtonEvent):Int
	{
		return event & 0x000000FF;
	}
	
	static public function setData(event:ButtonEvent, data:Int):ButtonEvent
	{
		return (event & 0x000000FF) | (data << 8);
	}
	
	static public function getData(event:ButtonEvent):Int
	{
		return event >> 8;
	}
}