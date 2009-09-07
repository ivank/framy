package framy.debug 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import framy.graphics.fySprite;
	import framy.structure.RootWidgetContainer;
	
	/**
	 * ...
	 * @author IvanK
	 */
	internal class DebugVerticalGuide extends fySprite
	{
		private var guide:fySprite
		private var close:CloseDebugWindowBtn
		
		public function DebugVerticalGuide(title:String) 
		{
			this.guide = fySprite.newRect( { height:RootWidgetContainer.stageHeight, width: 1, color: 'yellow' }, {x: Math.round(RootWidgetContainer.stageWidth/2) } )
			this.close = new CloseDebugWindowBtn().setAttrs({x:3,y:3})
			this.close.addEventListener(MouseEvent.CLICK, this._onCloseWindow)
			this.close.hitarea.tween({ x:-3,y:-3, width:16,height:16,alpha:1, _color:'yellow'})
			this.guide.addChildren(
				fySprite.newRect( { height: RootWidgetContainer.stageHeight, width:11, x: -5 } ).setAttrs( { alpha:0 } ),
				this.close
			)
			
			this.addChildren(this.guide)
			this.guide.buttonMode = true
			this.guide.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown)
			this.guide.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp)
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			this.guide.stopDrag()
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			this.guide.startDrag(false, new Rectangle(0,0,RootWidgetContainer.stageWidth,0))
		}
		
		private function _onCloseWindow(event:MouseEvent):void{
		  this.parent.removeChild(this)
		}
		
	}
	
}