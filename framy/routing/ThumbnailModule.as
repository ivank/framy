package framy.routing {
	import flash.events.Event;
	import framy.events.ActionEvent;
	import framy.events.RouteEvent;
	import framy.events.TranslateEvent;
	import framy.tools.Options;
	
	/**
	* ...
	* @author Ivan K
	*/
	public class ThumbnailModule extends Module{
		private var _zoomed:Boolean = false
		
		public function ThumbnailModule(options:Object = null) {
			super(new Options(options, { auto_add: false}))
			
			this.parent_module.addEventListener(ActionEvent.BUILD_STARTED, this._onParentBuildStarted)
			this.parent_module.addEventListener(ActionEvent.PREPARE_STARTED, this._onParentPrepareStarted)
			this.parent_module.addEventListener(ActionEvent.DESTROY_STARTED, this._onParentDestroyStarted)
			this.parent_module.addEventListener(ActionEvent.RESTORE_STARTED, this._onParentRestoreStarted)
			this.parent_module.addEventListener(ActionEvent.TRANSLATE_STARTED, this._onParentTranslateStarted)
		}
		
		private function _onParentBuildStarted(event:RouteEvent):void {
			this.dispatchEvent(new Event(ActionEvent.THUMB_BUILD_STARTED))
		}
		
		private function _onParentDestroyStarted(event:Event):void {
			this.dispatchEvent(new Event(ActionEvent.THUMB_DESTROY_STARTED))
		}
		
		private function _onParentTranslateStarted(event:TranslateEvent):void {
			(event.from as ThumbnailModule)._zoomed = false;
			(event.to as ThumbnailModule)._zoomed = true;
			event.from.dispatchEvent(new Event(ActionEvent.THUMB_ZOOM_NOT_CURRENT));
			event.to.dispatchEvent(new Event(ActionEvent.THUMB_ZOOM));
		}
		
		private function _onParentPrepareStarted(event:RouteEvent):void {
			if (event.new_module == this) {
				this.dispatchEvent(new Event(ActionEvent.THUMB_ZOOM))
				this._zoomed = true
			}else {
				this.dispatchEvent(new Event(ActionEvent.THUMB_ZOOM_NOT_CURRENT))
			}
		}
		
		private function _onParentRestoreStarted(event:RouteEvent):void {
			this.dispatchEvent(new Event(ActionEvent.THUMB_SHRINK))
		}
		
		public function get zoomed():Boolean { return this._zoomed }
		
	}
	
}