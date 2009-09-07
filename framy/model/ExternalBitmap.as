package framy.model 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import framy.graphics.fyBitmap;
	import framy.utils.Aspect;
	import framy.utils.Hash;
	
	/**
	 *  Dispatched on download progress.
	 *
	 *  @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent.PROGRESS")]

	/**
	 *  Dispatched when the bitmap has been downloaded and parsed.
	 *
	 *  @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event.COMPLETE")]	
	
	/**
	 * Create easy self-loading bitmaps using BulkLoader (independantly or using a specified loader)
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class ExternalBitmap extends fyBitmap
	{
		private var loader:BulkLoader
		private var _url:*
		private var _on_load_hash:Object
		private var _bitmap_aspect:Aspect
		private var _smoothing:Boolean
		/**
		 *	<p>Creates the bitmap, which will be loaded from a specified url.</p>
		 *	You can set options for the loading:
		 *	<ul>
		 *		<li>loader - uses a spceified BulkLoader, otherwise, creates its own unique one</li>
		 *		<li>auto_start - when set to true, starts the loading as soon as the bitmap is created. </li>
		 *		<li>num_connections and log_level - passed to the BulkLoader</li>
		 *		<li>on_load - a hash of parameters that this bitmap is tweened to, after the loading is complete</li>
		 *		<li>add_host - If set to false does not add the host to the url, default is true</li>
		 *	</ul>
		 *	@param	url	 The urls of the image to load - either a string or flash.net.URLRequest
		 *	@param	options	 Options for the loading - auto_start, on_load, add_host, loader, num_connections and log_level
		 *	@param	attrs	 A hash of attributes applied to the bitmap after creation
		 *	@see	br.com.stimuli.loading.BulkLoader br.com.stimuli.loading.BulkLoader
		 *	@constructor
		 *	@example Basic usage: <listing version="3.0">
var image:ExternalBitmap = new ExternalBitmap('/images/big_smile.png')

image.addEventListener(ProgressEvent.PROGRESS, function(event:ProgressEvent):void{
  trace(event.bytesLoaded)
})

image.addEventListener(Event.COMPLETE, function(event:Event):void{
  trace('image loaded!')
})

image.start()
		 *	</listing>
		 *	@example Using a single BulkLoader, loading one by one: <listing version="3.0">
// Create a new bulkloader, with number of connections = 1, ensuring that the images load one by one
var image_loader:BulkLoader = new BulkLoader('image-loader',1)

// Create the first image with starting alpha 0, it will tween to full alpha after it's loaded
var image1:ExternalBitmap = new ExternalBitmap('/images/image1.jpg', { on_load:{alpha:1, time:1}, loader: image_loader}, {alpha:0})

// Create the second image like the first, but 200 pixels below
var image2:ExternalBitmap = new ExternalBitmap('/images/image2.jpg', { on_load:{alpha:1, time:1}, loader: image_loader}, {alpha:0, y: 200 })

//Start loading all the images
image_loader.start()
		 *	</listing>
		 */
		public function ExternalBitmap(url:*, options:Object = null, attrs:Object = null) {
			var opts:Hash = new Hash({ auto_start: false, on_load: null, add_host: true, loader: null, num_connections: BulkLoader.DEFAULT_NUM_CONNECTIONS, log_level: BulkLoader.DEFAULT_LOG_LEVEL }).merge(options)
			this._url = opts.add_host ? Model.filename(url) : url
			this._on_load_hash = opts.on_load
			
			if (opts.loader && opts.loader is BulkLoader) {
				this.loader = opts.loader
				
				if (!this.loader.get(this._url)) this.loader.add(this._url, { type: BulkLoader.TYPE_IMAGE } )
				else if (this.loader.get(this._url).isLoaded) {
					this.bitmapData = this.loader.getBitmapData(this._url)
					super.smoothing = this._smoothing
					this._bitmap_aspect = this.aspect
				}
			}else {
				this.loader = BulkLoader.createUniqueNamedLoader(opts.num_connections, opts.log_level)
				this.loader.add(this._url, { type: BulkLoader.TYPE_IMAGE } )
			}
			this.loader.get(this._url).addEventListener(ProgressEvent.PROGRESS, this.onLoadProgress)
			this.loader.get(this._url).addEventListener(Event.COMPLETE, this.onLoadComplete)
			this.attrs = attrs
			if(opts.auto_start)this.start()
		}
		
		/**
		 *	Stop the loading
		 */
		public function stop():void {
			this.loader.pause(this._url)
		}
		
		/**
		 *	Starts the loading, if the element is already loaded, dispatches the Event.COMPLETE event
		 */
		public function start():void {
			if ( this.isLoaded ) this.loader.get(this._url).dispatchEvent(new Event(Event.COMPLETE))
			else if (!this.loader.isRunning) this.loader.start()
		}
		
		public function get isLoaded():Boolean {
			return this.loader.get(this._url).isLoaded
		}
		
		/**
		 *	Get the url of the loaded image
		 */
		public function get url():*{ return _url }
		
		private function onLoadProgress(event:ProgressEvent):void {	this.dispatchEvent(event.clone()) }
		private function onLoadComplete(event:Event):void {	
			if (!this.bitmapData) this.bitmapData = this.loader.getBitmapData(this._url)
			this._bitmap_aspect = this.aspect
			super.smoothing = this._smoothing
			this.dispatchEvent(event.clone())
			
			if (this._on_load_hash) {
				this.tween(this._on_load_hash)
			}
		}
		
		public function get bitmap_aspect():Aspect { return this._bitmap_aspect }
		
		override public function get smoothing():Boolean { return _smoothing; }
		
		override public function set smoothing(value:Boolean):void 
		{
			_smoothing = value;
			super.smoothing = true
		}
	}
	
}