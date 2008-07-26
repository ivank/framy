package framy {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import framy.events.ActionEvent;
	import framy.events.ChangeStartEvent;
	import framy.loading.I18n;
	import framy.tools.Hash;
	import framy.tools.Options;
	import caurina.transitions.Tweener;
	
	/**
	* Creates an ActionSprite with a text inside, and provides easy "idle" "over" and "selected" animations for it, using tweener
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Label extends ActionSprite{
		private var _selected:Boolean = false
		protected var title:DisplayObject
		protected var hitarea:Rect
		private var idle:Options
		private var over:Options
		private var select:Options
		private var interactive:Boolean = false
		
		/**
		 * Creates an ActionSprite with a text inside, and provides easy "idle" "over" and "selected" animations for it, using tweener
		 * @param	opts	Either a DisplayObject, to be added "as is", or an object, using which an ActionText instance will be created
		 * @param	idle	the attributes, passed to tweener on initialize and when in idle mode
		 * @param	over	the attributes, passed to tweener on mouse over
		 * @param	select  the attributes, passed to tweener when the "selected" property is set to true
		 */
		public function Label(opts:*, idle:Object=null, over:Object=null, select:Object = null) {
			if (opts is DisplayObject)this.title = opts
			else this.title = new ActionText(opts)
			
			this.hitarea = new Rect( { dims: [this.title.width, this.title.height] , alpha: 0 } )
			
			if (this.title is ActionText && (this.title as ActionText).translated) {
				(this.title as ActionText).addEventListener(ActionEvent.I18N_CHANGE, this.onLangChanged)
				
			}
			this.mouseChildren = false
			this.buttonMode = true
			
			this.addChildren(this.title, this.hitarea)
			if(idle)this.addEventListener(MouseEvent.ROLL_OUT, this.onOut)
			if(over)this.addEventListener(MouseEvent.ROLL_OVER, this.onOver)
			if (select) this.select = new Options(select, { time: 0.5 } );
			
			this.idle = new Options(idle, { time: 0.5 } )
			this.over = new Options(over, { time: 0.5 } )
			
			Tweener.addTween(this.title, this.idle.dup.merge( { time: 0 } ))
		}
		
		public function set content_width(width:uint):* { this.title.width = width }
		public function get content_width():uint {	return this.title.width }
		
		public function set content_height(height:uint):* {	this.title.height = height	}
		public function get content_height():uint {	return this.title.height }
		
		
		private function onLangChanged(event:ChangeStartEvent):void {
			this.hitarea.dims = [event.new_width, event.new_height];
			this.dispatchEvent(event.clone())
		}
		
		private function onOver(event:MouseEvent):void {
			if(!this._selected)Tweener.addTween(this.title, this.over)
		}
		
		private function onOut(event:MouseEvent):void {
			if(!this._selected)Tweener.addTween(this.title, this.idle)
		}
		
		public function get selected():Boolean {
			return this._selected
		}
		
		public function set selected(val:Boolean):* {
			if(val != _selected){
				this._selected = val
				this.mouseEnabled = !val
				this.buttonMode = !val
				
				if (val) Tweener.addTween(this.title, this.select)
				else Tweener.addTween(this.title, this.idle)
			}
			return val
		}
	}
	
}