package framy.structure 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framy.events.ModelEvent;
	import framy.model.Model;
	import br.com.stimuli.loading.BulkProgressEvent
	import framy.routing.Router;
	
	/**
	 *  This class represents a single "page" of the site
	 *	
	 *  @author IvanK (ikerin@gmail.com)
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9
	 */
	public class Loading extends Page
	{
		
		public function Loading()  
		{
			Model.addEventListener(BulkProgressEvent.PROGRESS, this.onModelXMLProgress)
			Model.addEventListener(Model.XML_COMPLETE, this.onModelXMLEvent)
			Model.addEventListener(Model.ALL_COMPLETE, this.onModelXMLComplete)
			
		}
		
		private function onModelXMLProgress(event:BulkProgressEvent):void
		{
			Loading.dispatchRenamedEvent(this, event, ModelEvent.PROGRESS)
			
			for each(var widget_view:WidgetView in this.getElements()) {
				var widget_content:EventDispatcher = RootWidgetContainer.getContent(widget_view.full_name);
				if (widget_content is EventDispatcher)Loading.dispatchRenamedEvent(widget_content, event, ModelEvent.PROGRESS)
			}
			
		}
		
		private function onModelXMLEvent(event:Event):void
		{
			this.dispatchEvent(event)
			
			for each(var widget_view:WidgetView in this.getElements()) {
				var widget_content:EventDispatcher = RootWidgetContainer.getContent(widget_view.full_name);
				if (widget_content is EventDispatcher)widget_content.dispatchEvent(event)
			}
		}		
		
		private function onModelXMLComplete(event:Event):void {
			this.onModelXMLEvent(event)
			Router.init()
		}
		
		static private function dispatchRenamedEvent(dispatcher:EventDispatcher, event:Event, new_name:String):void {
			var progress_event:* = event.clone()
			progress_event.name = new_name				
			dispatcher.dispatchEvent(progress_event)
		}
		
	}
	
}