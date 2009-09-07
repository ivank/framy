package framy.debug
{
  import framy.graphics.Label;
  import framy.graphics.fySprite;
  
  internal class CloseDebugWindowBtn extends Label
  {
    public function CloseDebugWindowBtn()
    {
		super(
			fySprite.newCross( { width: 10, height: 10, color: 'red', line_thickness: 2 } ), 
			{ _brightness: 0 }, 
			{ _brightness: 0.3 } 
		)
		this.hitarea.setAttrs({x:-5,y:-5, width: 20, height:20 })
    }
  }
}