package framy.structure
{
  import flash.display.Sprite;
  
  public class SpriteWidgetContainer extends WidgetContainer
  {
    public function SpriteWidgetContainer(container:Sprite,path:String, parent:Widget = null)
    {
		super(container,path,parent)
    }
    
    override public function addChild(child:*):*{return (this.container as Sprite).addChild(child) }
    override public function removeChild(child:*):*{return (this.container as Sprite).removeChild(child) }
    override public function addChildAt(child:*, index:int):*{return (this.container as Sprite).addChildAt(child, index) }
  }
}