package app.pages 
{
	import framy.animation.TweenGroup;
	import framy.animation.WidgetTween;
	import framy.structure.Page;
	import framy.structure.WidgetView;
	
	public class HomepagePage extends Page
	{
		
		public function HomepagePage(name:String, parameters:Object=null) 
		{
			super(name, parameters)
			
			this.setTitle('Framy Project')
			
			this.setWidgetViews(
				new WidgetView('title','show',{ x: 50, y: 50 })
			)
			//this.setTweens()
		}
	}
	
}