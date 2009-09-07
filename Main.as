package
{
	import app.loaders.AboutLoader;
	import app.loaders.ListElementLoader;
	import app.loaders.TissueLoader;
	import app.pages.*;
	import app.widgets.about_pages.AboutPages;
	import app.widgets.bg.Bg;
	import app.widgets.big_image.BigImage;
	import app.widgets.contacts.Contacts;
	import app.widgets.controls.Controls;
	import app.widgets.details.Details;
	import app.widgets.list.List;
	import app.widgets.list_element.ListElement;
	import app.widgets.list_image.ListImage;
	import app.widgets.loading.Loading;
	import app.widgets.tissue_collections.TissueCollections;
	import app.widgets.tissues.Tissues;
	import caurina.transitions.properties.*;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import framy.routing.Route;
	import framy.routing.Router;
	import framy.structure.Initializer;
	import framy.structure.RootWidgetContainer;
	import framy.utils.Aspect;
	import framy.utils.Colors;
	import flash.events.Event;
	import framy.debug.DebugPanel;
	import framy.model.Model;
	
	import app.widgets.navigation.Navigation;
	
	[SWF(width=990,height=630)]
	
	/**
	 * Starting Point of the application
	 * This is where you commonly put your embeds, routes and load the content xml
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Main extends Initializer 
	{
		[Embed(source='library/Helen Bg Condensed.ttf', fontFamily = "MenuFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF,U+0410-U+044F')]
		public static const MENU_FONT:String;
		
		[Embed(source='library/Helen Bg Thin.ttf', fontFamily = "AboutFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF,U+0410-U+044F')]
		public static const ABOUT_FONT:String;		
		
		[Embed(source='library/Helen Bg Light_edit.ttf', fontFamily = "TextFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF,U+0410-U+044F')]
		public static const TEXT_FONT:String;

		[Embed(source='library/BepaMono-Roman_BG.ttf', fontFamily = "InfoTextFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF,U+0410-U+044F')]
		public static const INFO_TEXT_FONT:String;
		
		[Embed(source='library/Helen Bg Bold.ttf', fontWeight = 'bold', fontFamily = "TextFontBold", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF,U+0410-U+044F')]
		public static const TEXT_FONT_BOLD:String;
		
		[Embed(source = 'library/BickhamScriptPro-Regular.ttf', fontWeight = 'normal', fontFamily = "FancyFont", mimeType = "application/x-font-truetype", unicodeRange = 'U+0000-U+00FF')]
		public static const ITALIC_FONT:String;
		
		[Embed(source = 'library/library.swf', symbol = 'navigation_bg')]
		public static const NAVIGATION_BG:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'list_arrow')]
		public static const LIST_ARROW:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'list_arrow_slim')]
		public static const LIST_ARROW_SLIM:Class;
		
		
		[Embed(source = 'library/library.swf', symbol = 'icon_list')]
		public static const ICON_LIST:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'circle_icon')]
		public static const ICON_CIRCLE:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'logo')]
		public static const LOGO:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'stripe')]
		public static const BG_STRIPE:Class;	
		
		[Embed(source = 'library/library.swf', symbol = 'details_icon')]
		public static const DETAILS_ICON:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'cursor_zoom')]
		public static const CURSOR_ZOOM:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'cursor_zoom_out')]
		public static const CURSOR_ZOOM_OUT:Class;
		
		[Embed(source = 'library/library.swf', symbol = 'cursor_zoom_white')]
		public static const CURSOR_ZOOM_WHITE:Class;
		
		[Embed(source = 'library/riznlink.swf', symbol = 'riznlogo')]
		public static const RIZN_LOGO:Class;
		
		
		
		/**
		 *	@inheritDoc
		 */
		override protected function init():void
		{
			//DebugPanel.create(this.stage)
			DisplayShortcuts.init()
			ColorShortcuts.init()
			TextShortcuts.init();
			MacMouseWheel.setup(this.stage);
			
			Colors.setColors( {
				main: '#9B9B9B',
				text: '#5B5B5B',
				element: '#9B9B9B', 
				active: '#000000',
				title: '#000000',
				over: '#000000',
				bg: '#FFFFFF'
			})
			
			this.setFonts( {
				normal: { font: 'TextFont', color: 'text', size: 12 },
				bold: { font: 'TextFontBold', bold: true },
				bold_text: { font: 'TextFontBold', bold: true },
				normal_text: { css: { strong: { font: 'TextFontBold', bold: true, color: 'black'} , p: {} } },
				menu: { font: 'MenuFont', size: 13 },
				big_image: { font: 'MenuFont', size: 25, color: 'bg', align: 'center', autoSize: TextFieldAutoSize.NONE },
				home_title: { font:'FancyFont', color: 'title', italic: true, size: 70 },
				circle_title: { font: 'FancyFont', color: 'title', italic: true, size: 36, antiAliasType:AntiAliasType.NORMAL },
				grid_text: { font:'TextFont', color: 'text', italic: true, size: 16, antiAliasType:AntiAliasType.ADVANCED, gridFitType: GridFitType.NONE },
				about_title: { font: 'AboutFont', size: 50, color: 'black' },
				about_text: { color: 'black', size: 18, leading: 5, css: { strong: { font: 'TextFontBold', bold: true, color: 'black'} , p: { } } }
			})
			
			//this.setOptions()
			
			//========== LOADERS ======================
			ListElementLoader, TissueLoader, AboutLoader
			
			//========== PAGES ======================
			HomepagePage, LoadingPage, 
			ElementsGridPage, ElementBigImagePage, ElementImagePage, ElementInfoPage, ElementPage, ElementsCirclePage
			TissuePage, TissueCollectionPage, TissueCollectionsPage, AboutPage, ContactsPage
			
			//========== WIDGETS ======================
			Navigation, Loading, Bg, List, ListElement, ListImage, Details, Tissues, TissueCollections, Controls, BigImage, AboutPages, Contacts
			
			RootWidgetContainer.addEventListener(RootWidgetContainer.START_RESIZE, this.onResize)
			

			Model.loadData('http://luxpac.s803.sureserver.com/xml', function():void {
			//Model.loadData('http://luxpac.com/xml', function():void {
			
				for each(var h:XML in Model.data.homepage_images) 
					Model.loadImage(Model.filename(h.image))
				
				for each(var p:XML in Model.data.packages) 
					Model.loadImage(Model.filename(p.image))
				
				for each(var b:XML in Model.data.boxsets) 
					Model.loadImage(Model.filename(b.image))
				
				for each(var t:XML in Model.data.tissue_collections) 
					if( t.image.toString().length)Model.loadImage(Model.filename(t.image))
				
				
			})
			
			Router.addRoutes(
				new Route('/', 'homepage'),
				new Route('/:fy_culture', 'homepage'),
				new Route('/:fy_culture/:section', 'elements_circle', { section: /boxsets|packages/ } ),
				new Route('/:fy_culture/:section/grid/', 'elements_grid', { section: /boxsets|packages/ } ),
				new Route('/:fy_culture/:section/:element/', 'element', { section: /boxsets|packages/, element: /[a-z\-\d]+/ } ),
				new Route('/:fy_culture/:section/:element/info', 'element_info', { section: /boxsets|packages/, element: /[a-z\-\d]+/ } ),
				new Route('/:fy_culture/:section/:element/:image', 'element_image', { section: /boxsets|packages/, element: /[a-z\-\d]+/ } ),
				new Route('/:fy_culture/:section/:element/:image/zoom', 'element_big_image', { section: /boxsets|packages/, element: /[a-z\-\d]+/ } ),
				
				new Route('/:fy_culture/tissues', 'tissue_collections'),
				new Route('/:fy_culture/tissues/:collection', 'tissue_collection'),
				new Route('/:fy_culture/tissues/:collection/:tissue', 'tissue'),
				
				new Route('/:fy_culture/about/:page', 'about' ),
				new Route('/:fy_culture/contacts', 'contacts')
			)
			
			Router.redirectTo('loading')
			
			this.onResize()
			
		}
		
		/**
		 *	This is where you change the parameters, affecting the positioning of the elements
		 */
		private function onResize(event:Event=null):void {
			
		}
		
		public static function getElement():String {
			return Router.parameters.section.substr(0, Router.parameters.section.length - 1)
		}
		
		public static function resizeImage(aspect:Aspect, width:Number, height: Number, percent:Number=1):Aspect {
			aspect.constrain(Math.min(600, width * 0.75) * percent, Math.min(400, height * 0.75) * percent).center(width, height)
			if ((height - aspect.bottom) < 120)aspect.y = height - aspect.height - 120
			return aspect
		}
	}
	
}