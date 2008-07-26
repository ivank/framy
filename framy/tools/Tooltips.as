package framy.tools {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import framy.ActionSprite;
	import framy.graphics.Colors;
	import framy.ActionText;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import framy.Rect;
	import flash.filters.DropShadowFilter;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Tooltips extends ActionSprite{
		static private var _options:Options
		static private var _trigger_options:Dictionary = new Dictionary(true)
		static public var _stage:Stage
		static private var _messages:Dictionary = new Dictionary(true)
		static private var _current:Tooltips
		
		private var text:ActionText
		private var bg:Rect
		
		static public function init(opts:Object = null):void {
			_options = new Options(opts, { html:false, size: 14, shadow_color: 0x666666, bg_color: Colors.WHITE, color: Colors.BLACK, padding:5, width: 200, font:"Arial", delay:0.8, time: 0.5 } )
		}
		
		static public function attach(trigger:DisplayObject, msg:*, opts:Object = null):void {
			_messages[trigger] = msg
			_trigger_options[trigger] = opts
			trigger.addEventListener(MouseEvent.ROLL_OVER, onTriggerOver)
			trigger.addEventListener(MouseEvent.ROLL_OUT, onTriggerOut)
		}
		
		static public function change_message(trigger:DisplayObject, new_msg:*):void {
			_messages[trigger] = new_msg
		}
		
		static private function onTriggerOver(event:MouseEvent):void {
			if ( _messages[event.target]) {
				var local_options:Options = new Options( _trigger_options[event.target], _options)
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoseMove)
				_current = new Tooltips(_messages[event.target],_trigger_options[event.target])
				_current.alpha = 0
				_current.tween({ alpha: 1, delay: local_options.delay, time: local_options.time })
				_stage.addChild(_current)
				position_near(event.stageX, event.stageY)
			}
		}
		
		static private function position_near(x:int, y:int):void {
			_current.x = Math.round((x + _current.width > _stage.stageWidth) ? x - _current.width-5 : x+5)
			_current.y = Math.round((y + _current.height > _stage.stageHeight) ? y - _current.height-10 : y+10)
		}
		
		static private function onTriggerOut(event:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoseMove)
			_stage.removeChild(_current)
			_current = null
			
		}
		
		static private function onMoseMove(event:MouseEvent):void {
			position_near(event.stageX, event.stageY)
		}
		
		public function Tooltips(msg:*, opts:Object = null) {
			this.mouseEnabled = false
			this.mouseChildren = false
			var local_options:Options = new Options(opts, _options)
			
			if (msg == null) msg = "null"
				
			this.text = new ActionText( new Hash(msg is Array ? {i18n:msg} : (local_options.html ? {htmlText: msg} : {text: msg})).merge({ 
				font: local_options.font, 
				embedFonts:true, 
				autoSize: TextFieldAutoSize.LEFT,
				antiAliasType: AntiAliasType.ADVANCED,
				gridFitType: GridFitType.PIXEL,
				wordWrap: true,
				selectable: false,
				condenseWhite:true, 
				css: local_options.html ? { p: { fontSize: local_options.size, leading: 2, fontFamily: local_options.font, color: Html.color(local_options.color) } } : false,
				multiline: true,
				html: local_options.html,
				condenseWhite: true, 
				color: local_options.color, 
				width: Math.round(local_options.width - 2 * local_options.padding), 
				x: Math.round(local_options.padding), y:Math.round(local_options.padding), 
				size: local_options.size
			}))
			
			this.bg = new Rect( { width: local_options.width, height: this.text.height + 2 * local_options.padding, color: local_options.bg_color } )
			this.bg.filters = [new DropShadowFilter( 3, 45, local_options.shadow_color, 0.6, 8,8,2) ]
			this.addChildren(this.bg, this.text)
		}
		
	}
	
}