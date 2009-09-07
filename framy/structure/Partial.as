package framy.structure 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.animation.Animation;
	import framy.utils.FunctionTools;
	import framy.animation.AnimationGroup;
	
	/**
	 *  A collection of widget views and tweens - when added to the page (using hte setWidgetView method) wll add
	 *	all of its tweens and views to the page.
	 *	Also recieves all the events of the page, and all dispatchedEvents are also sent to the parent page
	 *  @author IvanK (ikerin@gmail.com)
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9
	 */
	public class Partial extends EventDispatcher
	{
		private var _widget_views:Array = new Array()
		private var _animations:Array = new Array()
		private var _page:Page
		
		public function Partial() 
		{
			
		}
		
		override public function dispatchEvent(event:Event):Boolean 
		{
			this.page.dispatchPartialEvent(event)
			return super.dispatchEvent(event);
		}
		
		public function setAnimations(...arguments):void { FunctionTools.flatten_args( setAnimations, setAnimation, arguments ) }
		
		public function setAnimation(anim:*):void {
			if (anim is Animation) {
				_animations.push(anim)
			}else if ( anim is AnimationGroup) this.setAnimations(anim.animations) 
			else if ( anim is Partial){
				anim.setPage(this.page)
				this.setAnimations(anim.animations)
			} 
		}
		
		public function setElements(...arguments):void {	FunctionTools.flatten_args( setElements, setElement, arguments) }
		
		public function setElement(element:*):void {
			
			if (element is WidgetView) {
				_widget_views.push(element)
			}else if (element is Partial) {
				_widget_views = _widget_views.concat((element as Partial).widget_views);
				element.setPage(this.page)
				_animations = _animations.concat((element as Partial).animations);
			}
		}
		
		/**
		 *	@private
		 */
		public function setPage(page:Page):void {
			this._page = page
		}
		/**
		 *	@private
		 */
		public function get widget_views():Array { return _widget_views; }
		
		/**
		 *  Returns all the tweens(groops and other partials) of this partial
		 *	@private
		 */
		public function get animations():Array { return _animations; }
		
		/**
		 *	Returns the parent page 
		 */
		public function get page():Page { return _page; }
		
	}
	
}