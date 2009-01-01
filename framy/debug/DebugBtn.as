package framy.debug
{
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  import framy.graphics.Label;
  import framy.graphics.fySprite;
  import framy.graphics.fyTextField;
  import framy.structure.Initializer;
  import framy.utils.Hash;
  
  internal class DebugBtn extends Label
  {
    private var window_class:Class
	private var btn:fyTextField
	public var window:*
    
    public function DebugBtn(str:String, window_class:Class=null)
    {
      var content:fySprite = fySprite.newRect({width:85, height: 19, color: Initializer.options.debug.btn_color})
      content.addChild(this.btn = new fyTextField('normal', { width: 70, y:1, text: str, x: 7 }, new Hash(Initializer.options.debug.text_font).merge({ size: 12})))
      content.addChild(fySprite.newFrame({ width:85, height: 19, color: Initializer.options.debug.btn_border_color}))
      super(content, { _brightness: 0, _saturation:1 },{_brightness:0.2}, {_saturation: 0})
      
      this.window_class = window_class
      if(this.window_class)this.addEventListener(MouseEvent.CLICK, this.openWindow)
       
    }
    
    private function openWindow(event:MouseEvent):void{
		this.selected = true
		this.window = new this.window_class(btn.text)
		window.addEventListener(Event.REMOVED_FROM_STAGE, this.removeWindow)
		DebugPanel.instance.addChild(window)      
    }
    
    private function removeWindow(event:Event):void {
		this.window = null
		this.selected = false
    }
  }
}