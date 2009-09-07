package framy.structure 
{
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	import framy.utils.CustomEasings;
	
	import framy.errors.AbstractMethodError;
	import framy.graphics.fyTextField;
	import framy.utils.Hash;
	
	/**
	 * Extend this class to create a starting point for your application
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Initializer extends Sprite
	{
		static private var _options:Hash = new Hash({
			resize: { tween: { transition: 'easeInOutSine', time: 0.6 }, wait: 0.3, parameters: [], default_parameters: ['x', 'y', 'width', 'height', 'scaleX', 'scaleY'] },
			auto_change_events: true, 
			color: 'black',
			i18n: {
				auto_change: true, 
				tween: { time: 1, transition: 'easeOutCubic' }
			},
			text: { 
				normal: { embedFonts:true, autoSize: TextFieldAutoSize.LEFT, selectable: false, font: 'NormalFont', color: 'red', antiAliasType: AntiAliasType.ADVANCED, gridFitType: GridFitType.PIXEL },
				bold: { font: 'BoldFont', bold: true },
				text: { wordWrap: true, multiline: true, condenseWhite:true },
				pixel: { font: 'PixelFont', antiAliasType: AntiAliasType.NORMAL, gridFitType: GridFitType.NONE },
				input: { autoSize: TextFieldAutoSize.NONE, type: TextFieldType.INPUT, selectable: true }
			},
			default_tween: { transition: 'easeOutCubic' },
			grawl: {
				color: 0xAAAAAA,
				bg_color: 0x000000,
				width: 400,
				padding: 20,
				corner: 10,
				time: 5,
				tween_in: { time: 0.8, transition: 'easeOutSine' },
				tween_out: { time: 0.8, transition: 'easeOutSine' }
			},
			debug: {
				show_masks: false,
				bg_color: 0xE3CB73,
				btn_color: 0x548648,
				btn_border_color: 0x406837,
				memory_resolution: 60,  
				text_font: { embedFonts:false, autoSize: TextFieldAutoSize.NONE, size: 10, selectable: false, font: 'Arial', color: 0x121F10, antiAliasType: AntiAliasType.ADVANCED, gridFitType: GridFitType.PIXEL }
			}
		}) 
		static private var _widget_contents:Dictionary = new Dictionary(true)
		static private var _widgets_count:uint = 0
		
		
		public function Initializer():void 
		{
			if (stage) _init();
			else addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		/**
		 *	Change various options for the application. The options are a hash that can be changed selectively. Here is a list of options:
		 *	<ul>
		 *		<li>resize - a hash with
		 *			<ul>
		 *				<li>tween - merged with the tween at resizing, default is { transition: 'easeInOutSine', time: 0.6 }</li>
		 *				<li>wait - wait before the resize tween is executed - somoother result for webkit browsers</li>
		 *			</ul>
		 *		</li>
		 *		<li>i18n - a hash with
		 *			<ul>
		 *				<li>tween - the tween of automatic change of text when fy_culture has been changed, default is { time: 0.5, transition: 'easeOutSine' }</li>
		 *				<li>auto_change - change the text when fy_culture has been changed in the routing</li>
		 *			</ul>
		 *		</li>
		 *		<li>default_tween - this is added to all page transitions, defaults to { transition: 'easeOutCubic' }</li>
		 *		<li>grawl - a hash that controls the grawl message shower
		 *			<ul>
		 *				<li>color - the color of the text</li>
		 *				<li>bg_color - the color of the background</li>
		 *				<li>width</li>
		 *				<li>padding</li>
		 *				<li>corner - the radius of the round corner</li>
		 *				<li>time - the time the message stays on the screen</li>
		 *				<li>tween_in - show animation</li>
		 *				<li>tween_out - hide animation</li>
		 *			</ul>
		 *		</li>
		 *		<li>debug - a hash for configuring the DebugPanel
		 *			<ul>
		 *				<li>show_masks - when true - all masks set by "MaskableSprite" will be visible</li>
		 *				<li>bg_color - the background color of the windows</li>
		 *				<li>btn_color - the background color of the buttons</li>
		 *				<li>btn_border_color</li>
		 *				<li>memory_resolution - how many points of memory mesurment</li>
		 *				<li>text_font - a hash with options for the text</li>
		 *			</ul>
		 *		</li>
		 *	</ul>
		 *	@example Basic usage: <listing version="3.0">
this.setOptions({
  resize: { tween: { time:3 } },
  debug: { show_masks:true, text_font: { size: 12 }}
})
		 *	</listing>
		 */
		protected function setOptions(options:Object = null):void {
			Initializer._options.merge(options)
		}
		
		/**
		 *	Configure the fonts with a hash. The base configuration is called "normal", every other inherits it. If the key ends with _pixel, _input, _bold or _text, they recieve some default settings.
		 *	The 'normal' config has those default parameters: { embedFonts:true, autoSize: TextFieldAutoSize.LEFT, selectable: false, font: 'NormalFont', color: 'red', antiAliasType: AntiAliasType.ADVANCED, gridFitType: GridFitType.PIXEL }
		 *	The other postfixes have these defaults (merged with 'normal'):
		 *	<ul>
		 *		<li>_pixel: { font: 'PixelFont', antiAliasType: AntiAliasType.NORMAL, gridFitType: GridFitType.NONE }</li>
		 *		<li>_input: { autoSize: TextFieldAutoSize.NONE, type: TextFieldType.INPUT, selectable: true }</li>
		 *		<li>_bold: { font: 'BoldFont', bold: true }</li>
		 *		<li>_text: { wordWrap: true, multiline: true, condenseWhite:true }</li>
		 *	</ul>
		 *	To define properties of html text, you can use the css property - a hash style css setting. It inherits the normal settings.
		 *	@example Basic usage: <listing version="3.0">
this.setFonts( {
  normal: {  antiAliasType: AntiAliasType.NORMAL, size: 9, color: 'white', font: 'Volter (Goldfish)_9pt_st'  },
  title: { font: 'TitleFont', size:42, antiAliasType: AntiAliasType.ADVANCED },
  title_text: { color: 'black', size: 9 }
} )
		 *	</listing>
		 *	@example CSS usage: <listing version="3.0">

this.setFonts( {
  normal: {  antiAliasType: AntiAliasType.NORMAL, size: 9, color: 'white', font: 'Volter (Goldfish)_9pt_st'  },
  normal_text: { 
    css: { 
      p: {}, 
      a: { color: 'active' }, 
      strong: { color:'active',display:'inline', font: "Volter (Goldfish)_9pt_st", fontWeight: 'bold' }
    }
  }
} )
		 *	</listing>
		 */
		protected function setFonts(fonts:Object):void {
			for (var font_name:String in fonts) {
				var font_options:Hash = new Hash(options.text.normal).merge(fonts['normal'])
				if ( font_name.match(/^.*_(pixel|input|bold|text)$/)) font_options.merge(options.text[font_name.match(/^.*_(pixel|input|bold|text)$/)[1]])
				font_options.merge(fonts[font_name])
				fyTextField.setFont(font_name, font_options)
			}
		}
		
		static public function get options():Hash{
			return _options
		}
		
		private function _init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			// entry point
			new RootWidgetContainer(this)
			CustomEasings.init()
			this.init();
			Tweener.addTween(this, { time: 0.1, onComplete: function():void { RootWidgetContainer.resizeAll() } } )
		}
		
		/**
		 *	@private
		 */
		static public function registerWidgetContent(widget:Widget, content:*):void{ _widget_contents[content] = widget; _widgets_count++ }
		
		/**
		 *	@private
		 */
		static public function removeWidgetContent(content:*):void{ delete _widget_contents[content]; _widgets_count--	}
		
		/**
		 *	@private
		 */
		static public function getWidget(content:*):Widget{ return _widget_contents[content] }
		
		/**
		 *	@private
		 */
		static public function getWidgetsCount():uint{ return _widgets_count }
		
		/**
		 * Abstract method - override in Main
		 */
		protected function init():void{ throw new AbstractMethodError() }
		
	}
	
}