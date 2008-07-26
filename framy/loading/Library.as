package framy.loading {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Security;
	import framy.loading.Environment
	import framy.tools.Hash;
	import framy.tools.Options;
	import framy.events.NProgressEvent
	
	public class Library extends EventDispatcher{
		public static var env:Environment
		public static var assets:Hash
		public static var lib:Hash
		public static var xml:XML
		private static var _loaded:Boolean = false
		
		private var _xml_loader:URLLoader
		private var _assets_queue:LoadQueue
		private var _assets_sources:Hash
		private var _library:String = '/'
		private var _loading:Boolean = false
		private var _environments:Hash = new Hash()
		private var _current_environment:int
		
		static public function filename(file:String):String {
			return env ? (env.host + file) : file
		}
		
		/**
		 * Initialize the library (xml and assets)
		 * @param	opts	shortcuts: 
		 * lib -> set library 
		 * assets -> add Assets (name:value pairs)
		 * dev -> set the development environment
		 * prod -> set production environment
		 */
		public function Library(opts:Object=null){
			var options:Options = new Options(opts,{current:false})
			
			if (options.lib) this.library = options.lib
			this._current_environment = options.current ? options.current : Environment.guess_type()
			if (options.dev) this.addEnvironment(options.dev, Environment.DEVELOPMENT)
			if (options.prod) this.addEnvironment(options.prod, Environment.PRODUCTION)
			if (options.local) this.addEnvironment(options.local, Environment.LOCAL)
			
			this._assets_sources = new Hash()
			this._assets_queue = new LoadQueue()
			
			if(options.assets){
				
				//Asset Loader Initialize
				this._assets_sources.merge(options.assets)
				this._assets_queue.add(this._assets_sources.values)
				
				this._assets_queue.prefix = this._library
				
				this._assets_queue.addEventListener(ProgressEvent.PROGRESS,this.onAssetProgress)
				this._assets_queue.addEventListener(Event.COMPLETE, this.onAssetComplete)
				this._assets_queue.addEventListener(IOErrorEvent.IO_ERROR, this.onError)
				
				// XML loader initialize
			}
			this._xml_loader = new URLLoader()
			
			this._xml_loader.addEventListener(ProgressEvent.PROGRESS, this.onXmlProgress)
			this._xml_loader.addEventListener(Event.COMPLETE, this.onXmlComplete)
			this._xml_loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError)
		}
		
		public function onError(error:IOErrorEvent):void {
			this.dispatchEvent(error)
		}
		
		/**
		 * Setter for the library prefix ( to be placed before all asset uris, defaults to "library/" )
		 */
		public function set library(library:String):void {
			if (this._assets_queue.loading_started) throw new VerifyError("Cannot change the library once the loading has started")
			else this._library = library
		}
		
		/**
		 * Adds an asset ( png, swf, jpg ...) to be loaded along with the xml, after it is loaded it can be reached through Library.assets.<name>
		 * @param	name	the identifier of the asset
		 * @param	asset_url
		 */
		public function addAsset(name:String, asset_url:String):void {
			if (this._assets_queue.loading_started) throw new VerifyError("Cannot add assets after loading started")
			else {
				this._assets_sources[name] = asset_url
				this._assets_queue.add(asset_url)
			}
		}
		
		/**
		 * Adds an environment
		 * @param	opts	set host option to be placed before images, and xml to be loaded
		 * @param	env
		 * @return
		 */
		public function addEnvironment(opts:Object, env:uint):Environment {
			if( this._loading ) throw new VerifyError("Cannot add environment after loading started")
			return this._environments[env] = new Environment(opts)
		}
		
		public function load():void {
			this._loading = true
			
			env = this._environments[this._current_environment]
			this._xml_loader.load(new URLRequest(env.xml))
		}
		
		
		private function onAssetProgress(event:NProgressEvent):void{
			this.dispatchEvent(new NProgressEvent(ProgressEvent.PROGRESS, 0.2 + event.progress*0.8))
		}
		
		private function onAssetComplete(event:Event):void{
			Library.assets = this._assets_sources.replace_values(this._assets_queue.loaded)
			_loaded = true
			
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
		
		private function onXmlProgress(event:ProgressEvent):void{
			this.dispatchEvent(new NProgressEvent(ProgressEvent.PROGRESS, (event.bytesLoaded/event.bytesTotal)*0.2))
		}
		
		private function onXmlComplete(event:Event):void {
			Library.xml = new XML(this._xml_loader.data)
			
			if (this._assets_queue.is_empty()) {
				_loaded = true
				this.dispatchEvent(new Event(Event.COMPLETE))
			}
			else this._assets_queue.start()
		}
		
		static public function get loaded():Boolean{ return _loaded } 
	}
	
}
