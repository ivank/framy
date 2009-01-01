package framy.debug 
{
	import framy.graphics.fyTextField;
	import framy.utils.Hash;
	import framy.structure.Initializer;
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	internal class ConsoleWindow extends DebugWindow
	{
		private var text:fyTextField
		
		public function ConsoleWindow(title:String) 
		{
			super(title)
			this.text = new fyTextField('normal', 
				{ width: 300, height:500, x:20, y:20 }, 
				new Hash(Initializer.options.debug.text_font).merge({ wordWrap: false, multiline: true, border:true, borderColor: 'black', selectable:true, autoSize: 'none', size:10, color: 'black', backgroundColor:'white', background: true })
			)
			this.addChild(this.text)
			this.update()
			this.attrs = { width: 440, height: 240 };
		}
		
		override public function set width(value:Number):void{
			super.width = value
			this.text.width = value-40
		}

		override public function set height(value:Number):void{
			super.height = value
			this.text.height = value-40
		}
		
		public function update():void {
			this.text.text = DebugPanel.log_messages.join("\n")
			this.text.scrollV = this.text.maxScrollV
		}
		
	}
	
}