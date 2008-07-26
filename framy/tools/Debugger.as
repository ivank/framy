package framy.tools {
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.system.System;
	import framy.ActionSprite;
	import framy.ActionText;
	import framy.graphics.Colors;
	import framy.Rect;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.utils.setInterval;
	
	/**
	* ...
	* @author Ivan K
	*/
	public class Debugger extends ActionSprite{
		static private var stage:Stage
		static private var options:Options
		
		private var bg:Rect
		private var text:ActionText
		private var gc:Rect
		
		public function Debugger() {
			var text_format:Object = { 
				font: Debugger.options.font, 
				embedFonts: options.font == "Arial" ? false : true , 
				autoSize: TextFieldAutoSize.LEFT,
				antiAliasType: AntiAliasType.ADVANCED,
				gridFitType: GridFitType.PIXEL,
				wordWrap: true,
				selectable: false,
				color: Debugger.options.color, 
				size: 14
			}
			this.text = new ActionText(new Hash(text_format).merge({ 
				multiline: true,
				width: Debugger.options.width - 2 * Debugger.options.padding, 
				x: Debugger.options.padding+16, y:Debugger.options.padding
			}))
			this.bg = new Rect( { width: Debugger.options.width, height: 14 + 2 * Debugger.options.padding, color:Debugger.options.bg_color, line: { color:Debugger.options.color, width:1 } } )
			setInterval(this.onTick, 300)
			
			this.gc = new Rect( { size: 16 } )
			this.gc.attributes = { x: Debugger.options.padding, y: Debugger.options.padding, buttonMode:true, mouseChildren: false }
			this.gc.addChild(new ActionText(new Hash(text_format).merge( { x:1, y: -1, text:'gc', size:10 } )))
			this.gc.addEventListener( MouseEvent.CLICK, this.onGcClick)
			this.addChildren(this.bg, this.text, this.gc)
		}
		
		private function onTick():void {
			this.text.text = System.totalMemory/1024+"KB"
		}
		
		private function onGcClick(event:MouseEvent):void {
			System.gc()
		}
		
		static public function init(stage:Stage, opts:Object = null):void {
			options = new Options(opts, { font: 'Arial', width: 130, padding:10, bg_color:Colors.WHITE, color: Colors.BLACK } )
			stage.addChild(new Debugger())
		}
		
	}
	
}