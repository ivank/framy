package framy.debug
{
  import caurina.transitions.properties.ColorShortcuts;
  import flash.utils.Dictionary;
  import framy.utils.ArrayTools;
  import framy.utils.Hash;
  
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.system.System;
  import flash.utils.Timer;
  import framy.graphics.fySprite;
  import framy.graphics.fyTextField;
  import framy.routing.Router;
  import framy.structure.Initializer;
  
  public class DebugPanel extends fySprite
  {
	/**
	 * @private
	 */	  
    static public var _instance:DebugPanel
    static private const PANEL_WIDTH:uint = 550
	
	/**
	 * @private
	 */	
    static public function create(container:Stage):void {
      container.addChild(_instance = new DebugPanel())
    }
	
	/**
	 * @private
	 */	
    static public var _memory_points:Array
	
	/**
	 * @private
	 */	
	static public var log_messages:Array = new Array()
	/**
	 * @private
	 */
	static public var variables:Hash = new Hash()
	
    static public function get instance():DebugPanel { return _instance }
	
	/**
	 * Works the same as the internal "trace" but uses the internal debug window for output, allowing you to review log messages event on a remote host
	 * @param	...arguments
	 */
	static public function log(...arguments):void {
		log_messages.push(arguments.join(' '));
		if(_instance.buttons['CONSOLE'].window)_instance.buttons['CONSOLE'].window.update()
	}
	
	/**
	 * This is for easy position adjustments. write DebugPanel.variable('<varname>', <default value>) where you need a variable positioning, change the value, and hit update to resize
	 * You can also use up and down arrows on the text field to increase and decrease the value. It automatically calls resize after each update
	 * @param	name
	 * @param	default_value
	 * @return
	 */
	static public function variable(name:String, default_value:Number = 1):Number {
		if (! variables.has(name) ) variables[name] = default_value
		if(_instance.buttons['VARS'].window)variables[name] = _instance.buttons['VARS'].window.getVariable(name)
		return variables[name]
	}
    
    private var panel:fySprite
    
	public var buttons:Hash = new Hash()
	
    private var memory_stat:fyTextField
    private var widgets_stat:fyTextField
    private var console_stat:fyTextField
    private var page_stat:fyTextField
    
    public var tick_timer:Timer = new Timer(500)
    
    public function DebugPanel()
    {
		ColorShortcuts.init()
		this.panel = fySprite.newPoly([new Point(0,0), new Point(PANEL_WIDTH,0), new Point(PANEL_WIDTH,25), new Point(PANEL_WIDTH-15,40), new Point(0, 40)], { color: Initializer.options.debug.bg_color }, { x: -(PANEL_WIDTH-15), y:-25 })
		this.panel.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver)
		this.panel.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut)
		var offset:int = 0
		for each(var btn:Array in [
			['MEMORY', MemoryWindow, 70],
			['WIDGETS', WidgetsWindow, 70],
			['CONSOLE', ConsoleWindow, 70],
			['PAGES', PagesWindow, 70],
			['VARS', VariablesWindow, 50],
			['-', DebugHorizontalGuide, 8],
			['|', DebugVerticalGuide, 8]
		]) {
			this.buttons[btn[0]] = new DebugBtn(btn[0], btn[1], btn[2]).setAttrs( { x: offset, y: 5 } )
			offset += this.buttons[btn[0]].width + 4
		}
		
		this.memory_stat = new fyTextField('normal', {width: 70, height: this.buttons['MEMORY'].x+15, x: 11, y:24, text: '0 KB'}, Initializer.options.debug.text_font)
		this.widgets_stat = new fyTextField('normal', { width: 70, height:20, x: this.buttons['WIDGETS'].x, y:24, text: '0 widgets' }, Initializer.options.debug.text_font)
		this.console_stat = new fyTextField('normal', {width: 70, height:20, x: this.buttons['CONSOLE'].x, y:24, text: '0 messages'}, Initializer.options.debug.text_font)
		this.page_stat = new fyTextField('normal', {width: 70, height:20, x: this.buttons['PAGES'].x, y:24, text: '...'}, Initializer.options.debug.text_font)
		
		this.panel.addChildren(this.buttons.values, this.memory_stat, this.widgets_stat, this.page_stat, this.console_stat)
		
		this.addChildren(this.panel)
		
		_memory_points = new Array(Initializer.options.debug.memory_resolution).map(function(e:*,i:int,a:Array):*{ return 0 })
		
		this.tick_timer.addEventListener(TimerEvent.TIMER, this.onTick)
		this.tick_timer.start()
    }
    
    private function onTick(event:TimerEvent):void{
    	this.memory_stat.text = System.totalMemory/1024+"KB"
	
    	if(Router.current_page)this.page_stat.text = Router.current_page.name
		this.console_stat.text = log_messages.length + ' messages'
    	this.widgets_stat.text = Initializer.getWidgetsCount() + ' widgets'
		
    	
    	_memory_points.shift()
    	_memory_points.push(System.totalMemory)
    }

    
    private function onRollOver(event:Event):void{
      this.panel.tween({ x:0, y: 0, time: 0.7 })
    }
    
    private function onRollOut(event:Event):void{
      this.panel.tween({ x: -(PANEL_WIDTH-15), y: -25, time: 0.8, transition: 'easeOutExpo'})
    }

  }
}
