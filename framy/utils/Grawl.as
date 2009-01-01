package framy.utils 
{
	import flash.display.DisplayObjectContainer;
	import framy.structure.Initializer;
	import framy.structure.RootWidgetContainer;
	import framy.utils.Hash;
	import framy.graphics.fySprite;
	import framy.graphics.fyTextField;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Grawl extends fySprite
	{
		static public var stage:DisplayObjectContainer
		
		static public function message(msg:String, opts:Object = null ):Grawl {
			var options:Hash = new Hash(Initializer.options.grawl).merge(opts)
			
			var grawl:Grawl = new Grawl(msg, options);
			(options.stage == null ? RootWidgetContainer.instance : options.stage).addChild(grawl)
			
			grawl.alpha = 0
			grawl.x = options.x || ((options.stage == null ? RootWidgetContainer.stageWidth : options.stage.width) - grawl.width - options.padding)
			grawl.y = options.y || ((options.stage == null ? RootWidgetContainer.stageHeight : options.stage.height) - grawl.height - options.padding)
			
			
			
			grawl.tween(options.tween_in, { alpha: 1 } )
			grawl.tween(options.tween_out, { alpha: 0, delay: options.time + options.tween_in.time, onComplete:function():void { this.parent.removeChild(this) } } )
			return grawl
		}
		
		private var text:fyTextField
		private var bg:fySprite
		
		public function Grawl(msg:String, options:Object=null) 
		{
			var opts:Hash = new Hash(Initializer.options.grawl).merge(options)
			this.text = new fyTextField('normal_text', 
				{ text: msg, width: opts.width, autoSize: 'left', x: opts.padding, y: opts.padding },
				{ color: opts.color } 
			)
			
			this.bg = new fySprite()
			this.bg.graphics.beginFill(opts.bg_color, 1)
			this.bg.graphics.drawRoundRect(0, 0, this.text.width + 2 * opts.padding, this.text.height + 2 * opts.padding, 2 * opts.corner, 2 * opts.corner)
			this.bg.graphics.endFill()
			this.addChildren(this.bg, this.text)
		}
	}
	
}