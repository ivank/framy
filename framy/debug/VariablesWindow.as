package framy.debug 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import framy.graphics.fyTextField;
	import framy.utils.Hash;
	import framy.structure.Initializer;
	
	/**
	 * ...
	 * @author IvanK
	 */
	internal class VariablesWindow extends DebugWindow
	{
		
		private var variables:Hash = new Hash()
		private var labels:Array = new Array()
		private var update_btn:DebugBtn
		private var focused_field:fyTextField
		
		public function VariablesWindow(title:String) 
		{
			super(title)
			
			this.update_btn = new DebugBtn('UPDATE', null, 60).setAttrs( { x: 200, y: 30 } )
			this.update_btn.addEventListener(MouseEvent.CLICK, this.onUpdateClick)
			
			DebugPanel.variables.eachPair(function(name:String, value:*):void {
				this.labels.push(new fyTextField('normal', {width: 200, height: 17, x:20, y:30 + this.variables.length*45, text: name}, Initializer.options.debug.text_font))
				this.variables[name] = new fyTextField('normal', 
					{ width: 100, height:18, x:20, y:44 + this.variables.length*45, text: value },
					new Hash(Initializer.options.debug.text_font).merge({ wordWrap: false, multiline: false, border:true, borderColor: 'black', type: TextFieldType.INPUT, selectable:true, autoSize: 'none', size:12, color: 'black', backgroundColor:'white', background: true })
				)
				this.variables[name].addEventListener(KeyboardEvent.KEY_UP, this.onFieldKeyPress)
				
			}, this)
			
			this.addChildren(this.update_btn, this.variables.values, this.labels)
			
			this.attrs = { width: 340, height: 400 };
		}
		
		private function onFieldKeyPress(event:KeyboardEvent):void
		{
			var txt:String = (event.target as fyTextField).text
			var num:Number = Number(txt)
			
			var increment:Number = 1
			var percision:int = 0
			if (txt.match(/\./))increment = 0.01;
			
			if (event.keyCode == Keyboard.UP) num += increment;
			else if (event.keyCode == Keyboard.DOWN) num -= increment;
			
			if (event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN) {
				(event.target as fyTextField).text = String(num)
				this.stage.dispatchEvent(new Event(Event.RESIZE))
			}
			
		}
		
		
		private function onUpdateClick(event:MouseEvent):void
		{
			this.stage.dispatchEvent(new Event(Event.RESIZE))
		}
		
		override public function set width(value:Number):void{
			super.width = value
			this.update_btn.x = value - this.update_btn.width - 20
			for each( var v:fyTextField in this.variables)
				v.width = value - 120
		}

		override public function set height(value:Number):void{
			super.height = value
		}
		
		public function getVariable(name:String):Number {
			return Number((this.variables[name] as fyTextField).text)
		}
		
		

		
	}
	
}