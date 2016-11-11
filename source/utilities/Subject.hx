package utilities;

import utilities.Event;

/**
 * ...
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<observers>;
	
	public function new() 
	{
		observers = new Array<observers>;
	}
	
	public function addObserver(obs:Observer):Void
	{
		observers.push(obs);
	}
	
	public function removeObserver(obs:Observer):Void
	{
		observers.remove(obs);
	}
	
	public function notify(event:Event):Void
	{
		for (obs in observers)
		{
			obs.onNotify(event);
		}
	}
}