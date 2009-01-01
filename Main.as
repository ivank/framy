package
{
	import app.pages.*;
	import caurina.transitions.properties.*;
	import framy.routing.Route;
	import framy.routing.Router;
	import framy.structure.Initializer;
	import framy.structure.RootWidgetContainer;
	import framy.utils.Colors;
	import flash.events.Event;
	import framy.debug.DebugPanel;
	
	import app.widgets.title.Title;
	
	[SWF(width=990,height=720)]
	
	/**
	 * 	Starting Point of the application
	 *	This is where you commonly put your embeds, routes and load the content xml
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Main extends Initializer 
	{
		[Embed(source = 'library/Helvetica Neue.ttf', fontWeight = 'normal', fontFamily = "NormalFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF')]
		public static const NORMAL_FONT:String;
		
		/**
		 *	@inheritDoc
		 */
		override protected function init():void
		{
			//DebugPanel.create(this.stage)
			Colors.setColors( {
				main: '#6F6E6C',
				active: '#FFFF00',
				over: '#FFFFFF',
				bg: '#110F0D'
			})
			
			//this.setOptions()
			Router.addRoutes(
				new Route('/', 'homepage')
			)
			
			//========== PAGES ======================
			HomepagePage, Title
			
			//========== WIDGETS ======================
			//...
			
			RootWidgetContainer.addEventListener(RootWidgetContainer.START_RESIZE, this.onResize)
			this.onResize()
			Router.init()
		}
		
		/**
		 *	This is where you change the parameters, affecting the positioning of the elements
		 */
		private function onResize(event:Event=null):void {
			
		}
		
	}
	
}