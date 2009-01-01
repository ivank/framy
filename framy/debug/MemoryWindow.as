package framy.debug
{
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.utils.Timer;
  
  import framy.graphics.fySprite;
  import framy.structure.Initializer;
  import framy.utils.Colors;
  
  internal class MemoryWindow extends DebugWindow
  {
    
    private static const GRAPH_WIDTH:uint = 300
    private static const GRAPH_HEIGHT:uint = 300
    
    private var graph:fySprite
    private var graph_frame:fySprite
    private var max_mem:int = 0
    private var timer:Timer = new Timer(2000)
    
    public function MemoryWindow(title:String)
    {
      super(title)
      this.graph = fySprite.newRect({ width: GRAPH_WIDTH, height: GRAPH_HEIGHT, alpha: 0})
      this.timer.start()
      this.graph_frame = fySprite.newFrame({ width: GRAPH_WIDTH, height: GRAPH_HEIGHT, color: framy.structure.Initializer.options.debug.btn_color })
      this.timer.addEventListener(TimerEvent.TIMER, this.onTimerEvent)
      this.graph.point = this.graph_frame.point = new Point(20,20)
      
      this.attrs = { width: 340, height: 340 };
      this.addChildren(this.graph, this.graph_frame)
    }
    
    private function onTimerEvent(event:TimerEvent):void{
      this.graph.graphics.clear()
      
      this.graph.graphics.beginFill(0,0)
      this.graph.graphics.drawRect(0,0,GRAPH_WIDTH,GRAPH_HEIGHT)
      this.graph.graphics.endFill()
      
      this.graph.graphics.lineStyle(1, Colors.get(framy.structure.Initializer.options.debug.text_font.color))
      
      this.max_mem = DebugPanel._memory_points.concat().sort().reverse()[0] || 1
      
      for ( var i:int; i < DebugPanel._memory_points.length; i++){
        this.graph.graphics[i==0 ? 'moveTo' : 'lineTo']( (GRAPH_WIDTH)*(i/(DebugPanel._memory_points.length-1)), 5+(GRAPH_HEIGHT-10)*(1-DebugPanel._memory_points[i]/max_mem))
      }
    }
    
    override public function set width(value:Number):void{
      super.width = value
      this.graph.width = value-40
      this.graph_frame.width = value-40
    }
    
    override public function set height(value:Number):void{
      super.height = value
      this.graph.height = value-40
      this.graph_frame.height = value-40
    }
  }
}