package framy.graphics.reflection {
	import framy.loading.ExternalImage;
	import flash.events.Event;
	import framy.tools.Options;
	/**
	* ...
	* @author Ivan K (ikerin@gmail.com)
	*/
	public class ImageWithReflection extends ExternalImage{
		private var _reflection:Reflection;
		protected var reflection_type:String 
		
		static public const BITMAP:String = "BitmapReflection"
		static public const DYNAMIC:String = "DynamicReflection"
		
		public function ImageWithReflection(file:String, opts:Object = null) {
			this.options = new Options(opts, { bitmap:true, reflection: true, reflection_type:BITMAP } )
			
			this.reflection_type = options.reflection_type
			delete options.reflection_type
			
			if (this.options.reflection) {
				this.addEventListener(Event.COMPLETE, this.createReflection)
				delete this.options.reflection
			}
			super(file, this.options)
		}
		
		override public function get image_height():uint { return super.image_height; }
		
		override public function set image_height(value:uint):* {
			super.image_height = value
			if (this.reflection) {
				this.reflection.y = value
				if(this.reflection is DynamicReflection)(this.reflection as DynamicReflection).content_height = value;
			}
			return value
		}
		
		override public function get image_width():uint { return super.image_width; }
		
		override public function set image_width(value:uint):* {
			super.image_width = value
			if (this.reflection )this.reflection.content_width = value;
			
			return value;
		}
		
		private function createReflection(event:Event):void {
			switch(this.reflection_type) {
				case DYNAMIC: this._reflection = new DynamicReflection(this.bitmap_content, this.options); break;
				case BITMAP: this._reflection = new BitmapReflection(this.bitmap_content, this.options); break;
			}
			this.reflection.y = this.image_height
			this.reflection.content_width = this.image_width
			this.addChild(this.reflection)
		}
		
		public function get reflection():Reflection {
			return _reflection
		}
	}
	
}