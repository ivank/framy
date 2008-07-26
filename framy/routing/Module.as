package framy.routing {
	import flash.events.Event;
	import framy.ActionSprite;
	import framy.events.ActionEvent;
	import framy.events.RouteEvent;
	import framy.events.RouteTriggerEvent;
	import framy.events.TranslateEvent;
	import framy.tools.Grawl;
	import framy.tools.Hash;
	import framy.tools.Options;
	import flash.utils.getQualifiedClassName;
	
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class Module extends ActionSprite{
		private var _parent_module:Module
		private var _parameters:Options
		private var _children:Array
	
		
		private var _build_path:Array
		private var _full_build_path:Array
		private var _traverse_events:Hash
		private var _state:String = ActionEvent.DESTROY_COMPLETE
		private var has_build_resize_events:Boolean = true
		private var _added_externaly:Boolean = false
		private var _auto_add:Boolean = true
		private var _path:Array
		
		static private var _last_destroyed_module:Module
		static private var _on_build_path:Boolean = true
		
		static private var _root:Module
		static private var _current:Module
		static private var _target:Module	
		
		
		public function Module(options:Object = null) {
			this._children = []
			this._build_path = []
			this._traverse_events = new Hash()
			
			this._parameters = new Options(options, { } )
			
			if (this._parameters.parent) {
				this._parent_module = this._parameters.parent
				this._build_path = this._parent_module._build_path.concat(this._parent_module)
				this._full_build_path = this._build_path.concat(this)
				
				
				this._parameters.merge((this._parameters.parent as Module).parameters)
				delete this._parameters.parent
			}else {
				_root = this
			}
			
			if (this._parameters.auto_add !== undefined) {
				this._auto_add = this._parameters.auto_add
				delete this._parameters.auto_add
			}			
			
			Router.addModule(this)
			this.addEventListener(ActionEvent.BUILD_STARTED, this._onBuildStarted, false, 5, true )
			this.addEventListener(ActionEvent.DESTROY_COMPLETE, this._onDestroyComplete, false, 5, true )
			this.addEventListener(ActionEvent.TRANSLATE_COMPLETE, this._onTranslateComplete, false, 5, true )
			
			if (this.resizable) this.has_build_resize_events = false
			
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferance:Boolean = false):void {
			if(RouteAction.BUILD_START_EVENTS.indexOf(type) >= 0)this._traverse_events[type] = listener
			super.addEventListener(type, listener, useCapture, priority, useWeakReferance);
		}
			
		/**
		 * A property that returns the routing parameters of this module as a hash. For example, if the route matched is /:section/:group
		 * the parameters will be { section: 'section-name', group: 'group-name' }
		 */
		public function get parameters():Hash {	return this._parameters	}

		public function get parent_module():Module { return this._parent_module	}
		
		public function addToStage():void {
			if(this._parent_module && !this._parent_module.contains(this))
				if(this._auto_add)this._parent_module.addChild(this)
			else if( this._parent_module )this._added_externaly = true
		}

		public function removeFromStage():void {
			if(this._parent_module && this._parent_module.contains(this) && this._auto_add && !this._added_externaly)
				this._parent_module.removeChild(this)				
		}
		
		public function buildChain():Array {
			_target = this
			_path = []
			if (!_current) {
				_current = _root
				_path = _path.concat(new RouteAction(ActionEvent.BUILD_STARTED, _current))
			}
			_path = buildPath(_path, _current, _target)
			executePathAction(_path)
			return _path
		}
		
		static private function executePathAction(path:Array, index:uint = 0):void {			
			if (path && path.length) {
				var current_action:RouteAction = path[index] as RouteAction;
				if (index < path.length) {
					Router.locked = true
					var onNextPathAction:Function = function(event:RouteEvent):void {
						executePathAction(path, index + 1)
						event.target.removeEventListener(event.type, onNextPathAction)
						Router.dispatchEvent(event.clone());
					}
					current_action.module.addEventListener(current_action.to_type, onNextPathAction)
					current_action.module._state = current_action.type;

					current_action.execute()
				}else {
					Router.locked = false
					Router.resumeLastRoute()
				}
			}
		}
		
		static private function buildPath(path:Array, from:Module, to:Module):Array {
			if (!from)return path.concat(new RouteAction(ActionEvent.BUILD_STARTED, to))
			if (from == to) {
				if( to.hasListener(ActionEvent.RESTORE_STARTED) && to.stateIs(ActionEvent.PREPARE_STARTED,ActionEvent.TRANSLATE_STARTED))return path.concat(new RouteAction(ActionEvent.RESTORE_STARTED, to))
				return path
			}
			var last_action:RouteAction = path.length ? path[path.length-1] : null
			
			if (to.buildPathContains(from)) {
				if (last_action && last_action.type == ActionEvent.DESTROY_STARTED &&  from.hasListener(ActionEvent.TRANSLATE_STARTED)) {
					return buildPath(path.concat(new RouteAction(ActionEvent.TRANSLATE_STARTED, from, last_action.module, nextModule(from, to)), new RouteAction(ActionEvent.BUILD_STARTED, nextModule(from, to)) ), nextModule(from, to), to)
				}else if (from.hasListener(ActionEvent.PREPARE_STARTED) && ((!last_action) || last_action && last_action.type == ActionEvent.BUILD_STARTED)) {
					return buildPath(path.concat(new RouteAction(ActionEvent.PREPARE_STARTED, from, from, to)), from, to)
				}else {
					return buildPath(path.concat(new RouteAction(ActionEvent.BUILD_STARTED, nextModule(from, to), from)), nextModule(from, to), to)
				}
			}else {
				if ( (to != from.parent_module || from.parent_module == _root) && from.hasEventListener(ActionEvent.QUICK_DESTROY_STARTED) && (last_action && (last_action.type == ActionEvent.DESTROY_STARTED || last_action.type == ActionEvent.QUICK_DESTROY_STARTED))) {
					return buildPath(path.concat(new RouteAction(ActionEvent.QUICK_DESTROY_STARTED, from)), from.parent_module, to)
				}else if (from.hasListener(ActionEvent.RESTORE_STARTED) && ((!last_action && from.stateIs(ActionEvent.PREPARE_COMPLETE)) || (last_action && (last_action.type == ActionEvent.DESTROY_STARTED || last_action.type == ActionEvent.QUICK_DESTROY_STARTED)))) {
					return buildPath(path.concat(new RouteAction(ActionEvent.RESTORE_STARTED, from)), from, to)
				}else {
					return buildPath(path.concat(new RouteAction(ActionEvent.DESTROY_STARTED, from)), from.parent_module, to)
				}
			}
		}
		
		/**
		 * Use this to add a child module to the current one, building the route chain. This method will not add the child to the stage,
		 * this is done when the model is built
		 * @param	child_module	the module to be added as a child 
		 */
		public function addChildModule(child_module:Module):Module {
			this._children.push(child_module)
			return child_module
		}		
		
		private function _onBuildStarted(event:Event):void {
			this.addToStage()
			_current = this
		}
		private function _onDestroyComplete(event:Event):void {
			_current.removeFromStage()
			_current = this._parent_module
		}

		private function _onTranslateComplete(event:RouteEvent):void {
			_current = _target._full_build_path[_target._full_build_path.indexOf(findCommonRoot(_current, _target)) + 1]
		}
		
		
		private function routing_error():void {
			throw Error("routing error from "+ _current + " through " + this + " to " + _target)
		}
		
		public function stateIs(...arguments):Boolean {  return arguments.indexOf(_state) >= 0	}
		public function hasListener(event:String):Boolean {  return _traverse_events[event] ? true : false}
		
		public function dispatchPrepareEvent():void { this.dispatchEvent(new RouteEvent(ActionEvent.PREPARE_COMPLETE,this)) }
		public function dispatchRestoreEvent():void { this.dispatchEvent(new RouteEvent(ActionEvent.RESTORE_COMPLETE,this)) }
		public function dispatchDestroyEvent():void { this.dispatchEvent(new RouteEvent(ActionEvent.DESTROY_COMPLETE,this)) }
		public function dispatchBuildEvent():void { this.dispatchEvent(new RouteEvent(ActionEvent.BUILD_COMPLETE,this)) }
		public function dispatchTranslateEvent():void { this.dispatchEvent(new RouteEvent(ActionEvent.TRANSLATE_COMPLETE,this)) }
		
		private function buildPathContains(module:Module, full:Boolean = false):Boolean {
			return ((full ? this._full_build_path : this._build_path) as Array).indexOf(module) >= 0
		}
		
		static private function findCommonRoot(source:Module, destination:Module):Module {
			for each(var m:Module in destination._build_path.reverse()) if (source._full_build_path.indexOf(m) >= 0) return m
			return null
		}
		
		static private function nextModule(from:Module,to:Module):Module {
			for each (var m:Module in to._full_build_path) if (m._parent_module == from) return m
			return null
		}
		
		/**
		 * A read-only property; returns all the children modules of this module
		 */
		public function get child_modules():Array {
			return this._children
		}
		
		/**
		 * get the parameters of the currently active module
		 */
		static public function get current_parameters():Hash {
			return new Hash(_current._parameters)
		}
		
		static public function get target_parameters():Hash {
			return new Hash((_target || _current)._parameters)
		}
		
		override public function toString():String {
			return "[ Module => { class: "+getQualifiedClassName(this)+", parameters: "+this._parameters+"]"
		}		
	}
	
}