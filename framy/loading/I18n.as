package framy.loading {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.text.TextField
	import flash.events.Event
	import flash.utils.Timer;
	import framy.events.ActionEvent;
	import framy.events.ChangeStartEvent;
	import framy.texts.SwitchEffect
	
	/**
	 * Handles internalization 
	 * you can add ActionText objects to it, and when a language change is initiated, it will update all associated text objects
	 * 
	 * fires ChangeStartEvent on the start of the language change, which holds the new height (of dynamically sized texts) 
	 * which the text will have when the change is complete
	 * fires ActionEvent.I18N_CHANGE_COMPLETE on the completion of the language change from each associated text object, as well as the stage itself (useful for global actions)
	 * 
	 * @author Ivan K
	 */
	public class I18n {
		static private var fields:Dictionary = new Dictionary(true)
		static private var html_fields:Array = new Array()
		
		static public var CHANGE_TIME:Number = 0.5
		
		static public var lang:String = "en"
		static public var stage:Stage
		
		/**
		 * Make a textfield changable
		 * assign content to the textfield, in the form of an XML parent node, and the name of the child node
		 * so [xml.node, 'title'] 
		 * will chose the appropriate title for the current language from the xml
		 * <node>
		 * 	<title lang="bg">Some bulgarian title</title>
		 * 	<title lang="en">Some english title</title>
		 * </node>
		 * @param	txt			the text field
		 * @param	content		the content, as Array 
		 * @param	html 		whether the text is html
		 * @return
		 */
		static public function add(txt:TextField, content:*, html:Boolean = false):String {
			fields[txt] = content
			if (html) html_fields.push(txt)
			return _(content)
		}
		
		static public function remove(txt:TextField):void{
			if(html_fields.indexOf(txt) >=0)delete html_fields[html_fields.indexOf(txt)]
			delete fields[txt]
		}
		
		static public function change_content(txt:TextField, content:*):void{
			fields[txt] = content
		}
		
		static public function _(content:Array):String {
			var c:XMLList = (content[0])[content[1] as String].(@lang == I18n.lang)
			return (c && c.length()) ? c[0].text() : 'not translated'
		}
		
		static public function extract(content:*):String {
			return content is Array ? _(content) : content
		}
		
		static public function has(content:Array):String {
			var c:XMLList = (content[0])[content[1] as String].(@lang == I18n.lang)
			return c && c.length() && c[0]
		}
		
		static public function translated(field:TextField):Boolean {
			return Boolean(fields[field])
		}
		
		static public function changeLangTo(lang:String):void{
			I18n.lang = lang
			var timer:Timer = new Timer(CHANGE_TIME * 1000 + 50, 1)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void { I18n.stage.dispatchEvent(new Event(ActionEvent.I18N_CHANGE_COMPLETE)) } )
			
			for (var t:* in fields) {
				if (t.stage) {
					var old_index:int = t.parent.getChildIndex(t)
					var old_parent:DisplayObjectContainer = t.parent
					var old_text:String = t.text
					
					t.parent.removeChild(t)
					t.text = _(fields[t])
					
					t.dispatchEvent(new ChangeStartEvent(t.width, t.height))
					t.text = old_text
					old_parent.addChildAt(t,old_index)
					
				}else {
					t.dispatchEvent(new ChangeStartEvent())
				}
				
				var fx:SwitchEffect = new SwitchEffect(t, {time:CHANGE_TIME, noise:1, html: (html_fields.indexOf(t) >=0)})
				
				fx.addEventListener(ActionEvent.EFFECT_COMPLETE, function(e:Event):void {
					(e.target as SwitchEffect).field.dispatchEvent(new Event(ActionEvent.I18N_CHANGE_COMPLETE))
				})
				fx.start(_(fields[t]))
			}
			timer.start()
			stage.dispatchEvent(new ChangeStartEvent())
		}
	}
	
}
