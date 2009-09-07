package framy.graphics {
	import caurina.transitions.Tweener;
	import flash.geom.Rectangle;
	import framy.graphics.fySprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import framy.graphics.fyTextField;
	import framy.utils.Colors;
	import framy.utils.Hash;
	
	/**
     *  Creates an ActionSprite with a text inside, and provides easy "idle" "over" and "selected" animations for it, using Tweener
     *  @author Ivan K (ikerin@gmail.com)
     */
	public class Label extends fySprite{
		private var _selected:Boolean = false
		private var _content:DisplayObject
		private var _hitarea:fySprite
		private var idle:Hash
		private var over:Hash
		private var select:Hash
		private var interactive:Boolean = false
		
		/**
		 *  <p>Creates an ActionSprite with a text inside, and provides easy "idle" "over" and "selected" animations for it, using Tweener.</p>
		 *	<p>Also creates a "hitarea" sprite with the same widht/height as the content, which can later be modified using the hitearea getter</p>
		 *	
		 *  @param	content	DisplayObject, to be added "as is"
		 *  @param	idle	the attributes, passed to tweener on initialize and when in idle mode
		 *  @param	over	the attributes, passed to tweener on mouse over
		 *  @param	select  the attributes, passed to tweener when the "selected" property is set to true
		 *  @see flash.display.DisplayObject flash.display.DisplayObject
		 *	@example Basic usage: <listing version="3.0">
//Create the button content
var content:fyTextField = new fyTextField('norma', { text: 'Simple button' })

//Create a labeled button
var btn = new Label(content, { _brightness: 0 }, { _brightness: 0.5 }, {brightness: -0.3 })

//Increase the button hitarea so it will be easier to press by the user
btn.hitarea.inflate(10,10)
	
//Assign some logic on button press
btn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
  (event.target as Label).selected = true
  trace('button selected!')
})
		 *	</listing>
		 */
		public function Label(content:DisplayObject, idle:Object=null, over:Object=null, select:Object = null) {
			this._content = content
			
			var content_bounds:Rectangle = this.content.getBounds(this)
			this._hitarea = fySprite.newRect( { width: content_bounds.width, height: content_bounds.height}, {alpha: 0, x:content_bounds.x, y:content_bounds.y})
			
			
			this.mouseChildren = false
			this.buttonMode = true
			
			this.addChildren(this._hitarea, this._content)
			if(idle)this.addEventListener(MouseEvent.ROLL_OUT, this.onOut)
			if(over)this.addEventListener(MouseEvent.ROLL_OVER, this.onOver)
			
			if (select) this.select = Colors.convertColors(new Hash({ time: 0.5 } ).merge(select))
			this.idle = Colors.convertColors(new Hash({ time: 0.5 } ).merge(idle))
			this.over = Colors.convertColors(new Hash({ time: 0.5 } ).merge(over))
			
			Tweener.addTween(this._content, this.idle.dup.merge( { time: 0 } ))
		}
		
		/**
		 *	Change the content with another DisplayObject, returns the old content
		 *	@param	new_content	 The new content to replace the old
		 *	@return		The old content DisplayObject
		 */
		public function swapContent(new_content:DisplayObject):DisplayObject {
			this.removeChild(this._content)
			this.addChildAt(new_content, 0)
			var old_content:DisplayObject = this._content
			this._content = new_content
			return old_content
		}
		
		/**
		 *	Returns the content DisplayObject
		 */
		public function get content():DisplayObject { return _content }
		
		
		/**
		 *	Returns the hitarea fySprite (the same width and height as the content). After creation you can modify this, fine-tuning the hitarea
		 */
		public function get hitarea():fySprite { return _hitarea }
		
		public function centerHitarea():Label {
			this.hitarea.pos = this.hitarea.aspect.center(0, 0).pos
			return this
		}
		
		public function inflateHitarea(value:Number):Label {
			this.hitarea.inflate(value, value)
			return this
		}
		
		
		/**
		 *	@private
		 */
		private function onOver(event:MouseEvent):void {
			if(!this._selected)Tweener.addTween(this._content, this.over)
		}
		
		/**
		 *	@private
		 */
		private function onOut(event:MouseEvent):void {
			if(!this._selected)Tweener.addTween(this._content, this.idle)
		}
		
		/**
		 *	<p>When set to true - disables the mouse interaction and tweens to the "selected" state if set.</p>
		 *	<p>When set to false - enables the mouse interaction and tweens to the "idle" state if set.</p>
		 */
		public function get selected():Boolean {
			return this._selected
		}
		
		public function set selected(val:Boolean):void {
			this.mouseEnabled = !val
			this.buttonMode = !val
			if(val != _selected){
				this._selected = val
				
				if (val) Tweener.addTween(this._content, this.select)
				else Tweener.addTween(this._content, this.idle)
			}
		}
		

	}
	
}