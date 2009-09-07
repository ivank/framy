package framy.structure 
{
	import caurina.transitions.Tweener;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import framy.animation.Sequence;
	import framy.events.ChangeEvent;
	import framy.events.WidgetLoaderEvent;
	import framy.utils.ArrayTools;
	import framy.utils.FunctionTools;
	import framy.routing.Router;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import framy.utils.Hash;
	import framy.utils.StringTools;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Widget 
	{
		private var _name:String
		private var _parameters:Hash
		private var _content:*
		private var _current_view:WidgetView
		private var _path:String
		private var _container:WidgetContainer
		private var _widgets:WidgetContainer
		private var _cached_attributes:Hash = new Hash()
		private var _cached_animation:Sequence
		private var _views_history:Array = []
		private var _loader:String
		
		public function Widget(container:WidgetContainer, name:String, parameters:Object = null) 
		{
			this._name = name
			this._path = name.replace(/\{[^\}]*\}/,'')
			this._parameters = new Hash(parameters)
			this._container = container
			
		}
		
		public function equals(widget:Widget):Boolean {
			return this._name == widget._name && this._parameters.equals(widget._parameters)
		}
		
		public function get unique_id():String {
			return this._path+(this.parameters.isEmpty() ? '' : '_'+this.parameters.toId())
		}
		
		public function get name():String {	return this._name }
		public function get full_name():String { return this._container.parent_widget ? this._container.parent_widget.full_name+'.'+this._name : this._name }
		
		public function get parameters():Hash { return this._parameters }
		public function get current_view():WidgetView { return this._current_view }
		public function get widget_class():Class {
			try{
				return getDefinitionByName(this._container.path + '.' + this._path + '.' + StringTools.classify(this._path)) as Class
			}catch ( error:Error ) {
				throw new Error ("A widget with the path "+this._container.path + '.' + this._path + '.' + StringTools.classify(this._path)+' was not found')
			}
			return null
		}
		
		public function get contentWidth():*{ return this.getContentAttribute('width')}
		public function get contentHeight():*{ return this.getContentAttribute('height') }
		
		public function createContent():DisplayObject {
			RootWidgetContainer.addEventListener(Event.RESIZE, this.onResize)
			RootWidgetContainer.addEventListener(RootWidgetContainer.START_RESIZE, this.onResizeStart)
			
			_content = FunctionTools.newWithArguments(this.widget_class)
		  
			this._widgets = new SpriteWidgetContainer(_content as Sprite, this._container.path+'.'+this._name, this)
			Initializer.registerWidgetContent(this, _content)
			return _content
		}
		
		public function get container():WidgetContainer { return this._container }
		public function get widgets():WidgetContainer { return this._widgets }
		
		
		public function getPrevious(back_count:uint):Widget {
			return this.container.getPrevious(this,back_count)
		}
		
		public function getParent():Widget {
			return this.container.parent_widget
		}
		
		public function getSibling(id:String):Widget {
			return this.container.getWidgetForId(id)
		}
		
		public function destroyContent():void {
			if (this._content) {
				Initializer.removeWidgetContent(_content)
				RootWidgetContainer.removeEventListener(Event.RESIZE, this.onResize)
				RootWidgetContainer.removeEventListener(RootWidgetContainer.START_RESIZE, this.onResizeStart)
				this._content = null
				this._current_view = null
			}
		}
		
		private function onResizeStart(event:Event):void {
			if (this.current_view.resize_on_start) {
				_cached_attributes = _current_view.calculated_content_position
				Tweener.addTween(this._content, _cached_attributes.dup.merge(Initializer.options.resize.tween).merge(_current_view.resize).withKeys(Initializer.options.resize.default_parameters.concat(Initializer.options.resize.parameters)))
			}
		}
		
		private function onResize(event:Event):void {
			if (!this.current_view.resize_on_start) {
				_cached_attributes = _current_view.calculated_content_position
				Tweener.addTween(this._content, 
					_cached_attributes.dup.merge(Initializer.options.resize.tween)
						.merge(_current_view.resize)
						.withKeys(Initializer.options.resize.default_parameters.concat(
							['time', 'transition'],
							Initializer.options.resize.parameters
						)
					)
				)
			}
		}
		
		public function morphTo(widget_view:WidgetView):Widget {
			_current_view = widget_view
			_views_history.push(widget_view.view)
			
			if(!this.container.hasWidget(this))this.container.addWidget(this)
			
			if (widget_view.content_attrs)_content.attrs = widget_view.content_attrs
			
			if (!this.isView(widget_view)) {
				if (_content is EventDispatcher) {
					_content.dispatchEvent(new ChangeEvent(ChangeEvent.WIDGET_CHANGE, widget_view.view))
					if ( widget_view.loader ) {
						this._loader = widget_view.loader_unique_id
						WidgetLoader.register(widget_view.loader, widget_view.loader_unique_id, _content)
						if(widget_view.loader_auto_start)WidgetLoader.get(_content).start()
					}
				}
				if (widget_view.view == 'destroy')widget_view.addEventListener(Event.COMPLETE, this.onWidgetDestroy)
				widget_view.startAnimation(_content)
			}
			
			if (widget_view.child_views) {
				this._widgets.change(widget_view.child_views)
			}
			
			return this
		}
				
		private function onWidgetDestroy(event:Event):void
		{
			if(this._loader)WidgetLoader.unregister(this._content)
			if (_content is EventDispatcher)_content.dispatchEvent(new ChangeEvent(ChangeEvent.WIDGET_DESTROY, 'destroy'))
			this._container.removeWidget(this)
			this.destroyContent()
		}
		
		
		private function isView(v:WidgetView):Boolean {
			return this.current_view && this.current_view.view  === v.view && !v.reload
		}
		
		private function getContentAttribute(attr:String):* {
			return _cached_attributes[attr] || (this._content ? this._content[attr] : 0 )
		}
		
		public function get content():*{ return this._content }
		
		public function toString():String {
			return '[Widget name='+this.unique_id+']'
		}
		
	}
	
}