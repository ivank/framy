package framy.debug
{
	import framy.graphics.fySprite;
	import framy.graphics.fyTextField;
	import framy.structure.Widget;
	import framy.structure.Initializer;
	import framy.utils.Hash;
  
  	internal class DebugWidget extends fySprite
  	{
		private var title:fyTextField
		public function DebugWidget(widget:Widget)
		{
			this.title = new fyTextField('normal', { width: 70, y:1, text: widget.name, x: 7 }, new Hash(Initializer.options.debug.text_font).merge({ size: 12}))
		}

	}
}