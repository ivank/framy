package framy.loading {
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.display.Bitmap
	import flash.system.System;
	import framy.ActionSprite;
	import framy.graphics.Aspect;
	import framy.tools.Grawl;
	import framy.tools.Hash;
	import framy.tools.Options;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	import flash.net.navigateToURL;
	

	/**
	 * A class to transparently load and cache images and swfs
	 */
	public class ExternalImage extends ActionSprite{
		
		protected var image_loader:Loader
		public var image_content:ActionSprite
		protected var _loaded:Boolean = false
		public var loaded_from_cache:Boolean = false
		protected var options:Options
		private var loading_started:Boolean = false
		protected var external_file:String
		private var _old_onComplete:Function
		protected var _new_image_width:uint
		protected var _new_image_height:uint
		protected var _loading:Boolean = false
		static private var redraw_invokers:Array = ['width', 'height', 'image_width', 'image_height', 'dims', 'image_dims', 'scaleX', 'scaleY']
		private var specific_redraw_invokers:Array
		private var _pixelized_resize:Boolean = false
		
		private var loading_anim:ActionSprite
		private var loading_aspect:Aspect
		
		private var load_timer:Timer = new Timer(0, 1)
		private var _load_event:Event
		
		
		
		/**
		 * Has many spectial options:
		 * * cache				boolean	weather to cache the external image in memory, so when a new one is created, it will not go through the http load loop, defaults to false
		 * * bitmap				boolean	true by default - if the image is a Bitmap (jpg, png and similar), set it to false for swf or svg files
		 * * pixelized_resize	boolean	when set to true, each tween will first unset the smoothing parameter, then will set it to true in the onComplete event
		 * * smoothing			boolean toggles the smoothing of the image
		 * * load_delay         Number  adds a minimum time for the loading event to trigger, if the image is loaded before this time, it will wait for it
		 * @param	file
		 * @param	opts
		 */
		public function ExternalImage(file:String, opts:Object=null) {
			this.options = new Options(opts,{cache:false, context_menu:false, load_delay:0, bitmap:true, pixelized_resize:false, smoothing:false, pixelSnapping:PixelSnapping.AUTO})
			this.external_file = Library.filename(file)
			this.addEventListener(Event.COMPLETE, this._onImageLoaded, false, 7 )
			super( { } )
			if (this.options.load_delay > 0) this.load_timer.delay = this.options.load_delay * 1000
			
			if (this.options.pixelized_resize) {
				this._pixelized_resize = true
				specific_redraw_invokers = (new Array()).concat(redraw_invokers)
				if(this.options.pixelized_resize is Array)specific_redraw_invokers = specific_redraw_invokers.concat(this.options.pixelized_resize)
			}
		}
		
		/**
		 * returns the actual loaded bitmap image
		 */
		public function get bitmap_content():Bitmap {
			return this.image_content.getChildAt(0) as Bitmap
		}
		
		public function addLoadingAnim(l:ActionSprite):void {
			this.loading_anim = l
			this.loading_aspect = this.loading_anim.aspect
			
			this.loading_anim.pos = this.loading_aspect.center(this.image_width, this.image_height).pos
		}
		
		/**
		 * stops the loading if it's initiated
		 */
		public function stop_loading():void {
			if (!this._loaded && this.image_loader && this._loading) {
				try{
					this.image_loader.close()
				}catch (e:Error) {
					this._loading = false
				}
				this.load_timer.reset()
				this._loading = false
			}
		}
		
		/**
		 * initiates the loading, and fires a Event.COMPLETE upon completion
		 * if the image is already loaded, fires the event imidiately
		 * if the image is in the cache - loads it from there
		 */
		public function load():void {
			this.image_content = new ActionSprite()
			if (this.loading_anim) {
				this.loading_anim.alpha = 0
				this.loading_anim.tween( { alpha:1, time: 0.5, transition: "easeInCubic" } )
				this.addChild(this.loading_anim)
			}
			
			if (this._loaded) {
				this.dispatchEvent(new Event(Event.COMPLETE))
			}else if(this.options.cache && Cache.exists(external_file)){
				this.image_content.addChild(Cache.retrieve(external_file))
				this.addChild(this.image_content)
				this._loaded = true
				this.loaded_from_cache = true
				
				this.dispatchEvent(new Event(Event.COMPLETE))
			}else {
				if(this.load_timer.delay > 0)this.load_timer.start()
				this.image_loader = new Loader()
				this.image_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onLoaderProgress)
				this.image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderLoaded, false, 5)
				this.image_loader.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaderInit)
				this.image_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoaderLoadError)
				try {
					_loading = true
					this.image_loader.load(new URLRequest(this.external_file))
				}catch (e:Error) {
					_loading = false
					this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR))
				}
			}
		}
		private function _onImageLoaded(event:Event):void {
			if (this._new_image_width) this.image_width = this._new_image_width
			if (this._new_image_height) this.image_height = this._new_image_height
			if (this.loading_anim) {
				this.loading_anim.tween( { alpha:0, time: 0.5, transition: "easeOutCubic", onComplete:function():void {
					var img:ExternalImage = this.parent
					img.removeChild(this)
					img.loading_anim = null
				}})
			}
			
		}
		
		public function set pixelized_resize(pr:Boolean):*{
			return this._pixelized_resize = pr
		}
		
		public function get pixelized_resize():Boolean{
			return this._pixelized_resize
		}		
		
		public function set smoothing(sm:Boolean):*{
			return this.image_content && this.image_content.numChildren ? (this.bitmap_content.smoothing = sm) : false
		}
		
		public function get smoothing():Boolean {
			return this.image_content && this.image_content.numChildren ? this.bitmap_content.smoothing : false
		}
		
		public function stop():void {
			if(this.image_loader)
				this.image_loader.close()
		}
		
		override public function tween(opts:Object):Boolean {
			if (this.pixelized_resize && this.smoothing == true) {
				if (new Hash(opts).keys.some(function(item:*, index:int, array:Array):Boolean {
					return this.specific_redraw_invokers.indexOf(item.toString()) >= 0
				},this)) {
					this.smoothing = false
					if(opts.onComplete)this._old_onComplete = opts.onComplete
					opts.onComplete = this.smoothAfterResize
				}
			}
			return super.tween(opts)
		}
		
		private function smoothAfterResize():void {
			if (this._old_onComplete != null) this._old_onComplete()
			this._old_onComplete = null
			this.smoothing = true
		}
		
		public function removeLoadedFile():void {
			this.removeChild(this.image_content)
			this.image_content = null
			this._loaded = false
		}
		
		// Events
		//========================================================
		private function onLoaderProgress(event:ProgressEvent):void {
			this.dispatchEvent(event.clone())
			if(this.loading_anim)this.loading_anim.dispatchEvent(event.clone())
		}
		private function onLoaderInit(event:Event):void{this.dispatchEvent(event.clone())}
		
		private function onLoaderLoaded(event:Event):void {
			if (this.load_timer.running) {
				this._load_event = event
				this.load_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onLoaderLoaded)
			}else {
				if(_load_event)event = _load_event
				if (this.load_timer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
					this.load_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onLoaderLoaded)
				}
				this._loading = false
				var content:*
				if(options.bitmap || options.smoothing || options.pixelSnapping != PixelSnapping.AUTO){
					
					content = (event.target.loader as Loader).content as Bitmap
					content.smoothing = options.smoothing
					content.pixelSnapping = options.pixelSnapping
				}else{
					content = event.target.loader
				}
				
				
				this.image_content.addChild(content)
				
				if(options.cache)Cache.add(this.external_file, this.image_content)
				this.image_loader = null
				
				this.addChild(this.image_content)
				this._loaded = true
				
				this.dispatchEvent(event.clone())
			}
		}
		
		private function onLoaderLoadError(event:IOErrorEvent):void {
			_loading = false
			this.dispatchEvent(event.clone())
		}			
		
		public function get loaded():Boolean { return this._loaded }
		
		/**
		 * modifies the dimensions of the actual loaded bitmap
		 */
		public function set image_dims(dims:Array):* {
			this.image_width = dims[0]
			this.image_height = dims[1]
			return dims
		}
		
		/**
		 * modifies the width of the actual loaded bitmap,
		 * if it's not loaded, saves the value, and aplies it when it is loaded
		 */
		public function set image_width(width:uint):* {
			if (this.loading_anim) this.loading_anim.x = this.loading_aspect.center(width, this.image_height).x
			if (this.image_content && this.image_content.numChildren)return this.bitmap_content.width = width
			else return _new_image_width = width
		}
		
		/**
		 * modifies the height of the actual loaded bitmap,
		 * if it's not loaded, saves the value, and aplies it when it is loaded
		 */		
		public function set image_height(height:uint):* {
			if (this.loading_anim) this.loading_anim.y = this.loading_aspect.center(this.image_width, height).y
			if (this.image_content && this.image_content.numChildren)return this.bitmap_content.height = height
			else return _new_image_height = height
		}
		
		public function get image_width():uint { return this.image_content && this.image_content.numChildren ? this.bitmap_content.width : _new_image_width }
		public function get image_height():uint { return this.image_content && this.image_content.numChildren ? this.bitmap_content.height : _new_image_height }
		
		public function get image_dims():Array {
			return [image_width, image_height]
		}
	}
	
}
