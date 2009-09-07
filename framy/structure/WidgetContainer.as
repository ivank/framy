package framy.structure
{
  import flash.display.Sprite;
  import flash.utils.Dictionary;
  import framy.errors.AbstractMethodError;
  import framy.errors.WidgetError;
  import framy.routing.Router;
  import framy.utils.ArrayTools;
  import framy.utils.Hash;
  import framy.utils.StringTools;
  
  
  public class WidgetContainer
  {
    private var _widgets:Array = new Array()
	public var _widgets_hash:Hash = new Hash()
	private var _widget_views:Dictionary = new Dictionary(true)
    protected var container:*
	private var _path:String
    private var _parent_widget:Widget
	
    public function WidgetContainer(container:*, path:String, parent_widget:Widget=null)
    {
		this._parent_widget = parent_widget
		this._path = path
		this.container = container
    }
	
	public function get path():String {
		return this._path
	}	
	
	public function get unique_id():String { return this._parent_widget ? this._parent_widget.unique_id + '_widgets' : 'root' }
	public function get parent_widget():Widget { return this._parent_widget }
	
	public function addWidget(widget:Widget):Widget {
		this._widgets.push(widget)
		this._widgets_hash[widget.unique_id] = widget
		this.container.addChild(widget.createContent())
		return widget
	}
	
	public function removeWidget(widget:Widget):void {
		_widgets = ArrayTools.remove(_widgets, widget)
		if(widget.content && this.container.contains(widget.content))
			this.container.removeChild(widget.content)
		_widgets_hash[widget.unique_id] = null
	}
	
	public function getRelative(widget:Widget, count:int):Widget { return _widgets[_widgets.indexOf(widget) + count] }
	public function getNext(widget:Widget, back_count:int):Widget { return this.getRelative( widget, back_count) }
	public function getPrevious(widget:Widget, back_count:int):Widget { return this.getRelative( widget, -back_count) }
	
	public function change(widget_views:Array):void {
		var remaining_widgets:Array = this.prepareViews.apply(this,widget_views)
		
		for each(var w:Widget in remaining_widgets) {
			var view:WidgetView = new WidgetView(w.full_name, 'destroy', { x : w.content.x, y: w.content.y } )
			view.setWidgetContainer(this)
			if (Router.current_page) Router.current_page.applyAnimationFor(view, Router.old_page)
			w.morphTo(view)
		}
		
		for each(var widget_view:WidgetView in widget_views) {
			this.getWidgetForViewStrict(widget_view).morphTo(widget_view)
		}
	}
	
	public function applyViews(...arguments):void {
		this.prepareViews(arguments)
		for each(var widget_view:WidgetView in arguments) { {
			this.getWidgetForViewStrict(widget_view).morphTo(widget_view) }
		}		
	}	
	
	public function prepareViews(...arguments):Array {
		var remaining_widgets:Array = this._widgets.slice()
		
		for each(var widget_view:WidgetView in arguments) {
			var widget:Widget = this.getWidgetForView(widget_view) || this.addWidget(new Widget(this, widget_view.name, Router.parameters.withKeys(widget_view.parameters.keys)))
			
			widget_view.setWidgetContainer(this)
			if(widget_view.position !== null)this.positionElement(widget_view.position, widget)
			remaining_widgets = ArrayTools.remove(remaining_widgets,widget)
		}

		return remaining_widgets
	}
	
	public function positionElement(where:String, who:Widget):void{
		var where_part:Array = where.match(/^(front|back|above|below)(\_([a-z\_]+))?$/);
		if(!where_part)throw Error("Wrong positioning argument for "+who+", it should be 'front', 'back', 'above_<widget_name>' or 'below_<widget_name>'")
		var method:String = 'send'+StringTools.classify(where_part[1])
		if(method == 'sendFront' || method =='sendBack')who.content[method]()
		else if(method == 'sendAbove' || method == 'sendBelow'){
			var relative_to:Widget = this.getWidgetForId(where_part[3]);
			if(!relative_to)throw Error("Could not find widget with name "+where_part[3]+' for positioning relative to')
			who.content[method](relative_to.content)
		}
	}
	
	public function hasWidget(widget:Widget):Boolean {
		return this._widgets.indexOf(widget) >= 0
	}
	
	public function getWidgetForId(widget_id:String):Widget { 
		return this._widgets_hash[widget_id] as Widget
	}
	
	public function getWidgetForView(widget_view:WidgetView):Widget { 
		return getWidgetForId(widget_view.current_unique_id)
	}
	
	public function getWidgetForViewStrict(widget_view:WidgetView):Widget { 
		var widget:Widget = this.getWidgetForView(widget_view)
		if(!widget)throw new WidgetError("Widget for view "+widget_view.full_name+" not found in "+this)
		return widget
	}
	
	public function get containerWidth():int { return _parent_widget ? _parent_widget.contentWidth : RootWidgetContainer.stageWidth }
	public function get containerHeight():int { return _parent_widget ? _parent_widget.contentHeight : RootWidgetContainer.stageHeight }
    
	public function addChild(child:*):*{ throw new AbstractMethodError() }
	public function removeChild(child:*):*{ throw new AbstractMethodError() }
	public function addChildAt(child:*, index:int):*{ throw new AbstractMethodError() }
	
	public function toString():String { return '[WidgetContainer path='+this._path+' widgets='+this._widgets+ ']' }
  }
}