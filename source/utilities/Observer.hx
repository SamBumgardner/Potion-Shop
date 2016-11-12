package utilities;

import utilities.ButtonEvent;

/**
 * Basic interface for observers in the Observer design patern.
 * @author Samuel Bumgardner
 */
interface Observer {
	public function onNotify(event:ButtonEvent):Void;
}