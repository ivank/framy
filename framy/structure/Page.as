package framy.structure 
{
	import caurina.transitions.Tweener;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import framy.animation.TweenGroup;
	import framy.animation.WidgetTween;
	import framy.debug.PagesWindow;
	import framy.utils.ArrayTools;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	import framy.utils.StringTools;
	
	/**
	 *  This class represents a single "page" of the site
	 *	
	 *  @author IvanK (ikerin@gmail.com)
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9
	 */
	public class Page extends EventDispatcher
	{
		private var _widget_views:Array = new Array()
		private var _tweens:Array = new Array()
		private var _name:String
		private var _dispatched_events:Hash = new Hash()
		public var data:Object = { }
		private var _title:String
		private var _parameters:Hash
		private var _partials:Array = new Array()
		
		/**
		 *  @constructor
		 *	@param	name	 	The name of the page - in lowercase, words separated with _ (for example "project_image"). Must be unique
		 *	@param	parameters	Parameters of the page
		 */
		public function Page(name:String, parameters:Object = null) 
		{
			this._name = name
			this._parameters = new Hash(parameters)
		}
		
		override public function dispatchEvent(event:Event):Boolean 
		{
			this._dispatched_events[event.type] = event
			for each (var p:Partial in _partials)p.dispatchEvent(event)
			return super.dispatchEvent(event);
		}
		
		/**
		 *	@private
		 */
		public function dispatchPartialEvent(event:Event):Boolean 
		{
			return super.dispatchEvent(event);
		}
				
		/**
		 *	@private
		 */
		public function dispatchAnonimousEvent(event:Event):Boolean 
		{
			for each (var p:Partial in _partials)p.dispatchEvent(event)
			return super.dispatchEvent(event);
		}
		/**
		 *	Check if a given event has already been dipatched
		 */
		public function eventTriggered(type:String):Boolean {
			return this._dispatched_events.has(type)
		}
		
		public function get name():String{ return _name }
		
		/**
		 *	Add tweens (animations) for widgets on this page. Accepts WidgetTween, TweenGroup and Partial objects
		 */
		public function setTweens(...arguments):void { FunctionTools.flatten_args( setTweens, setTween, arguments ) }
		
		/**
		 *	Adds a single tween (animation) for a widget on the page. Accepts WidgetTween, TweenGroup and Partial objects
		 */
		public function setTween(tween:*):void {
			if (tween is WidgetTween) {
				_tweens.push(tween)
			}else if ( tween is TweenGroup) this.setTweens(tween.tweens) 
			else if ( tween is Partial) {
				this.setTweens(tween.tweens)
				this.addPartial(tween)
			}
		}
		
		/**
		 *	@private
		 */
		private function addPartial(partial:Partial):void {
			if (!ArrayTools.has(_partials, partial)) {
				_partials.push(partial)
				partial.setPage(this)
			}
		}
		
		/**
		 *	Retrieves a partial on this page by class
		 *	@param	cls	 The class of the partial
		 */
		public function getPartial(cls:Class):Partial {
			for each(var p:Partial in _partials) if (p is cls) return p
			return null
		}
		
		/**
		 *	See setWidgetView
		 */
		public function setWidgetViews(...arguments):void {	FunctionTools.flatten_args( setWidgetViews, setWidgetView, arguments) }
		
		/**
		 *	This is used both to add new widgets to a page, alter the condition of existing ones and to remove unwanted widgets.
		 *	If a widget with the provided name does not exist, it will be created. If it already exists, and the provided view
		 *	is different than the existing one, it will be tweened to that view. 
		 *	If a widget already exits (from a previous page), but is not specified, it will be tweened to a special "destroy" view
		 *	on the end of which it'll be removed.
		 */
		public function setWidgetView(widget:*):void {
			if (widget is WidgetView) {
				_widget_views.push(widget)
			}else if (widget is Partial) {
				_widget_views = _widget_views.concat((widget as Partial).widget_views);
				_tweens = _tweens.concat((widget as Partial).tweens);
				this.addPartial(widget)
			}
		}
		
		protected function setTitle(str:String):void { this._title = str }
		
		public function get title():String { return _title }
		
		/**
		 *	@private
		 */
		static public function transition(from_page:Page, to_page:Page):void {
			applyAnimation(to_page._widget_views, to_page, from_page)
			RootWidgetContainer.instance.change(to_page._widget_views)
		}
		
		/**
		 *	@private
		 */
		static public function create(page_name:String, parameters:Object = null):Page {
			return new (getDefinitionByName('app.pages.' + StringTools.classify(page_name)+'Page') as Class)(page_name, parameters)
		}
		
		/**
		 *	@private
		 */
		public function applyAnimationFor(view:WidgetView, from_page:Page = null):void {
			for each( var tween:WidgetTween in this._tweens) {
				if (tween.isFrom(from_page ? from_page._name : null, from_page ? from_page._parameters : null) && tween.appliesToView(view)) view.setTween(tween)
			}
		}
		
		/**
		 *	@private
		 */
		static private function applyAnimation(views:Array, to_page:Page, from_page:Page):void {
			for each (var widget_view:WidgetView in views) {
				to_page.applyAnimationFor(widget_view, from_page)
				applyAnimation(widget_view.child_views, to_page, from_page)
			}
		}

	}
	
}