package framy {
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import framy.tools.Hash;
	import framy.tools.Options;
	import flash.utils.setTimeout;
	import framy.loading.I18n;
	import flash.display.DisplayObject;

	/**
	* This class adds additional functionality to the TextField class, like adding a easy to define sets of attributes for texts
	* (a bit like css), and providing some helper methods
	* 
	* the sets of attribtes are called "formats" and should be defined at the start of the application, through the 
	* 'create_formats' static function. it accepts a hash (name -> options). If an option is 'align', 'bold', 'color' or another
	* option from TextFormat class, it will be applied as such, otherwise it is applied directly on the ActionText object (like 'x', 'y' ...)
	* there are some special options
	* 	* css  Hash/String  iether a string with css text in it, or a hash with css 'key: value' options.
	* 	* i18n  Array - used to set i18n text. Its applied directly through I18n._() function, check that for referance
	* 	* children  A hash of other formats, which inherit all of their parents' options ( if the css is a hash, it is merged )
	* @author Ivan K
	*/	
	public class ActionText extends TextField{
		static private var _formats:Hash = new Hash()
		static private const FORMAT_TEXT_OPTIONS:Array = ['align', 'blockIndent', 'bold', 'bullet', 'color', 'font', 'indent', 'italic', 'kerning', 'leading', 'leftMargin', 'letterSpacing', 'rightMargin', 'size', 'tabStops', 'target', 'underline', 'url']
		
		static public function get formats():Hash { return _formats }
		/**
		 * Accepts a hash (name -> options). If an option is 'align', 'bold', 'color' or another
		 * option from TextFormat class, it will be applied as such, otherwise it is applied directly on the ActionText object (like 'x', 'y' ...)
		 * there are some special options
		 * 	* css  Hash/String  iether a string with css text in it, or a hash with css 'key: value' options.
		 * 	* i18n  Array - used to set i18n text. Its applied directly through I18n._() function, check that for referance
 		 * 	* children  A hash of other formats, which inherit all of their parents' options ( if the css is a hash, it is merged )
		 * @param	new_formats
		 * @param	base
		 */
		static public function create_formats(new_formats:Object, base:Object = null):void {
			for (var format_name:String in new_formats) {
				base = base || { }
				var children:Object = new_formats[format_name].children
				if (children) delete new_formats[format_name].children
				_formats[format_name] = new Hash(base).merge(new_formats[format_name])
				if(children)create_formats(children, _formats[format_name])
			}
		}
		
		public function ActionText(opts:Object = null) {
			var options:Options = new Options(opts, (opts.format && formats[opts.format]) ? formats[opts.format] : {})
			delete options.format
			
			var text_var:String = (options.css || options.html) ? "htmlText" : "text" 
			
			if (options.i18n) {
				options[text_var] = I18n.add(this, options.i18n, text_var == "htmlText")
			}
			
			if (options.css) {
				var css:StyleSheet = new StyleSheet()
				if (css is String) css.parseCSS(options.css)
				else for (var name:String in options.css) css.setStyle(name, options.css[name])
				this.styleSheet = css
			}
			if(options.html != undefined)delete options.html
			if(options.css != undefined)delete options.css
			if(options.i18n != undefined)delete options.i18n
			
			var text_options:Hash = options.diff(options.with_keys(FORMAT_TEXT_OPTIONS)).diff(new Hash({width:100,height:100,'text':'text', 'htmlText':'htmlText'}))
			for (var i:String in text_options) this[i] = text_options[i]
			
			if (!this.styleSheet) {
				var fmt:TextFormat = new TextFormat(options.font, options.size, options.color, options.bold, options.italic, options.underline, options.url, options.target, options.align, options.leftMargin, options.rightMargin, options.indent, options.leading)
				this.defaultTextFormat = fmt
			}
			if (options[text_var]) this[text_var] = options[text_var]
			if (options.width) this.width = options.width
			if (options.height) this.height = options.height
		}
		
		public function set attributes(attrs:Object):*{
			for(var attr:String in attrs)this[attr] = attrs[attr]
			return attrs
		}
		
		public function get translated():Boolean {
			return I18n.translated(this)
		}
		
		public function tween(options:Object):Boolean{  return Tweener.addTween(this,options)  }
		public function dispatchAfter(delay:Number,event:Event):int{
			return setTimeout(this.onDispatchAfterReached,delay*1000,event)
		}
		
		private function onDispatchAfterReached(event:Event):void { this.dispatchEvent(event) }
		
		/**
		 * Easyly modify the x within the scrollRect
		 */
		public function set scrollRectX(new_x:Number):*{
			var r:Rectangle = scrollRect
			r.x = new_x
			this.scrollRect = r
			return new_x
		}
		
		/**
		 * Easyly modify the y within the scrollRect
		 */
		public function set scrollRectY(new_y:Number):*{
			var r:Rectangle = scrollRect
			r.y = new_y
			this.scrollRect = r
			return new_y
		}		
		
		/**
		 * Simultaniously set x and y with an array ( [x,y] )
		 */
		public function set pos(p:Array):*{	return [this.x = p[0], this.y = p[1]] }
		/**
		 * Get the x and y in an array ( [x,y] )
		 */
		public function get pos():Array{ return [this.x,this.y]	}
		
		/**
		 * sets the width and hight with an array ( [width, height] )
		 */
		public function set dims(d:Array):*{ return [this.width = d[0], this.height = d[1]] }
		
		/**
		 * get the width and hight with an array ( [width, height] )
		 */
		public function get dims():Array{ return [this.width,this.height] }
		
		public function bringToFront():void {
			this.parent.setChildIndex(this,this.parent.numChildren - 1);
		}
		
		public function bringUnder(child:DisplayObject):void {
			this.parent.setChildIndex(this, this.parent.getChildIndex(child)-1)
		}
		
		public function bringOnTopOf(child:DisplayObject):void {
			this.parent.setChildIndex(this, this.parent.getChildIndex(child))
		}
		
		public function bringToBack():void {
			this.parent.setChildIndex(this,0)
		}
		/**
		 * returns the height of the text for a certain width, when autoSize and multiline are true
		 * @param	new_width
		 */
		public function height_for_width(new_width:uint):uint {
			var old_width:uint = this.width
			this.width = new_width
			var new_height:uint = this.height
			this.width = old_width
			return new_height			
		}
	}
	
}
