package framy {
	import framy.graphics.Colors;
	import framy.tools.Options;

	public class Rect extends ActionSprite{
		public function Rect(opts:Object) {
			this.draw.rect(new Options(opts,{color:Colors.PINK, alpha:1}))
		}
	}
}
