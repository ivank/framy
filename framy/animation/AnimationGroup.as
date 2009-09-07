package framy.animation 
{
	import framy.structure.Partial;
	
	/**
	 *  This is used to create groups of WidgetTweens by assigning them common options
	 *  @author IvanK (ikerin@gmail.com)
	 */
	public class AnimationGroup 
	{
		private var _animations:Array = new Array()
		
		/**
		 *	The first argument must be a hash, everything else is a child (animation, partial or another animation group). The first argument is then applyed
		 *	to all children using the 'setOptions' method of WidgetTween
		 *	@example Basic usage:<listing version="3.0">
this.setTweens(
  new AnimationGroup( { from: ['about', 'news' ] },
    new Animation( 'menu_interface', { time: 0.5 } ),
    new Animation( 'menu_interface.menu_bg', { time: 0.5 } ),
    new AnimationGroup( { view: 'destroy' },
      new Animation( 'menu_interface.about_menu', {}, { time: 0.5 }),
      new Animation( 'menu_interface.news_menu', {}, { time: 0.5 }),
      new Animation( 'page_bg', {}, { time: 0.5 })
    )
  )
)
	     *  </listing>
		 *	@constructor
		 */
		public function AnimationGroup(...arguments) 
		{
			var children:Array = arguments.slice(1)
			for each( var t:* in children) {
				if (t is AnimationGroup || t is Partial) _animations = _animations.concat(t._animations)
				else _animations.push(t)
			}
			for each( var w:Animation in _animations) {
				w.setOptions(arguments[0])
			}
		}
		
		/**
		 *	@private
		 */
		public function get animations():Array { return _animations }
		
	}
	
}