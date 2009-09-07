package framy.structure 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import framy.routing.Router;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class RootWidgetContainer extends SpriteWidgetContainer
	{
		static private var _instance:RootWidgetContainer
		static public var START_RESIZE:String = 'StartResizeEvent'
		private var _resize_timer:Timer = new Timer(250, 1)
		private var _captured_resize_event:Event
		
	  
		public function RootWidgetContainer(container:Sprite) 
		{
			super(container,'app.widgets')
			if (_instance) throw Error("The RootWidgetContainer can only be created once")
			_instance = this			
			container.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage)
		}
		
		private function onAddedToStage(event:Event):void {
			this.container.stage.scaleMode = StageScaleMode.NO_SCALE
			this.container.stage.align = StageAlign.TOP_LEFT;
			this.container.stage.addEventListener(Event.RESIZE, this._onStageResize)
			this._resize_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this._onResize)
			
		}
		
		private function _onStageResize(event:Event):void {
			Router.stateChanged()
			this.container.dispatchEvent(new Event(START_RESIZE))
			if (Initializer.options.resize.wait) {
			  this._resize_timer.delay = Initializer.options.resize.wait * 1000
				this._captured_resize_event = event.clone()
				this._resize_timer.reset()
				this._resize_timer.start()
			}
			else this.container.dispatchEvent(event.clone())
		}
		

		
		private function _onResize(event:TimerEvent):void {
			this.container.dispatchEvent(this._captured_resize_event)
		}
		
		override public function get containerWidth():int { return this.container.stage.stageWidth }
		override public function get containerHeight():int { return this.container.stage.stageHeight }

		
		static public function get stage():Stage { return _instance.container.stage }
		static public function get stageWidth():int { return _instance.containerWidth }
		static public function get stageHeight():int { return _instance.containerHeight }
		static public function get stageRatio():int { return _instance.containerWidth / _instance.containerHeight }
		
		static public function resizeAll():void {
			_instance.container.stage.dispatchEvent(new Event(Event.RESIZE))
		}		
		
		static public function get instance():RootWidgetContainer {	return _instance }
		
		static public function applyWidgetViews(...arguments):void {
			_instance.applyViews.apply(_instance, arguments)
		}
		
		static public function getContent(id:String):* {
			var w:Widget = getWidget(id)
			return w ? w.content : null
		}
		
		static public function getWidget(id:String):Widget {
			var c:WidgetContainer = _instance
			var names:Array = id.split('.')
			if (names.length > 1) {
				var remaining_names:Array = names.slice(0,names.length-1)
				for each(var name:String in remaining_names)c = c.getWidgetForId(name).widgets 
			}
			return c.getWidgetForId(names[names.length-1])
		}		
		
    /**
     * Registers an event listener.
     * @param type Event type.
     * @param listener Event listener.
     */
    static public function addEventListener(type:String, listener:Function):void {
        _instance.container.addEventListener(type, listener, false, 0, false);
    }

    /**
     * Removes an event listener.
     * @param type Event type.
     * @param listener Event listener.
     */
    static public function removeEventListener(type:String, listener:Function):void {
        _instance.container.removeEventListener(type, listener, false);
    }				
	}
	
}