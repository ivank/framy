package app.pages 
{
	import framy.animation.Animation;
	import framy.structure.Page;
	import framy.structure.WidgetView;
	
	public class HomepagePage extends Page
	{
		
		public function HomepagePage() 
		{
			this.setTitle('Framy Project')
			
			this.setElements(
				new WidgetView('title','show',{ x: 'center', y: 'center' })
			)
			
			this.setAnimation(
				new Animation('title', { position: { alpha: 0 } }, { position: { alpha:1, time: 1 } } ).setOptions( { from: 'loading' } )
			)
		}
	}
	
}