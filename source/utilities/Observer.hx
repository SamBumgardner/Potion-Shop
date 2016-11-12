package utilities;

import utilities.Event;

/**
 * Basic interface for observers in the Observer design patern.
 * @author Samuel Bumgardner
 */
interface Observer {
	public function onNotify(event:Event):Void;
}