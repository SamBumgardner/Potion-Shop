package utilities;

import utilities.Event;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	
	public function new() 
	{
		observers = new Array<Observer>;
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