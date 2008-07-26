package framy.loading {
	import flash.display.Loader;
	import flash.events.ActivityEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import framy.tools.Hash;
	import framy.events.NProgressEvent;

	public class LoadQueue extends EventDispatcher{
		public var loaded:Array = new Array()
		private var _queue:Array
		private var _current:uint = 0
		private var _new_asset:Loader = new Loader()
		public var prefix:String = ''
		private var _loading:Boolean = false
		
		public function LoadQueue(queue:Array=null) {
			this._queue = queue || new Array()
			
			this._new_asset.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.onProgress)
			this._new_asset.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete)
			this._new_asset.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onError)
		}
		
		public function is_empty():Boolean {
			return this._queue.length == 0
		}
		
		public function add(...arguments):void {
			for (var i:int; i < arguments.length; i++) {
				if (arguments[i] is Array) {
					this._queue = this._queue.concat(arguments[i])
				}else {
					this._queue.push(arguments[i])
				}
			}
		}
		
		public function start():void {
			this._loading = true
			this.load_current()
		}
		
		public function get loading_started():Boolean {
			return this._loading
		}
		
		private function load_current():void{
		
			if (this._queue.length > this._current ) {
				this._new_asset.load(new URLRequest(Library.filename(this.prefix + this._queue[this._current])))
			}else {
				throw new VerifyError("Queue already loaded")
			}
		}
		
		private function onProgress(event:ProgressEvent):void{
			var progress:Number = (event.bytesLoaded/event.bytesTotal + this._current)/this._queue.length
			this.dispatchEvent(new NProgressEvent(ProgressEvent.PROGRESS,progress))
		}
		
		private function onComplete(event:Event):void{
			this._current++
			this.loaded.push(event.target.content)
			if(this._current == this._queue.length)this.dispatchEvent(new Event(Event.COMPLETE))
			else this.load_current()
		}
		
		private function onError(event:IOErrorEvent):void {
			
		}
	}
	
}
