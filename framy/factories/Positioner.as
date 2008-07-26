package framy.factories {
	import app.App;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import framy.ActionSprite;
	import framy.events.ActionEvent;
	import framy.loading.ExternalImage;
	import framy.tools.Options;
	import framy.tools.Hash;
	import caurina.transitions.Tweener;
	
	/**
	* This class is used for sinchronizing tweener animations. It calculates the "target" positions and tweens the elements to them.
	* That way (by separating the position generation of the actual tweening), it all becomes much clearer and well-defined.
	* 
	* Extend this class, and override the "calculate" method
	* @author Ivan K
	*/
	public class Positioner extends EventDispatcher{
		public var items:Array
		protected var elem_attributes:Dictionary = new Dictionary(true)
		protected var options:Options
		private var _current:*
		private var _current_index:int
		
		/**
		 * Creates the positioner, assigning it some itmes to position, and gives some default tweeing parameters
		 * you can give supply the positioner with an array of arrays, and each array will be treated as one "group" of items, 
		 * and each item in the group will be assigned the same attributes
		 * @param	items  <Array> the items to be positioned
		 * @param	opts   <Object> a collection of default parameters for the tween function
		 */
		public function Positioner(items:Array, opts:Object = null) {
			this.items = items
			this.options = new Options(opts, { time: 0.5, transition: "easeOutCubic" } )
			for each(var i:* in this.items)this.elem_attributes[i] = new Object()
		}
		
		public function get current_index():int { return this._current_index }
		public function attributes(elem:*):Object { return this.elem_attributes[elem] }
		public function set_attributes(elem:*, attr:Object):Object { return this.elem_attributes[elem] = attr }
		public function get current():* { return this._current }
		public function set current(c:*):* { 
			this._current_index = this.items.indexOf(c)
			return this._current = c
		}
		
		/**
		 * iterate through all elements to the left (smaller index) of the current element.
		 * @param	iterator <Function> a function iterator, has 2 arguments - the item and it's distance from the current element
		 */
		public function all_previous_elems(iterator:Function, scope:*=null):void {
			for ( var i:int = current_index - 1; i >= 0; i-- ) {
				iterator.apply(scope || this, [this.items[i], current_index - i ])
			}
		}
		
		/**
		 * iterate through all elements to the right (bigger index) of the current element.
		 * @param	iterator <Function> a function iterator, has 2 arguments - the item and it's distance from the current element
		 */
		public function all_next_elems(iterator:Function, scope:*=null):void {
			for ( var i:int = current_index + 1; i < this.items.length; i++) {
				iterator.apply(scope || this, [this.items[i], i - current_index ])
			}
		}
		
		/**
		 * Tween all items to their corresponding attributes
		 * @param	opts <Object (default = null)> Additional attributes for the tween
		 */
		public function tween(opts:Object = null):void {
			var local_options:Hash = this.options.dup.merge(opts)
			for each(var p:* in this.items) {
				if(p is Array)for each(var p_elem:* in p)p_elem.tween( new Hash(attributes(p)).merge(local_options))
				else p.tween( new Hash(attributes(p)).merge(local_options))
			}
		}
		
		/**
		 * Check if the animation is in progress
		 * @return	Boolean		true if there is animation in progress, false otherwise
		 */
		public function get active():Boolean {
			return (this.items[0] is Array ? Tweener.getTweenCount(this.items[0][0]) : Tweener.getTweenCount(this.items[0])) > 0
		}
		
		/**
		 * Tween all items to their corresponding attributes (only x and y)
		 * @param	opts <Object (default = null)> Additional attributes for the tween
		 */
		public function tween_pos(opts:Object = null):void {
			var local_options:Hash = this.options.dup.merge(opts)
			for each(var p:* in this.items) {
				if(p is Array)for each(var p_elem:* in p)p_elem.tween( new Hash({x:attributes(p).x, y:attributes(p).y }).merge(local_options))
				else p.tween( new Hash({x:attributes(p).x, y:attributes(p).y }).merge(local_options))
			}
		}
		
		/**
		 * override this function with your own positioning logic
		 * or add an event listener for the ActionEvent.CALCULATE_POSITIONS
		 */
		public function calculate():void {
			this.dispatchEvent(new Event(ActionEvent.CALCULATE_POSITIONS))
		}
		
		/**
		 * Calculate and run the tween function with additional attributes
		 * @param	opts <Object (default = null)> Additional attributes for the tween
		 */
		public function update(opts:Object = null):void {
			this.calculate()
			this.tween(opts)
		}
		
		/**
		 * Change the current item and reposition the items, by tweening to the specified attributes
		 * @param	c  the new current item
		 * @param	opts <Object (default = null)> Additional attributes for the tween
		 */
		public function change_current(c:*, opts:Object = null):void {
			this.current = c
			this.update(opts)
		}
		
		/**
		 * Directly set all the attributes to their corresponding items
		 */
		public function set_all_attributes():void {
			for each(var p:* in this.items) {
				if (p is Array) for each(var p_elem:* in p)p_elem.tween(attributes(p))
				else p.tween(attributes(p))
			}
		}
		
		
	}
	
}