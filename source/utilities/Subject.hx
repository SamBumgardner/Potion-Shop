package utilities;

import utilities.ButtonEvent;
import utilities.EventExtender;

using utilities.EventExtender;

/**
 * Basic class for subjects in the Observer design pattern.
 * @author Samuel Bumgardner
 */
class Subject
{
	private var observers:Array<Observer>;
	private var subjectID:Int;
	private var subjectType:Int;
	
	public function new(?setID:Int = 0, ?setType = 0) 
	{
		subjectID = setID;
		subjectType = setType;
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
	
	public function getType():Int
	{
		return subjectType;
	}
	
	public function setType(newType:Int):Void
	{
		subjectType = newType;
	}
	
	public function addObserver(obs:Observer):Void
	{
		observers.push(obs);
	}
	
	public function removeObserver(obs:Observer):Void
	{
		observers.remove(obs);
	}
	
	public function notify(eventData:Int):Void
	{
		var e:ButtonEvent = 0;
		
		for (obs in observers)
		{
			obs.onNotify(e.setID(subjectID).setType(subjectType).setData(eventData));
		}
	}
}