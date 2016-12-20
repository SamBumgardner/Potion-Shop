package buttonTemplates;

/**
 * Interface that describes the set of functios all "GrayOutable"-implementing
 * classes should contian. Will be useful for checking if something can be greyed
 * out when iterating through a mixed list and other things of that nature.
 * @author Samuel Bumgardner
 */
interface GrayOutable 
{
	public var isGrayedOut:Bool;
	public function grayOut():Void;
	public function unGrayOut():Void;
}