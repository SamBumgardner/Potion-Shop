package utilities;

import utilities.ButtonEvent;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	private var subjectID:Int;
	
	public function new(?setID:Int = 0) 
	{
		subjectID = setID;
		observers = new Array<Observer>();
	}
	
	public function getID():Int
	{
		return subjectID;
	}
	
	public function setID(newID:Int):Void
	{
		subjectID = newID;
	}
	
	public function addObserver(obs:Observer):Void
	{
		observers.push(obs);
	}
	
	public function removeObserver(obs:Observer):Void
	{
		observers.remove(obs);
	}
	
	public function notify(event:ButtonEvent):Void
	{
		for (obs in observers)
		{
			obs.onNotify(event);
		}
	}
}