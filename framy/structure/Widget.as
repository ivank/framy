package framy.structure 
{
	import caurina.transitions.Tweener;
	import flash.utils.Dictionary;
	import framy.animation.Sequence;
	import framy.events.ChangeEvent;
	import framy.events.SequenceEvent;
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
		private var _content_arguments:Array
		
		public function Widget(container:WidgetContainer, name:String, parameters:Object = null, content_arguments:Array = null) 
		{
			this._name = name
			this._path = name.replace(/\{[^\}]*\}/,'')
			this._parameters = new Hash(parameters)
			this._container = container
			this._content_arguments = content_arguments
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
			
		  _content = FunctionTools.newWithArguments(this.widget_class, this._content_arguments)
		  
			this._widgets = new SpriteWidgetContainer(_content as Sprite, this._container.path+'.'+this._name, this)
			Initializer.registerWidgetContent(this, _content)
			
			return _content
		}
		
		public function get container():WidgetContainer { return this._container }
		public function get widgets():WidgetContainer { return this._widgets }
		
		
		public function getPrevious(back_count:uint):Widget {
			return this.container.getPrevious(this,back_count)
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
		
		private function onResizeStart(event:Event):void
		{
			if (this.current_view.start_resize) {
				_cached_attributes = _current_view.calculated_attributes
				Tweener.addTween(this._content, _cached_attributes.dup.merge(Initializer.options.resize.tween).merge(_current_view.resize).withKeys(['x', 'y', 'width', 'height', 'scaleX', 'scaleY']))
			}
		}
		
		private function onResize(event:Event):void {
			if (!this.current_view.start_resize) {
				_cached_attributes = _current_view.calculated_attributes
				Tweener.addTween(this._content, _cached_attributes.dup.merge(Initializer.options.resize.tween).merge(_current_view.resize).withKeys(['time', 'transition', 'x', 'y', 'width', 'height', 'scaleX', 'scaleY']))
			}
		}
		
		private function autoAddEventsFor(view:WidgetView):void {
			for each( var stage:String in [ChangeEvent.FIRST_START, ChangeEvent.START, ChangeEvent.LAST_START, ChangeEvent.FIRST_PROGRESS, ChangeEvent.PROGRESS, ChangeEvent.LAST_PROGRESS, ChangeEvent.FIRST_FINISH, ChangeEvent.FINISH, ChangeEvent.LAST_FINISH]) {
				if (!_content.hasEventListener(stage + view.classifyed_view) && FunctionTools.getMethod(_content, stage + view.classifyed_view) !== null) {
					_content.addEventListener(stage + view.classifyed_view, _content[stage + view.classifyed_view])
				}
			}
		}
		
		public function morphTo(widget_view:WidgetView):Widget {
			var _first_view:Boolean = _views_history.indexOf(widget_view.view) < 0
			
			var _widget:Widget = this
			_views_history.push(widget_view.view)
			
			if(!this.container.hasWidget(this))this.container.addWidget(this)
			var _same_view:Boolean = this.isView(widget_view)
			_current_view = widget_view
			
			if(Initializer.options.auto_change_events)this.autoAddEventsFor(widget_view)
			
			_cached_animation = widget_view.animation_attributes.dup.setDispatcher(Router.current_page)
			
			if ( !_same_view )_cached_animation.addEventListener(SequenceEvent.START, function(event:SequenceEvent):void {
				fireEventTrio(_content, ChangeEvent.START+widget_view.classifyed_view, 0, _cached_animation.length, event.current, Router.current_page.data, _first_view)
				Router.current_page.dispatchAnonimousEvent(new ChangeEvent(ChangeEvent.START+widget_view.classifyed_view + ':' + widget_view.full_name,0, _cached_animation.length, event.current))
			})
			
			if ( !_same_view )_cached_animation.addEventListener(SequenceEvent.PROGRESS, function(event:SequenceEvent):void {
				fireEventTrio(_content, ChangeEvent.PROGRESS+widget_view.classifyed_view, _content.progress, _cached_animation.length, event.current, Router.current_page.data, _first_view)
			})
			
			if ( !_same_view )_cached_animation.addEventListener(SequenceEvent.COMPLETE, function(event:SequenceEvent):void {
				Router.current_page.dispatchAnonimousEvent(new ChangeEvent(ChangeEvent.FINISH+widget_view.classifyed_view + ':' + widget_view.full_name, 1, _cached_animation.length, event.current))
				fireEventTrio(_content, ChangeEvent.FINISH+widget_view.classifyed_view, 1, _cached_animation.length, event.current, Router.current_page.data, _first_view)
				if ((event.current == _cached_animation.length -1) && widget_view.view == 'destroy') {
					_widget.container.removeWidget(_widget)
					_widget.destroyContent()
				}
			})
			
			_cached_animation.apply(_content)
			
			if (widget_view.child_views) {
				this._widgets.change(widget_view.child_views)
			}
			
			return this
		}
		
		private function fireEventTrio(_content:*, type:String, progress:Number, length:uint, current:uint, data: * , _first_view:Boolean):void {
			if (_content.hasEventListener(type))_content.dispatchEvent(new ChangeEvent(type, progress, length, current, data, _first_view))
			if (_content.hasEventListener('first'+StringTools.classify(type)) && current == 0)_content.dispatchEvent(new ChangeEvent('first'+StringTools.classify(type), progress, length, current, data, _first_view))
			if (_content.hasEventListener('last'+StringTools.classify(type)) && current == length -1)_content.dispatchEvent(new ChangeEvent('last'+StringTools.classify(type), progress, length, current, data, _first_view))			
			
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