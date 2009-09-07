package
{
	import app.loaders.*;
	import app.pages.*;
	import app.widgets.title.Title;
	import caurina.transitions.properties.*;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	import framy.routing.Route;
	import framy.routing.Router;
	import framy.structure.Initializer;
	import framy.structure.RootWidgetContainer;
	import framy.utils.Aspect;
	import framy.utils.Colors;
	import flash.events.Event;
	import framy.debug.DebugPanel;
	import framy.model.Model;
	
	[SWF(width=990,height=630)]
	
	/**
	 * Starting Point of the application
	 * This is where you commonly put your embeds, routes and load the content xml
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Main extends Initializer 
	{
		
		
		/**
		 *	@inheritDoc
		 */
		override protected function init():void
		{
			DebugPanel.create(this.stage)
			DisplayShortcuts.init()
			ColorShortcuts.init()
			TextShortcuts.init();
			MacMouseWheel.setup(this.stage);
			
			Colors.setColors( {
				main: 'gray',
				text: 'lightgray',
				active: 'gold',
				over: 'red',
				bg: 'white'
			})
			
			this.setFonts( {
				normal: { font: 'Arial', color: 'main', size: 12 },
				normal_text: { css: { strong: { bold: true, color: 'text'} , p: {} } }
			})
			
			//this.setOptions()
			
			//========== LOADERS ======================
			
			//========== PAGES ======================
			HomepagePage, LoadingPage
			
			//========== WIDGETS ======================
			Title
			
			RootWidgetContainer.addEventListener(RootWidgetContainer.START_RESIZE, this.onResize)
			

			//Model.loadData('http://host.local/xml', function():void {
				//code to exeute when loaded
			//})
			
			Router.addRoutes(
				new Route('/', 'homepage')
			)
			
			Router.redirectTo('loading')
			
			this.onResize()
			
		}
		
		/**
		 *	This is where you change the parameters, affecting the positioning of the elements
		 */
		private function onResize(event:Event=null):void {
			
		}
	}
	
}