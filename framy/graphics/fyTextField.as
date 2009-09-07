package framy.graphics 
{
import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import framy.model.Model;
	import framy.routing.Router;
	import framy.structure.Initializer;
	import framy.utils.Colors;
	import framy.utils.Hash;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import framy.events.LanguageChangeEvent;
	
	/**
	 * Adds some functionality to the TextField class - easy formatting, styles and html assignment.
	 * @author IvanK (ikerin@gmail.com)
	 */
	dynamic public class fyTextField extends TextField
	{
		include './Position.mixin'
		include './VerticalPosition.mixin'
		
		static private const FORMAT_TEXT_OPTIONS:Array = ['align', 'blockIndent', 'bold', 'bullet', 'color', 'font', 'indent', 'italic', 'kerning', 'leading', 'leftMargin', 'letterSpacing', 'rightMargin', 'size', 'tabStops', 'target', 'underline', 'url']		
		/**
		 *	@private
		 */
		static public var _fonts:Hash = new Hash()
		private var _textFormat:TextFormat
		private var _styleSheet:StyleSheet
		private var i18n_content:XMLList
		private var culture:String = Router.culture
		private var _html:Boolean = false
	  
		/**
		 *	@private
		 */
		static public function setFont(name:String, properties:Hash):void{
		  _fonts[name] = properties
		}
		
		/**
		 *	<p>Creates a new fyTextField, using a tree of inheritence for text formating parameters.
		 *	You should first define those parameters at the start of the application. (in the Initializer)</p>
		 *	
		 *	
		 *	<p>If you need to tweak the parameters for a specific case you can override them with the third parameter</p>
		 *	@param	font	 The name of the parameters collection, defined in the Initializer
		 *	@param	attributes	 Attributes assigned after the creation of the fyTextField, for example text, height, etc...
		 *	@param	custom_options	 Overloads for the parameter colleciton
		 *	@constructor
		 *	@see framy.structure.Initializer#setFonts Initializer.setFonts
		 */
		public function fyTextField(font:String, attributes:Object=null, custom_options:Object=null) 
		{
			var options:Hash = new Hash(_fonts[font]).merge(custom_options)
			var format_options:Hash = new Hash(options).diff({css:true})
		  
			if (options.css) {
				var css:StyleSheet = new StyleSheet()
				
				for (var name:String in options.css) {
					var css_options:Hash = Colors.convertColors(format_options.withKeys(FORMAT_TEXT_OPTIONS).merge(options.css[name]), Colors.TYPE_HTML)
					if (css_options.font) 		{ css_options.fontFamily = css_options.font;		delete css_options.font }
					if (css_options.size) 		{ css_options.fontSize = css_options.size;			delete css_options.size }
					if (css_options.bold) 		{ css_options.fontWeight = 'bold';					delete css_options.bold }
					if (css_options.italic) 	{ css_options.fontStyle = 'italic';					delete css_options.italic }
					if (css_options.align) 		{ css_options.textAlign = css_options.align;		delete css_options.align }										
					if (css_options.underline) 	{ css_options.textDecoration = 'underline';			delete css_options.align }
					
					css.setStyle(name, css_options)
				}
				this._styleSheet = css
				this.styleSheet = css
			}
			
			var fmt:TextFormat = new TextFormat(options.font, options.size, Colors.get(options.color), options.bold, options.italic, options.underline, options.url, options.target, options.align, options.leftMargin, options.rightMargin, options.indent, options.leading)
			this._textFormat = fmt
			if(!this.styleSheet){
				this.setTextFormat(fmt)
				this.defaultTextFormat = fmt
			}
			var text_field_attrs:Hash = format_options.withoutKeys(FORMAT_TEXT_OPTIONS).merge(attributes)
			this.attrs = Colors.convertColors(text_field_attrs.withoutKeys(['text', 'htmlText', 'i18nText']))
			this.attrs = text_field_attrs.withKeys(['text', 'htmlText', 'i18nText'])
			super()
			
			if (Initializer.options.i18n && this.i18n_content && Initializer.options.i18n.auto_change) {
				Router.addEventListener(LanguageChangeEvent.START, this.onLanguageChange, false, 0, true);
			}
		}
		
		private function onLanguageChange(event:LanguageChangeEvent):void
		{
			this.culture = Router.culture
			this.dispatchEvent(event.clone())
			
			this.tween(new Hash(Initializer.options.i18n.tween).merge( { 
				_text: this.i18nTextForCulture(this.culture), 
				onComplete:function():void {
					this.dispatchEvent(new LanguageChangeEvent(LanguageChangeEvent.FINISH))
				}
			}))
			
		}
		
		/**
		 *	A proxy for Tweener.addTween(this, arguments)
		 *	@param	arguments	 Fashes of parameters for the tween, each one is merged with the next
		 *	@return		Returns itslef
		 */		
		public function tween(...arguments):fyTextField {
			var parameters:Hash = new Hash()
			for each( var parameters_elem:Object in arguments) parameters.merge(parameters_elem);
			Tweener.addTween(this, Colors.convertColors(parameters))
			return this
		}
		
		/**
		 *	A proxy for Tweener.removeTweens(this, params)
		 *	@return		Returns itslef
		 */		
		public function removeTweens(params:Object = null):fyTextField {
			Tweener.removeTweens(this, params)
			return this
		}		
		
		/**
		 *	If a stylesheet has been set, removes it and applies default formating
		 *	@param	value	 The new text
		 */
		override public function set text(value:String):void 
		{
			if (this._html)super.htmlText = value
			else {
				if (this.styleSheet) {
					this.styleSheet = null
					this.defaultTextFormat = this._textFormat
				}
				super.text = value;
			}
		}
		
		public function set html(value:Boolean):void {
			this._html = value
			if (this._html) {
				if (!this.styleSheet && this._styleSheet) {
					this.styleSheet = this._styleSheet
				}
			}else {
				if (this.styleSheet) {
					this.styleSheet = null
					this.defaultTextFormat = this._textFormat
				}
			}
		}
		
		public function get html():Boolean { return this._html }
		
		/**
		 *	If it has a stylesheet, enables it and removes default formating
		 */
		override public function set htmlText(value:String):void 
		{
			this.html = true
			super.htmlText = value;
		}
		
		public function set i18nText(value:XMLList):void {
			this.i18n_content = value
			
			this.text = this.i18nTextForCulture(this.culture)
		}
		
		public function get i18nText():XMLList {
			return this.i18n_content
		}
		
		public function i18nTextForCulture(culture:String):String {
			return Model.i18nIext(this.i18n_content, culture)
		}
		
		/**
		 *  returns the height of the text for a certain width, when autoSize and multiline are true
		 *  @param	new_width
		 *  @return		The height based on the given width
		 */
		public function getHeightForWidth(new_width:uint):uint {
			var old_width:uint = this.width
			this.width = new_width
			var new_height:uint = this.height
			this.width = old_width
			return new_height			
		}
		
	}
	
}