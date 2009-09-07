package framy.structure 
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import framy.events.WidgetLoaderEvent;
	import framy.routing.Router;
	import framy.utils.ArrayTools;
	import framy.utils.Hash;
	import framy.utils.StringTools;
	
	/**
	 * This class is used to acomplish in-site loading, basically you couple a widget (from the page class) with a loader
	 * and then it sends progress and complete events
	 * @author IvanK
	 */
	public class WidgetLoader extends BulkLoader
	{
		static public function register(name:String, unique_name:String, widget_content:*):void {
			
			var create_loader:Boolean = false
			if (!WidgetLoader.get(unique_name)) {
				create_loader = true
				var c:Class = WidgetLoader.getClass(name)
				WidgetLoader.loaders[unique_name] = new c()	
				WidgetLoader.loaders[unique_name].loader_name = unique_name
			}
			loaders_content[widget_content] = WidgetLoader.get(unique_name)
			if (!loaders_count[WidgetLoader.get(unique_name)]) loaders_count[WidgetLoader.get(unique_name)] = new Array()
			if (!ArrayTools.has(loaders_count[WidgetLoader.get(unique_name)], widget_content)) loaders_count[WidgetLoader.get(unique_name)].push(widget_content)
			
			widget_content.dispatchEvent(new WidgetLoaderEvent(WidgetLoaderEvent.ASSIGNED, WidgetLoader.get(unique_name), create_loader))
		}
		
		static public function unregister(content:*):void {
			loaders_count[WidgetLoader.get(content)] = ArrayTools.remove(loaders_count[WidgetLoader.get(content)], content)
			
			if (ArrayTools.is_empty(loaders_count[WidgetLoader.get(content)])) {
				loaders_count[WidgetLoader.get(content)] = null
				WidgetLoader.get(content).destroy()
			}
		}
		
		static public var loaders:Hash = new Hash()
		static public var loaders_count:Dictionary = new Dictionary(true)
		static public var loaders_content:Dictionary = new Dictionary(true)
		
		static public function get(loader_name:*):WidgetLoader {
			if ( loader_name is String) {
				if (WidgetLoader.loaders.has(loader_name)) return WidgetLoader.loaders[loader_name]
				else return null
			}else {
				return loaders_content[loader_name]
			}
			
		}
		
		static public function getClass(loader_name:String):Class {
			try{
				return getDefinitionByName('app.loaders.' + StringTools.classify(loader_name) + 'Loader') as Class
			}catch ( error:Error ) {
				throw new Error ("A loader with the path loader." + StringTools.classify(loader_name) + 'Loader was not found')
			}
			return null
		}
		
		public var loader_name:String
		
		public function WidgetLoader(numConnections : int = BulkLoader.DEFAULT_NUM_CONNECTIONS, logLevel : int = BulkLoader.DEFAULT_LOG_LEVEL)
		{
			super(BulkLoader.getUniqueName(),numConnections, logLevel)
		}
		
		public function destroy():void {
			WidgetLoader.loaders.remove(StringTools.underscore(loader_name))
			super.clear()
		}
	}
}