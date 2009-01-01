package framy.debug
{
  import caurina.transitions.properties.ColorShortcuts;
  
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
    static public var _instance:DebugPanel
    
    static public function create(container:Stage):void {
      
      container.addChild(_instance = new DebugPanel())
    }
    static public var _memory_points:Array
	static public var log_messages:Array = new Array()
    static public function get instance():DebugPanel { return _instance }
	
	static public function log(...arguments):void {
		log_messages.push(arguments.join(' '));
		if(_instance.console_btn.window)_instance.console_btn.window.update()
	}
    
    private var panel:fySprite
    private var over_bg:fySprite
    
    public var memory_btn:DebugBtn
    public var widgets_btn:DebugBtn
    public var pages_btn:DebugBtn
    public var console_btn:DebugBtn
    
    private var memory_stat:fyTextField
    private var widgets_stat:fyTextField
    private var console_stat:fyTextField
    private var page_stat:fyTextField
    
    public var tick_timer:Timer = new Timer(500)
    
    public function DebugPanel()
    {
      ColorShortcuts.init()
      this.panel = fySprite.newPoly([new Point(0,0), new Point(360,0), new Point(360,25), new Point(345,40), new Point(0, 40)], { color: Initializer.options.debug.bg_color }, { x: -345, y:-25 })
      this.over_bg = fySprite.newCircle({ radius: 50, alpha:0 })
      this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver)
      this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut)
      
      this.memory_btn = new DebugBtn('MEMORY', MemoryWindow).setAttrs({y:5, x:5}) as DebugBtn
      this.widgets_btn = new DebugBtn('WIDGETS', WidgetsWindow).setAttrs( { y:5, x:this.memory_btn.x + this.memory_btn.width + 4 } ) as DebugBtn
	  this.console_btn = new DebugBtn('CONSOLE', ConsoleWindow).setAttrs( { y:5, x:this.widgets_btn.x + this.widgets_btn.width + 4 } ) as DebugBtn
      this.pages_btn = new DebugBtn('PAGES', PagesWindow).setAttrs({y:5, x:this.console_btn.x + this.console_btn.width + 4 }) as DebugBtn
      
      this.memory_stat = new fyTextField('normal', {width: 70, height:memory_btn.x+15, x: 11, y:24, text: '0 KB'}, Initializer.options.debug.text_font)
      this.widgets_stat = new fyTextField('normal', { width: 70, height:20, x: widgets_btn.x, y:24, text: '0 widgets' }, Initializer.options.debug.text_font)
	  this.console_stat = new fyTextField('normal', {width: 70, height:20, x: console_btn.x, y:24, text: '0 messages'}, Initializer.options.debug.text_font)
      this.page_stat = new fyTextField('normal', {width: 70, height:20, x: pages_btn.x, y:24, text: '...'}, Initializer.options.debug.text_font)
      
      this.panel.addChildren(this.memory_btn, this.widgets_btn, this.pages_btn, this.console_btn, this.memory_stat, this.widgets_stat, this.page_stat, this.console_stat)
      
      this.addChildren(this.over_bg, this.panel)
      
      _memory_points = new Array(Initializer.options.debug.memory_resolution).map(function(e:*,i:int,a:Array):*{ return 0 })
      
      
      this.tick_timer.addEventListener(TimerEvent.TIMER, this.onTick)
      this.tick_timer.start()
    }
    
    private function onTick(event:TimerEvent):void{
      this.memory_stat.text = System.totalMemory/1024+"KB"
      this.page_stat.text = Router.current_page.name
	  this.console_stat.text = log_messages.length + ' messages'
      this.widgets_stat.text = Initializer.getWidgetsCount() + ' widgets'
	  
      
      _memory_points.shift()
      _memory_points.push(System.totalMemory)
    }

    
    private function onRollOver(event:Event):void{
      this.panel.tween({ x:0, y: 0, time: 0.7 })
    }
    
    private function onRollOut(event:Event):void{
      this.panel.tween({ x: -345, y: -25, time: 0.8, transition: 'easeOutExpo'})
    }

  }
}
