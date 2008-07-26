package framy.tools {

	public class Html {
		
		public function Html() {
			
		}
		
		static public function color(hex:Number):String {
			if(hex == 0) return '#000000'
			else return '#'+hex.toString(16)
		}
		
		static public function close_dangling_tags(txt:String):String{
			txt = txt.replace(/<\/?[a-z\s\"\'=]*$/,'')
			
			var opened_tags:Array = txt.match(/<([a-z]+)( .*)?(?!\/)>/g) || []
			var closed_tags:Array = txt.match(/<\/([a-z]+)>/g) || []
			opened_tags = opened_tags.map(function(e:String,i:int,t:*):String{return e.match(/<([a-z]+)( .*)?(?!\/)>/)[1]})
			closed_tags = closed_tags.map(function(e:String,i:int,t:*):String{return e.match(/<\/([a-z]+)>/)[1]})
			
			if(opened_tags.length == closed_tags.length)return txt
			opened_tags = opened_tags.reverse()
			for(var i:int = 0; i < opened_tags.length; i++){
				var index:int = closed_tags.indexOf(opened_tags[i])
				if(index<0)txt += '</'+opened_tags[i]+'>'
				else delete closed_tags[index]
			}
			
			return txt
		}		
	}
	
}
