package framy.tools {
	import caurina.transitions.Equations;
	import flash.display.Stage;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import framy.ActionSprite;
	import framy.ActionText;
	import framy.graphics.Colors;
	import framy.Rect;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Grawl extends ActionSprite{
		static public var stage:Stage
		static private var options:Options
		static private var bg_color:uint
		static private var color:uint
		static private var font:String
		
		public static var active:Boolean  = false
		
		static private var count:uint = 0
		
		private var bg:Rect
		private var text:ActionText
		
		
		public function Grawl(msg:*) {
			if (msg == null) msg = "null"
			this.text = new ActionText( new Hash(msg is Array ? {i18n:msg} : {text: msg}).merge({ 
				font: options.font, 
				embedFonts:true, 
				autoSize: TextFieldAutoSize.LEFT,
				antiAliasType: AntiAliasType.ADVANCED,
				gridFitType: GridFitType.PIXEL,
				wordWrap: true,
				selectable: false,
				multiline: true,
				condenseWhite: true, 
				color: options.color, 
				width: options.width - 2 * options.padding, 
				x: options.padding, y:options.padding, 
				size: options.size
			}))
			
			this.bg = new Rect( { width:options.width, height: this.text.height + 2 * options.padding, color: options.bg_color } )
			this.bg.filters = [new DropShadowFilter( 3, 45, options.shadow_color, 0.6, 8,8,2) ]
			this.addChildren(this.bg, this.text)
		}
		
		static public function init(opts:Object = null):void {
			options = new Options(opts, {size: 14, width: 300, padding: 20, offset: 25, time: 5, bg_color: Colors.WHITE, color: Colors.BLACK, font:"Arial", shadow_color: Colors.LIGHT_GRAY})
			Grawl.active = true
		}
		
		static public function message(msg:*, opts:Object = null):void {
			var local_options:Options = new Options(options, opts)
			var g:Grawl = new Grawl(msg)
			g.attributes = { alpha:0, x: stage.stageWidth - g.bg.width - local_options.offset*2, y: stage.stageHeight - g.bg.height - local_options.offset*2 -Grawl.count * local_options.offset +10 }
			g.tween( { alpha:1, time: 0.8, transition: Equations.easeOutCubic, y: stage.stageHeight - g.bg.height - local_options.offset*2 -Grawl.count * local_options.offset } )
			stage.addChild(g)
			g.tween( { time: local_options.time, onComplete: Grawl.hide_message, onCompleteParams: [g] } )
			Grawl.count ++ 
		}
		
		static private function hide_message(g:Grawl):void {
			g.tween({ alpha: 0, time:1, onComplete:Grawl.remove_message, onCompleteParams: [g] })
		}
		
		static private function remove_message(g:Grawl):void {
			Grawl.count -- 
			stage.removeChild(g)
		}
	}
	
}