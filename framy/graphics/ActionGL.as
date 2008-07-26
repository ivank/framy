package framy.graphics {
	import flash.display.Graphics
	import flash.display.Sprite
	import flash.geom.Point;
	import framy.tools.Options

	/**
	* Simplified graphic library (easer interface)
	* @author Default
	* @version 0.1
	*/
	public class ActionGL {
		private var graphics:Graphics
		public function ActionGL(scope:Sprite){
			this.graphics = scope.graphics
		}
		
		public function rect(opts:Object = null):void{
			var options:Options = new Options(opts,{size:50, from:[0,0], color:Colors.BLACK, alpha: 1.0})
			
			options.parse_size()
			this.fill(options)
			this.graphics.drawRect(options.from[0],options.from[1],options.width,options.height)
			this.graphics.endFill()
		}
		
		public function frame(opts:Object = null):void{
			var options:Options = new Options(opts,{size:50, from:[0,0], color:Colors.BLACK, alpha: 1.0, line_width:1})
			options.parse_size()
			this.fill(options)
			this.graphics.drawRect(options.from[0],options.from[1],options.width,options.height)
			this.graphics.drawRect(
				options.from[0]+options.line_width,
				options.from[1]+options.line_width,
				options.width-options.line_width*2,
				options.height-options.line_width*2)
			this.graphics.endFill()
		}
		
		public function circle(opts:Object = null):void{
			var options:Options = new Options(opts,{radius:50, x:0, y:0, color:Colors.BLACK, alpha: 1.0})
			
			options.parse_pos()
			this.fill(options)
			this.graphics.drawCircle(options.x,options.y,options.radius)
			this.graphics.endFill()
		}
		
		public function round_corner(opts:Object):void {
			var options:Options = new Options(opts, { radius:50, x:0, y:0, color:Colors.BLACK, alpha: 1.0 } )
			this.fill(options)
			
			var controlOffset:Number = Math.sin(24*Math.PI/180)*options.radius;
			
			this.graphics.moveTo(options.x, options.y)
			this.graphics.lineTo(options.x, options.y - options.radius)
			this.graphics.curveTo(options.x + controlOffset, options.y - options.radius, options.x + Math.cos(45 * Math.PI / 180) * options.radius, options.y - Math.sin(45 * Math.PI / 180) * options.radius);
			this.graphics.curveTo(options.x + options.radius, options.y - controlOffset, options.x+options.radius, options.y);
			this.graphics.lineTo(options.x, options.y)
			this.graphics.endFill()
		}
		
		private function fill(options:Options):void{
			this.graphics.beginFill(options.color,options.alpha)
			if(options.line !== undefined)this.line_style(options.line)
		}
		
		
		
		private function line_style(opts:*):void{
			if(opts is uint)opts = {width:1, color:opts}
			
			
			var options:Options = new Options(opts,{
				width:0, 
				color:Colors.WHITE, 
				alpha: 1.0, 
				pixelHinting: false, 
				scaleMode: 'noraml',
				caps: null,
				joints: null
			})
			
			this.graphics.lineStyle(options.width, options.color, options.alpha, options.pixelHinting, options.scaleMode, options.caps, options.joints)
		}
		
		
	}
	
}
