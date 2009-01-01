package framy.structure 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.animation.TweenGroup;
	import framy.utils.FunctionTools;
	import framy.animation.WidgetTween;
	
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
		private var _tweens:Array = new Array()
		private var _page:Page
		
		public function Partial() 
		{
			
		}
		
		override public function dispatchEvent(event:Event):Boolean 
		{
			this.page.dispatchPartialEvent(event)
			return super.dispatchEvent(event);
		}
		
		public function setTweens(...arguments):void { FunctionTools.flatten_args( setTweens, setTween, arguments ) }
		
		public function setTween(tween:*):void {
			if (tween is WidgetTween) {
				_tweens.push(tween)
			}else if ( tween is TweenGroup) this.setTweens(tween.tweens) 
			else if ( tween is Partial){
				tween.setPage(this.page)
				this.setTweens(tween.tweens)
			} 
		}
		
		public function setWidgetViews(...arguments):void {	FunctionTools.flatten_args( setWidgetViews, setWidgetView, arguments) }
		
		public function setWidgetView(widget:*):void {
			if (widget is WidgetView) {
				_widget_views.push(widget)
			}else if (widget is Partial) {
				_widget_views = _widget_views.concat((widget as Partial).widget_views);
				widget.setPage(this.page)
				_tweens = _tweens.concat((widget as Partial).tweens);
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
		public function get tweens():Array { return _tweens; }
		
		/**
		 *	Returns the parent page 
		 */
		public function get page():Page { return _page; }
		
	}
	
}