package framy.debug
{
  import flash.events.Event;
  
  import framy.routing.Router;
  import framy.structure.RootWidgetContainer;
  
  internal class WidgetsWindow extends DebugWindow
  {

    public function WidgetsWindow(title:String)
    {
      super(title)
      Router.addEventListener(Event.CHANGE, this.onStateChange)
      this.attrs = { width: 340, height: 540 };
    }
    
    private function onStateChange(event:Event):void{
      
    }

  }
}