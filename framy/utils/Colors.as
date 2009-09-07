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
			'darkblue':		0x00008b,
			'darkcyan':		0x008b8b,
			'darkgray':		0xa9a9a9,
			'darkgrey':		0xa9a9a9,
			'darkgreen':	0x006400,
			'darkmagenta':	0x8b008b,
			'darkred':		0x8b0000,
			'deeppink':		0xff1493,
			'gold':			0xffd700,
			'gray':			0x808080,
			'grey':			0x808080,
			'green':		0x008000,
			'greenyellow':	0xadff2f,
			'lightblue':	0xadd8e6,
			'lightcyan':	0xe0ffff,
			'lightgray':	0xd3d3d3,
			'lightgrey':	0xd3d3d3,
			'lightgreen':	0x90ee90,
			'lightpink':	0xffb6c1,
			'lightyellow':	0xffffe0,
			'lime':			0x00ff00,
			'limegreen':	0x32cd32,
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
			if (c is String) {
				var color_num:Array = (c as String).toUpperCase().match(/^\#?([\dA-F]+)$/)
				if (color_num) {
					colors[name] = Number('0x'+color_num[1])
				}else {
					colors[name] = get(c)
				}
			}else {
				colors[name] = c
			}
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