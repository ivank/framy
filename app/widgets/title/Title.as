package app.widgets.title
{	
	import framy.graphics.fySprite
	import framy.utils.Hash
	import framy.graphics.fyTextField
	
	public class Title extends fySprite
	{
		public var title:fyTextField
		
		public function Title()
		{
			this.addChild(new fyTextField('normal',{ text: 'MyTitle' }))
		}

	}
}