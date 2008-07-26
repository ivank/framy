package framy.tools {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import caurina.transitions.Tweener;
	import flash.ui.Mouse;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class CustomCursor {
		private static var cursors:Hash = new Hash()
		private static var options:Dictionary = new Dictionary(true)
		private static var _stage:Stage
		private static var current_cursor:Sprite
		
		static public function init(stage:Stage):void {
			_stage = stage
		}
		
		static public function register(name:String, cursor:Sprite, opts:Object = null):void {
			options[cursor] = new Options(opts, { time: 0.6, transition: 'easeOutCubic', x: -Math.round(cursor.width/2), y: -Math.round(cursor.height/2), hide_mouse:true } )
			cursors[name] = cursor
		}
		
		static public function set_cursor(name:String):void {
			current_cursor = cursors[name]
			if (options[current_cursor].hide_mouse) Mouse.hide()
			
			_stage.addChild(current_cursor)
			current_cursor.x = _stage.mouseX + options[current_cursor].x
			current_cursor.y = _stage.mouseY + options[current_cursor].y
			current_cursor.mouseEnabled = false
			current_cursor.alpha = 0
			Tweener.addTween(current_cursor, {alpha:1, time: options[current_cursor].time, transition: options[current_cursor].transition})
			current_cursor.startDrag()					
		}
		
		static public function hide_cursor():void {
			Tweener.addTween(current_cursor, { alpha:0, time: options[current_cursor].time, transition: options[current_cursor].transition, onComplete:function():void {
				if (CustomCursor.options[CustomCursor.current_cursor].hide_mouse) Mouse.show()
				CustomCursor.current_cursor.stopDrag()
				CustomCursor._stage.removeChild(CustomCursor.current_cursor)
				CustomCursor.current_cursor = null
			}})
			
		}

	}
	
}