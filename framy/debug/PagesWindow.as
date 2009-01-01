package framy.debug
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import framy.graphics.fyTextField;
	import framy.routing.Router;
	import framy.utils.Hash;
	import swfaddress.SWFAddress;
	import swfaddress.SWFAddressEvent;
	import framy.structure.Initializer;
	
	internal class PagesWindow extends DebugWindow
	{
		private var address:fyTextField
		private var goto_btn:DebugBtn

		public function PagesWindow(title:String)
		{
			super(title)
			
			this.address = new fyTextField('normal', 
				{ width: 300, height:18, x:20, y:20, text: SWFAddress.getValue() }, 
				new Hash(Initializer.options.debug.text_font).merge({ wordWrap: false, multiline: false, border:true, borderColor: 'black', type: TextFieldType.INPUT, selectable:true, autoSize: 'none', size:12, color: 'black', backgroundColor:'white', background: true })
			)
			this.goto_btn = new DebugBtn('CHANGE').setAttrs({ y: 20 })
			this.goto_btn.addEventListener(MouseEvent.CLICK, this.onGotoClick)
			
			this.addChildren(this.address, this.goto_btn)
			
			this.attrs = { width: 600, height: 140 };
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.onChange)
			
		}
		
		override public function set width(value:Number):void{
			super.width = value
			this.address.width = value - 40 - this.goto_btn.width
			this.goto_btn.x = value - 20 - this.goto_btn.width
		}

		override public function set height(value:Number):void{
			super.height = value
		}
		
		public function onGotoClick(event:Event):void {
			SWFAddress.setValue(this.address.text)
		}
		
		public function onChange(event:Event):void {
			this.address.text = SWFAddress.getValue()
		}		

	}
}