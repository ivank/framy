package framy.loading {
	import flash.system.Capabilities;
	import framy.tools.Options;

	/**
	* Simple collection of attributes for the assets to be loaded, grouped by "environment"
	* host property is used for a prefix for every ExternalImage (http:// added automaticaly)
	* xml property is used for the address of the xml document
	* if no environment is selected, it makes some simple guesses about it 
	* (if it's a stendalone player, it's DEVELOPMENT, otherwise - PRODUCTION)
	* 
	* Extend this class, and override the "calculate" method for your custom calculations
	* @author Ivan K
	*/
	public class Environment {
		public static const TEST:uint = 0
		public static const DEVELOPMENT:uint = 1
		public static const LOCAL:uint = 2
		public static const PRODUCTION:uint = 3
		
		public var host:String
		public var xml:String
		
		public function Environment(opts:Object=null){
			var options:Options = new Options(opts, { } )
			this.host = options.host || 'localhost'
			this.xml = options.xml || 'localhost/xml'
			
			if (this.xml.indexOf('http://') < 0) this.xml = 'http://' + this.xml
			if (this.host.indexOf('http://') < 0) this.host = 'http://' + this.host
		}
		
		static public function guess_type():uint {
			
			if(Capabilities.playerType == "StandAlone" || Capabilities.playerType == "External")return DEVELOPMENT
			else return PRODUCTION
		}
		
	}
	
}

