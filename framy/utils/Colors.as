package framy.utils 
{
	import framy.errors.StaticClassError;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class Colors 
	{
		static private var colors:Hash = new Hash( {
			'aqua': 		0x00ffff,
			'black':		0x000000,
			'blue':			0x0000ff,
			'brown':		0xa52a2a,
			'cyan':			0x00ffff,
			'dark_blue':	0x00008b,
			'dark_cyan':	0x008b8b,
			'dark_gray':	0xa9a9a9,
			'dark_grey':	0xa9a9a9,
			'dark_green':	0x006400,
			'dark_magenta':	0x8b008b,
			'dark_red':		0x8b0000,
			'deep_pink':	0xff1493,
			'gold':			0xffd700,
			'gray':			0x808080,
			'grey':			0x808080,
			'green':		0x008000,
			'green_yellow':	0xadff2f,
			'light_blue':	0xadd8e6,
			'light_cyan':	0xe0ffff,
			'light_gray':	0xd3d3d3,
			'light_grey':	0xd3d3d3,
			'light_green':	0x90ee90,
			'light_pink':	0xffb6c1,
			'light_yellow':	0xffffe0,
			'lime':			0x00ff00,
			'lime_green':	0x32cd32,
			'magenta':		0xff00ff,
			'pink':			0xffc0cb,
			'red':			0xff0000,
			'yellow':		0xffff00,
			'white':		0xffffff
		})

		static public const TYPE_INT:String = 'int'
		static public const TYPE_HTML:String = 'html'
		
		public function Colors() { throw new StaticClassError() }
		static public function setColors(colors:Object):void {
			for (var n:String in colors) Colors.set(n,colors[n])
		}
		
		static public function set(name:String, c:*):void {
			colors[name] = (c is String) ? Number('0x'+(c as String).toUpperCase().match(/^\#?([\dA-F]+)$/)[1]) : c
		}
		
		static public function convertColors(hash:Hash, type:String = 'int'):Hash {
			for ( var n:String in hash)if(n == '_color' || n == 'color' || n == 'backgroundColor' || n == 'borderColor')hash[n] = Colors.get(hash[n],type)
			return hash
		}
		
		static public function get(name:*, type:String = 'int'):* {
			if(!(name is String))return name
			switch(type) {
				case TYPE_HTML:
					return '#' + colors[name].toString(16);
				break;
				case TYPE_INT:
				default :
					return colors[name];
			}
		}
	}
	
}