package framy.structure 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import framy.animation.Sequence;
	import framy.animation.WidgetTween;
	import framy.events.ChangeEvent;
	import framy.routing.Router;
	import framy.utils.Aspect;
	import framy.utils.Hash
	import framy.utils.NumberTools;
	import framy.utils.StringTools;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class WidgetView 
	{
		private var _name:String
		private var _full_name:String
		private var _classifyed_view:String
		private var _attributes:Hash
		private var _view:String
		private var _child_views:Array
		private var _animation:Sequence = new Sequence()
		private var _start:Hash = new Hash()
		private var _widget_container:WidgetContainer
		private var _parameters:Hash = new Hash()
		private var _state:uint = 0
		private var _rounded:Boolean = true
		private var _reload:Boolean = false
		private var _position:String  = null
		private var _resize:Hash
		private var _start_resize:Boolean = false
		private var _cached_calculated_attributes:Hash
		private var _arguments:Array
		
		
		static public const DIMENISION_AUTO:String = "auto"
		
		public function WidgetView(name:String, view:String, options:Object = null, ...arguments) 
		{
			var opts:Hash = new Hash(options)
			this._arguments = arguments
			
			this._name = name
			this._full_name = this._name
			this._view = view
			this._classifyed_view = StringTools.classify(view)
			
			if (opts.rounded !== undefined) {
				this._rounded = opts.rounded
				delete opts.rounded
			}
			if (opts.reload !== undefined) {
				this._reload = opts.reload
				delete opts.reload
			}			
			
			if (opts.position !== undefined) {
				this._position = options.position
				delete opts.position
			}
			if (opts.parameters !== undefined) {
				this._parameters = new Hash(options.parameters)
				delete opts.parameters
			}
			if (opts.resize !== undefined) {
				this._resize = new Hash(options.resize)
				delete opts.resize
			}
			if (opts.start_resize !== undefined) {
				this._start_resize = options.start_resize
				delete opts.start_resize
			}
			
			if (opts.widgets) {
				if (!(opts.widgets is Array)) throw Error('"widgets" is reserved for child widgets of this widget, please provide an array of WidgetView objects')
				this._child_views = new Array()
				for each( var child_view:WidgetView in opts.widgets)
					child_view.setParentView(this)
					
				delete opts.widgets
			}
			this._attributes = new Hash(opts)
		}
		
		public function setParentView(parent_view:WidgetView):void {
			parent_view._child_views.push(this)
			this._full_name = parent_view._name+'.'+this._full_name
		}
		
		public function get progressEvent():String { return ChangeEvent.PROGRESS+this.classifyed_view }
		public function get lastProgressEvent():String { return ChangeEvent.LAST_PROGRESS+this.classifyed_view }
		public function get firstProgressEvent():String { return ChangeEvent.FIRST_PROGRESS + this.classifyed_view }
		
		public function get startEvent():String { return ChangeEvent.START+this.classifyed_view }
		public function get firstStartEvent():String { return ChangeEvent.FIRST_START + this.classifyed_view }
		public function get lastStartEvent():String { return ChangeEvent.LAST_START + this.classifyed_view }
		
		public function get finishEvent():String { return ChangeEvent.FINISH+this.classifyed_view }
		public function get firstFinishEvent():String { return ChangeEvent.FIRST_FINISH + this.classifyed_view }
		public function get lastFinishEvent():String { return ChangeEvent.LAST_FINISH + this.classifyed_view }
		
		public function setWidgetContainer(container:WidgetContainer):void { this._widget_container = container }

		public function get widget_arguments():Array { return this._arguments }
		public function get position():String { return this._position }
		public function get classifyed_view():String { return this._classifyed_view }
		public function get reload():Boolean { return this._reload }
		public function get parameters():Hash { return this._parameters }
		public function get start_resize():Boolean { return this._start_resize }
		public function get resize():Hash { return this._resize }
		public function get current_unique_id():String { 
			return this._name+(this._parameters.isEmpty() ? '' : '_'+this._parameters.map_values(function(k:String, v:*):*{return (v == 'current') ? Router.parameters[k] : v}).toId()) 
		}
		
		public function get full_name():String { return _full_name }
		public function setTween(t:WidgetTween):void { 
			this._animation.merge(t.animation)
		}
		
		public function get calculated_attributes():Hash {
			if (this._state == Router.current_state) return _cached_calculated_attributes
			this._state = Router.current_state
			
			var cal_attrs:Hash = new Hash()
			var second_pass_attrs:Array = new Array()
			for (var name:String in this._attributes) {
				var attr:* = this._attributes[name]
				
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
			
			if (this._rounded) cal_attrs = cal_attrs.map_values(function(name:String, val:*):*{ return Math.round(val) } )
			
			return _cached_calculated_attributes = cal_attrs
		}
		
		public function get animation_attributes():Sequence {
		  if(!this._animation.length)this._animation.merge(this.calculated_attributes)
			this._animation.extend(this.calculated_attributes)
			return this._animation.offsetFrom(this.calculated_attributes)
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
		
		public function toString():String {
			return "[WidgetView name="+_name+" view="+_view+" attributes="+_attributes+"]"
		}
	}
	
}