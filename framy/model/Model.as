package framy.model 
{
	import br.com.stimuli.loading.BulkLoader;
	import framy.errors.StaticClassError;
	
	/**
	 *  Dispatched on download progress by any of the items to download.
	 *
	 *  @eventType br.com.stimuli.loading.BulkProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="br.com.stimuli.loading.BulkProgressEvent")]

	/**
	 *  Dispatched when all items have been downloaded and parsed.
	 *
	 *  @eventType br.com.stimuli.loading.BulkProgressEvent.COMPLETE
	 */
	[Event(name="complete", type="br.com.stimuli.loading.BulkProgressEvent")]
	
	/**
	 * A method for easier loading and parsing of xml data
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Model 
	{
		static private var _prefix:String
		static private var url_regex:RegExp = /(https?:\/\/[-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?/
		static private function getHost(url:String):String{
		  return url.match(url_regex) ? url.match(url_regex)[1] : null 
		}
		
		public function Model() { throw new StaticClassError() }
		
		
		static public var loader:BulkLoader = new BulkLoader('xml-data-loader')
		
        /**
         * Registers an event listener. proxy for the bulkLoader
         * @param type Event type.
         * @param listener Event listener.
         */
        public static function addEventListener(type:String, listener:Function):void {
            loader.addEventListener(type, listener, false, 0, false);
        }
		
		/**
		 *	same as unescape, but converts '+' to ' '
		 */
		public static function decode(s:String):String {
			return unescape(s.replace(/\+/g, ' '))
		}

        /**
         * Removes an event listener.
         * @param type Event type.
         * @param listener Event listener.
         */
        public static function removeEventListener(type:String, listener:Function):void {
            loader.removeEventListener(type, listener, false);
        }
		
		/**
		 *	Define a xml url to load
		 */
		static public function loadXML(url:String):void {
			_prefix = getHost(url)
			loader.add(url, {id:'xml-data', type:BulkLoader.TYPE_XML, preventCache: true})
		}
		
		/**
		 *	Start loading the xml
		 */
		static public function start():void {
			loader.start()
		}
		
		/**
		 *	Get the xml data
		 */
		static public function get data():XML {
			return loader.getXML('xml-data')
		}
		
		/**
		 *	If the url is relative, adds a prefix host to the beginning, making it an absolute one.
		 */
		static public function filename(url:String):String {
		  return getHost(url) ? url : _prefix+url
		}
		
		/**
		 *	Get an xml node with a specified name and 'id' attribute (this combination is assumed to be unique). 
		 *	The third parameter specifies a certain offset, usefull when you want to get previous/next element
		 *	@param	nodeName	 The name of the xml node
		 *	@param	id	 The id attribute of the xml node
		 *	@param	offset	 Offsets the result inside its parent children list
		 */
		static public function element(nodeName:String, id:String, offset:int = 0):XML {
			var xml:XML = Model.data..*.(name() == nodeName && attribute('id') == id)[0]
			if (offset == 0) {
				return xml
			} else {
				var offset_xml:XML = xml.parent().children()[xml.childIndex() + offset]
				return (offset_xml && offset_xml.name() == nodeName) ? offset_xml : null
			}
		}
		
		/**
		 *	@private
		 */
		static public function dictionary(word:String):String {
			return Model.data.dictionary.(name() == word)[0]
		}
	}
	
}