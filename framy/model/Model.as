package framy.model 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
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
		
		static private var onXMLLoadCallback:Function
		static public const ALL_COMPLETE:String = "AllLoadingsCompleted"
		static public const XML_COMPLETE:String = "XMLLoadingsCompleted"
		static private var url_regex:RegExp = /(https?:\/\/[-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?/
		
		static private function getHost(url:String):String{
		  return url.match(url_regex) ? url.match(url_regex)[1] : null 
		}
		
		public function Model() { throw new StaticClassError() }
		
		
		static public var loader:BulkLoader = new BulkLoader('model-loader',5)
		
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
		 * Load the xml data, after witch execute the callback so that you can load 
		 * some dinamic assets (set through the xml) before you finish the main loading 
		 * @param	url the url to the xml file
		 * @param	onXmlLoad a callback to be executed after the xml is loaded
		 */
		public static function loadData(url:String, onXmlLoad:Function = null):void {
			Model.loadXML(url)
			Model.onXMLLoadCallback = onXmlLoad
			Model.loader.addEventListener(BulkProgressEvent.COMPLETE, Model.onXmlLoadComplete)
			Model.start()
		}
		
		/**
		 *	Define a xml url to load
		 */
		static public function loadXML(url:String):void {
			_prefix = getHost(url)
			loader.add(url, { priority: 10, id:'xml-data', type:BulkLoader.TYPE_XML, preventCache: true } )
		}

		
		static public function onXmlLoadComplete(event:Event):void {
			
			Model.loader.dispatchEvent(new Event(XML_COMPLETE))
			Model.loader.removeEventListener(BulkProgressEvent.COMPLETE, Model.onXmlLoadComplete)
			Model.onXMLLoadCallback()
			if (Model.loader.isFinished)
				loader.dispatchEvent(new Event(ALL_COMPLETE))
			else
				Model.loader.addEventListener(BulkProgressEvent.COMPLETE, Model.onEverythingLoaded)
		}
		
		static public function onEverythingLoaded(event:Event):void {
			
			loader.removeEventListener(BulkProgressEvent.COMPLETE, Model.onEverythingLoaded)
			
			loader.dispatchEvent(new Event(ALL_COMPLETE))
		}
		
		static public function loadImage(url:String, id:String = null):void {
			loader.add(Model.filename(url), { id: (id || Model.filename(url)), type: BulkLoader.TYPE_IMAGE } )
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
		
		static public function getBitmapData(url:String):BitmapData {
			return Model.loader.getBitmapData(Model.filename(url))
		}
		
		static public function getBitmap(url:String):Bitmap {
			return Model.loader.getBitmap(Model.filename(url))
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
		static public function element(nodeName:String, id:String = null, offset:int = 0):XML {
			var xml:XML = Model.data..*.(name() == nodeName && attribute('id') == id)[0]
			if (offset == 0) {
				return xml
			} else {
				var offset_xml:* = xml.parent().children()[xml.childIndex() + offset]
				return (offset_xml && offset_xml is XML && offset_xml.name() == nodeName) ? offset_xml : null
			}
		}
		
		static public function i18nIext(xml_list:*, culture:String):String {
			if (xml_list is XMLList) {
				var c:XMLList = xml_list.(@lang == culture)
				return (c && c.length()) ? c[0].text() : 'not translated'
			}else {
				return xml_list
			}
			
		}
		
		
/**
		 *	A shortcut to a dictionary element (tag name "dictionary") child with the given name
		 */
		static public function dictionary(word:String):* {
			var dict_lsit:XMLList = Model.data.dictionary.(name() == word)
			if (dict_lsit.length == 1) return dict_lsit[0]
			else return dict_lsit
		}
	}
	
}