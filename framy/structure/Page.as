package framy.structure 
{
	import caurina.transitions.Tweener;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import framy.animation.Animation;
	import framy.animation.AnimationGroup;
	import framy.debug.PagesWindow;
	import framy.errors.PageError;
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
		private var _animations:Array = new Array()
		private var _name:String
		private var _dispatched_events:Hash = new Hash()
		public var data:Object = { }
		private var _title:String
		private var _parameters:Hash
		private var _partials:Array = new Array()
		private var _animations_on_event:Object = {}
		
		/**
		 *  @constructor
		 */
		public function Page(){}

		/**
		 *	@param	name	 	The name of the page - in lowercase, words separated with _ (for example "project_image"). Must be unique
		 *	@param	parameters	Parameters of the page
		 */
		public function setParams(name:String, parameters:Object = null):Page {
			this._name = name
			this._parameters = new Hash(parameters)
			return this
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
		public function setAnimations(...arguments):void { FunctionTools.flatten_args( setAnimations, setAnimation, arguments ) }
		
		/**
		 *	Adds a single tween (animation) for a widget on the page. Accepts WidgetTween, TweenGroup and Partial objects
		 */
		public function setAnimation(animation:*):void {
			if (animation is Animation) {
				_animations.push(animation)
			}else if ( animation is AnimationGroup) this.setAnimations(animation.animations) 
			else if ( animation is Partial) {
				this.setAnimations(animation.animations)
				this.addPartial(animation)
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
		 *	@see framy.structure.Page#setElement
		 */
		public function setElements(...arguments):void {	FunctionTools.flatten_args( setElements, setElement, arguments) }
		
		/**
		 *	This is used both to add new widgets to a page, alter the condition of existing ones and to remove unwanted widgets.
		 *	If a widget with the provided name does not exist, it will be created. If it already exists, and the provided view
		 *	is different than the existing one, it will be tweened to that view. 
		 *	If a widget already exits (from a previous page), but is not specified, it will be tweened to a special "destroy" view
		 *	on the end of which it'll be removed.
		 */
		public function setElement(element:*):void {
			if (element is WidgetView) {
				_widget_views.push(element)
			}else if (element is Partial) {
				_widget_views = _widget_views.concat((element as Partial).widget_views);
				_animations = _animations.concat((element as Partial).animations);
				this.addPartial(element)
			}
		}
		
		protected function getElements():Array {	return this._widget_views }
		
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
			try{
				return (new (getDefinitionByName('app.pages.' + StringTools.classify(page_name) + 'Page') as Class)).setParams(page_name, parameters)
			}catch (error:ReferenceError) {
				throw new PageError('The page you are trying to access - ' + StringTools.classify(page_name) + 'Page has not been added and/or imported yet')
			}
			return null
		}
		
		/**
		 *	@private
		 */
		public function applyAnimationFor(view:WidgetView, from_page:Page = null):void {
			this._animations_on_event = { }
			
			for each( var animation:Animation in this._animations) {
				if (animation.isFrom(from_page ? from_page._name : null, from_page ? from_page._parameters : null) && animation.appliesToView(view)) {
					view.setAnimation(animation)
				}
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