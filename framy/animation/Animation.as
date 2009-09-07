package framy.animation 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.routing.Router;
	import framy.structure.WidgetView;
	import framy.utils.FunctionTools;
	import framy.utils.Hash;
	import framy.utils.ArrayTools;
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Animation extends EventDispatcher
	{
		private var _animation_sequence:Sequence
		private var _name:String
		private var _from:* = 'all'
		private var _view:* = 'all'
		
		/**
		 *	<p>Crates a tween that will be applyed to a widget (adding animation)
		 *	The first arguments specifies the widget name. If the targeted widget is inside another widget a dot notation can be used
		 *	for example 'menu_interface.main_menu' will target a widget with the name 'main_menu' inside the 'menu_interface' widget</p>
		 *	
		 *	<p>The other arguments are hashes with animation parameters, applied through Tweener.addTween sequentially
		 *	Each hash is merged with the widget view position (specified in the WidgetView class). You can also 'offset' the position, if you
		 *	specify the hash parameter as a string.</p>
		 *	
		 *	@example This specifies that the 'bg' widget will go to it's position: <listing version="3.0">
new Animation('bg',  { time: 2, transition:'easeOutSine' } )
	     *  </listing>
	     *	
		 *	@example Here's how a sequence looks like: <ul><li>We position the element 200 pixels above it's default position, and set its height to 0 (no time parameter is set, so this executes immidiately).</li><li>We tween the 'bg' widget to its default height and y, but 20 pixels to the right </li><li>After the previous tween (using the delay) we set all default parameters - the actual tween looks like this { y: 40, x: 30, width: 500, height: 600, time: 1, delay: 2 }</li></ul><listing version="3.0">
this.setWidgetViews(
  new WidgetView('bg', 'show', {  y: 40, x: 30, width: 500, height: 600 } )
)
this.setTweens(
  new WidgetTween('bg', { height:0, y: '-200' }, { time: 2, x: '20', transition:'easeOutSine' }, { time: 1, delay: 2 } )
)
	     *    </listing>
		 *
		 *	@param	widget_name	 The name of the target widget, if is inside another widget, you can use the dot notation (menu.background)
		 *	@param	arguments	 A sequence of hashes to that will be applied to the widget, inherit the widget position
		 *	@constructor
		 */
		public function Animation(widget_name:String, ...arguments) 
		{
			this._name = widget_name
			this._animation_sequence = FunctionTools.newWithArguments(Sequence, arguments)
			this._animation_sequence.addEventListener(Event.COMPLETE, this.onSequenceComplete)
			
		}
		
		private function onSequenceComplete(event:Event):void
		{
			this.dispatchEvent(event.clone())
		}
		
		public function get name():String { return this._name }
		
		/**
		 * returns the name of the currrent view
		 */
		public function get view():String { return this._view }
		
		/**
		 * returns thie sequense object of this animation
		 */
		public function get sequence():Sequence { return this._animation_sequence }
		
		
		/**
		 * starts the sequence of the animation
		 * @param	position_params sets the context of the sequence with this params
		 * @param	subject apply the animation to this subject
		 */
		public function start(position_params:Hash, subject:*):void {
			this._animation_sequence.default_parameters = position_params.dup
			this._animation_sequence.widget_name = name
			this._animation_sequence.start(subject)
		}
		
		/**
		 *	Checks if this animation is for a given WidgetView
		 *	
		 *	@param	view	 The WidgetView against which this tween will be checked
		 *	@private
		 */
		public function appliesToView(view:WidgetView):Boolean {
			return view.full_name == this._name && checkFilters(_view, view.view, view.parameters)
		}
		
		public function isFrom(from:String, from_params:Hash):Boolean {
			return checkFilters(_from, from, from_params)
		}
		
		/**
		 * stops the sequence of this animation
		 */
		public function stop():void {
			this.sequence.stop()
		}
		
		/**
		 *	<p>Sets more specific restrictions for this tween</p>
		 *	
		 *
		 *	<p>If you set a "form" parameter - it will apply this tween only if the previous page
		 *  name matches it. If you prefix the name with a dash ('-project_image') then the condition is inverted (it will apply if the name doesn't match)</p>
		 *	<p>You can also add a list of parameters after the name in the form of "project_image(category:interiors, project:12)". This applies the tween only
		 *	if the previous page was named 'project_image' and had the parameters { category:'interiors', project:'12' } in its paramaters list </p>
		 *	<p>You can pass an array of strings, and it will check against all of them. </p>
		 *	<p>If you specify 'all' the tween will apply regardless of the previous page (useful when used with in an array, fallowed by dash prefixed conditions)</p>
	     *	<p>If you set a 'view' parameters it will apply this tween only to widgets with the specified view. This is usefull for targeting 
	     *	'destroy' views, as well as for partials with centralized behaviour</p>
		 *	@example This applyes if the previous page was nat 'loading' or current 'project' page: <listing version="3.0">
new WidgetTween('bg',  { time: 3, delay: 1.5 } ).setOptions( { from: ['all', '-loading', '-project(project:current)' })
	     *    </listing>
	     *	@param	opts	 A hash with the option parameters, 'view', and 'from' keys accepted
		 */
		public function setOptions(opts:Object = null):Animation {
			
			var options:Hash = new Hash( { from: this._from, view: this._view } ).merge(opts)
			
			_from = options.from
			_view = options.view
			return this
		}
		
		override public function toString():String { return '[Animation name='+this._name+' view='+this._view+' from='+this._from+' sequence='+this._animation_sequence+ ']' }
		
		/**
		 *	Checks if all filter_check (with params_check as parameters) exists inside filter_arr 
		 *	for example if "project" with params { project: 32 } exists inside ['loading', 'project(project:12)', '-contacts']
		 *	this is used for checking both the page name and the view of the widget
		 *	@private
		 */		
		private function checkFilters(filter_arr:*, filter_check:String, params_check:Object):Boolean{
			var filter:Array = filter_arr is Array ? filter_arr : [filter_arr]
			var found:Boolean = false;
			for(var i:int=0; i< filter.length; i++){
				if(filter[i] == 'all'){
					found = true;
				}else if(filter[i].charAt(0) == '-'){
					if(checkSingleFilter(filter[i], filter_check, params_check)){
					found = false; break;
				}
				}else{
					if(checkSingleFilter(filter[i], filter_check, params_check))found = true
				}
			}
			return found
		}
		
		/**
		 *	@private
		 */
		private function checkSingleFilter(filter:String, check:String, check_params:Object):Boolean{
			var view_name:String = filter.match(/^-?([a-z_]+)/)[1];
			var view_params_string:Array = filter.match(/[a-z_]+\: ?[a-z_]+/g)
			var equals:Boolean = view_name == check
			if(equals && !ArrayTools.is_empty(view_params_string)){
				if(!check_params)equals = false;
				for each (var view_param:String in view_params_string)
				{
					var k:String = view_param.split(':')[0].replace(' ','')
					var v:String = view_param.split(':')[1].replace(' ','')
					if(v == 'current')v = Router.parameters[k];
					if(check_params[k] != v)equals = false;
				}
			}
			return equals;
		}
		
	}
	
	
	
}