package framy.animation 
{
	import framy.structure.Partial;
	
	/**
	 *  This is used to create groups of WidgetTweens by assigning them common options
	 *  @author IvanK (ikerin@gmail.com)
	 */
	public class TweenGroup 
	{
		private var _tweens:Array = new Array()
		
		/**
		 *	The first argument must be a hash, everything else is a child (tween, partial or another tween group). The first argument is then applyed
		 *	to all children using the 'setOptions' method of WidgetTween
		 *	@example Basic usage:<listing version="3.0">
this.setTweens(
  new TweenGroup( { from: ['about', 'news' ] },
    new WidgetTween( 'menu_interface', { time: 0.5 } ),
    new WidgetTween( 'menu_interface.menu_bg', { time: 0.5 } ),
    new TweenGroup( { view: 'destroy' },
      new WidgetTween( 'menu_interface.about_menu', {}, { time: 0.5 }),
      new WidgetTween( 'menu_interface.news_menu', {}, { time: 0.5 }),
      new WidgetTween( 'page_bg', {}, { time: 0.5 })
    )
  )
)
	     *  </listing>
		 *	@constructor
		 */
		public function TweenGroup(...arguments) 
		{
			var args:Array = arguments.slice(1)
			for each( var t:* in args) {
				if (t is TweenGroup || t is Partial) _tweens = _tweens.concat(t.tweens)
				else tweens.push(t)
			}
			for each( var w:WidgetTween in _tweens) {
				w.setOptions(arguments[0])
			}
		}
		
		/**
		 *	@private
		 */
		public function get tweens():Array { return _tweens }
		
	}
	
}