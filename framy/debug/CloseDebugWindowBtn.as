package framy.debug
{
  import framy.graphics.Label;
  import framy.graphics.fySprite;
  
  internal class CloseDebugWindowBtn extends Label
  {
    public function CloseDebugWindowBtn()
    {
      var content:fySprite = fySprite.newRect({width:20, height:20, alpha: 0})
      
      content.graphics.lineStyle(2, 0xFF0000)
      content.graphics.moveTo(5,5)
      content.graphics.lineTo(15,15)
      content.graphics.moveTo(15,5)
      content.graphics.lineTo(5,15)
      super(content, { _brightness: 0 }, {_brightness: 0.3 })
    }

  }
}