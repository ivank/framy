package framy.debug
{
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import framy.graphics.fyTextField;
  import framy.utils.Hash;
  import framy.graphics.fySprite;
  import framy.structure.Initializer;

  internal class DebugWindow extends fySprite
  {
    
    private var close:CloseDebugWindowBtn
    private var bg:fySprite
    private var resize_control:fySprite
	private var title:fyTextField
    
    public function DebugWindow(title:String, attributes:Object=null)
    {
		super(attributes);
		this.title = new fyTextField('normal', { width: 70, y:1, text: title, x: 17 }, new Hash(Initializer.options.debug.text_font).merge( { size: 12 } ))
		
		this.close = new CloseDebugWindowBtn().setAttrs({y:5})
		this.close.addEventListener(MouseEvent.CLICK, this._onCloseWindow)
		
		this.bg = fySprite.newRect({ width: 400, height: 500, color: Initializer.options.debug.bg_color})
		this.resize_control = fySprite.newPoly([new Point(15,0),new Point(15,15),new Point(0,15)], { color: Initializer.options.debug.btn_color }, { x: 385, y: 485 } )
		this.addChildAt(this.bg,0)
		this.addChildren(this.resize_control, this.close, this.title)
		
		this.addEventListener(MouseEvent.ROLL_OUT, this._onRollOut)
		this.addEventListener(MouseEvent.ROLL_OVER, this._onRollOver)
		this.bg.addEventListener(MouseEvent.MOUSE_DOWN, this._onBgPress)
		this.bg.addEventListener(MouseEvent.MOUSE_UP, this._onBgRelease)
		
		this.resize_control.addEventListener(MouseEvent.MOUSE_DOWN, this.onResizePressed)
		this.resize_control.addEventListener(MouseEvent.MOUSE_UP, this.onResizeReleased)
		this.resize_control.buttonMode = true
    }
	
	private function onResizeReleased(event:MouseEvent):void
	{
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onResizeMoved)
		this.resize_control.stopDrag()
	}
	
	private function onResizePressed(event:MouseEvent):void
	{
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onResizeMoved)
		this.resize_control.startDrag()
		
	}
	
	private function onResizeMoved(event:MouseEvent):void
	{
		this.width = this.resize_control.x + 15
		this.height = this.resize_control.y + 15
	}
    
    private function _onBgPress(event:MouseEvent):void{
      if(event.currentTarget == this.bg)this.startDrag(false)
    }
    
    private function _onBgRelease(event:MouseEvent):void{
      if(event.currentTarget == this.bg)this.stopDrag()
    }
    
    private function _onRollOver(event:MouseEvent):void{
      this.tween({ alpha: 1, time: 0.3 })
    }
    
    private function _onCloseWindow(event:MouseEvent):void{
      this.parent.removeChild(this)
    }
    
    private function _onRollOut(event:MouseEvent):void{
      this.tween({ alpha: 0.7, time: 0.7 })
    }
    
    override public function get width():Number { return this.bg.width }
    override public function set width(value:Number):void {
      this.bg.width = value
      this.resize_control.x = value - 15
      this.close.x = value - 22
    }
    
    override public function get height():Number { return this.bg.height }
    override public function set height(value:Number):void{
      this.bg.height = value
      this.resize_control.y = value -15
    }
    
  }
}