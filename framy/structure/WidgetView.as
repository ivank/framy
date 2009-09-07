package framy.structure 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import framy.animation.Animation;
	import framy.animation.Sequence;
	import framy.events.ChangeEvent;
	import framy.routing.Router;
	import framy.utils.ArrayTools;
	import framy.utils.Aspect;
	import framy.utils.Hash
	import framy.utils.NumberTools;
	import framy.utils.StringTools;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class WidgetView extends EventDispatcher
	{
		private var _name:String
		private var _full_name:String
		private var _classifyed_view:String
		private var _view:String
		private var _child_views:Array = new Array()
		private var _start:Hash = new Hash()
		private var _widget_container:WidgetContainer
		private var _content_attrs:Hash = new Hash()
		private var _state:uint = 0
		private var _cached_calculated_content_position:Hash
		private var _content_position:Hash
		private var _options:Hash
		private var _animation:Animation
		
		static public const DIMENISION_AUTO:String = "auto"
		
		public function WidgetView(name:String, view:String, position: Object, options:Object = null, attrs:Object = null, ...arguments)
		{
			this._options = new Hash( {
				rounded: true,
				reload: true,
				position: null,
				parameters: null,
				loader: null,
				loader_auto_start: false,
				resize: new Hash(),
				resize_on_start: false
			}).merge(options)
			
			this._options.parameters = new Hash(this._options.parameters)
			this._name = name
			this._full_name = this._name
			this._view = view
			this._classifyed_view = StringTools.classify(view)
			this._content_position = new Hash(position)
			this._content_attrs = new Hash(attrs)
			
			if (arguments && arguments.length) {
				for each( var child_view:WidgetView in ArrayTools.flatten(arguments))
					child_view.setParentView(this)
			}
		}
		
		public function setParentView(parent_view:WidgetView):void {
			parent_view._child_views.push(this)
			this._full_name = parent_view._name + '.' + this._full_name
		}
		
		public function setWidgetContainer(container:WidgetContainer):void { this._widget_container = container }

		public function get content_position():Hash { return this._content_position }
		public function get content_attrs():Hash { return this._content_attrs }
		public function get position():String { return _options.position }
		public function get classifyed_view():String { return this._classifyed_view }
		public function get reload():Boolean { return this._options.reload }

		public function get parameters():Hash { return this._options.parameters }
		public function get resize_on_start():Boolean { return this._options.resize_on_start }
		public function get resize():Hash { return this._options.resize }
		public function get loader():String { return this._options.loader ? this._options.loader.replace(/\(.*\)/, '') : null }
		public function get loader_auto_start():Boolean { return this._options.loader_auto_start }
		public function get loader_unique_id():String { return this._options.loader.replace(/([a-z_]+)\:current/,function():String{ return arguments[1]+':'+Router.parameters[arguments[1]] }) }
		public function get current_unique_id():String { return this._name + this.parameters_extension }
		
		private function get parameters_extension():String {
			return (this.parameters.isEmpty() ? '' : '_'+this.parameters.mapValues(function(k:String, v:*):*{return (v == 'current') ? Router.parameters[k] : v}).toId())
		}
		
		public function get full_name():String { return _full_name }
		
		public function get calculated_content_position():Hash {
			if (this._state == Router.current_state) return _cached_calculated_content_position
			this._state = Router.current_state
			var cal_attrs:Hash = new Hash()
			var second_pass_attrs:Array = new Array()
			for (var name:String in this._content_position) {
				var attr:* = this._content_position[name]
				
				if (name == 'right' || name == 'bottom') second_pass_attrs.push(name)
				
				if (attr is String && attr == 'center') second_pass_attrs.push(name)
				else if (attr is Function) {
					if (name == 'aspect' || name == 'rect') {
						var result:* = (attr as Function).call(this.widget)
						cal_attrs['x'] = result.x
						cal_attrs['y'] = result.y
						cal_attrs['width'] = result.width
						cal_attrs['height'] = result.height
					}else if ( name == 'dims' ) {
						cal_attrs['width'] = ((attr as Function).call(this.widget) as Array)[0]
						cal_attrs['height'] = ((attr as Function).call(this.widget) as Array)[1]
					}else if ( name == 'pos' ) {
						cal_attrs['x'] = ((attr as Function).call(this.widget) as Array)[0]
						cal_attrs['y'] = ((attr as Function).call(this.widget) as Array)[1]
					}else if ( name == 'point' ) {
						cal_attrs['x'] = ((attr as Function).call(this.widget) as Point).x
						cal_attrs['y'] = ((attr as Function).call(this.widget) as Point).y
					}else cal_attrs[name] = (attr as Function).call(this.widget)
				}			
				else if (attr is String && (attr as String).match(/^-?\d+(\.\d+)?%$/)) {
					var percent:Number = Number(attr.match(/^(-?\d+(\.\d+)?)%$/)[1]);
					
					if 		(name.match(/x|width|left|right/)) cal_attrs[name] = this.widget_container.containerWidth * (percent / 100)
					else if (name.match(/y|height|top|bottom/)) cal_attrs[name] = this.widget_container.containerHeight * (percent / 100)
				}else cal_attrs[name] = attr
			}
			if (second_pass_attrs.length) {
				for each( var second_pass_name:String in second_pass_attrs) {
					if (second_pass_name == 'x') cal_attrs[second_pass_name] = (this.widget_container.containerWidth - (cal_attrs['width'] || this.widget.contentWidth)) / 2
					if (second_pass_name == 'y') cal_attrs[second_pass_name] = (this.widget_container.containerHeight - (cal_attrs['height'] || this.widget.contentHeight)) / 2
					
					if (second_pass_name == 'right') {
						cal_attrs['x'] = this.widget_container.containerWidth - (cal_attrs['width'] === undefined ? this.widget.contentWidth : cal_attrs['width']) + cal_attrs[second_pass_name]
						delete cal_attrs[second_pass_name]
					}
					if (second_pass_name == 'bottom') {
						cal_attrs['y'] = this.widget_container.containerHeight - (cal_attrs['height'] === undefined ? this.widget.contentHeight : cal_attrs['height']) + cal_attrs[second_pass_name]
						if(!_start.has('y') && _start.has('height'))_start['y'] = this.widget_container.containerHeight + cal_attrs[second_pass_name]
						delete cal_attrs[second_pass_name]
					}
				}
			}
			for ( var n:String in cal_attrs) if (n == 'top' || n == 'bottom' || n == 'left' || n == 'right') delete cal_attrs[n];
			
			if (this._options.rounded) cal_attrs = cal_attrs.mapValues(function(name:String, val:*):*{ return Math.round(val) } )
			
			return _cached_calculated_content_position = cal_attrs
		}
		
		public function startAnimation(_content:*):void {
			if (this._animation) {
				this._animation.addEventListener(Event.COMPLETE, this.onAnimationComplete, false, 0, true)
				this._animation.start(calculated_content_position , _content)
			} else {
				_content.attrs = calculated_content_position
				this.onAnimationComplete()
			}
		}
		
		private function onAnimationComplete(event:Event=null):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE))
		}
		
		public function setAnimation(anim:Animation):void {
			this._animation = anim
		}
		
		public function get widget():Widget {
			var w:Widget = widget_container.getWidgetForView(this)
			if(!w)throw new Error('Widget for view' + this + ' not found in container ' + widget_container)
			return w
		}
		
		public function get widget_container():WidgetContainer {
			return _widget_container
		}
		
		public function apply():void {
			this.widget.morphTo(this)
		}
		
		public function get name():String { return _name }
		public function get view():String { return _view }
		public function get child_views():Array { return this._child_views }
		
		override public function toString():String {
			return "[WidgetView name="+current_unique_id+" view="+_view+" attributes="+_content_position+"]"
		}
	}
	
}