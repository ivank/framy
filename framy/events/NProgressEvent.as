package framy.events {
	import flash.events.Event;

	/**
	* This is a ProgressEvent - like event, but rather than show the bytesLoaded/bytesTotal, 
	* it shows the normalized value of the process progress
	* i.e. 0.7 is 70% completion (this is usefull, when you don't know the actual totalBytes)
	* @author Default
	* @version 0.1
	*/
	public class NProgressEvent extends Event {
		public var progress:Number
		
		public function NProgressEvent(type:String, progress:Number) {
			super(type)
			this.progress = progress
		}
	}
	
}
