package framy {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	import framy.events.ActionEvent;
	import framy.graphics.ActionGL;
	import framy.graphics.Aspect;
	import framy.loading.Library;
	import framy.tools.Chain;
	import framy.tools.Hash;
	import framy.tools.Options;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import flash.utils.setTimeout;
	import flash.ui.ContextMenu;
	import flash.net.navigateToURL;
	import framy.core.Resizable;
	
	
	/**
	 * Extends the Sprite class, providing some convenience methods
	 * and bindings to other parts of the framework
	 * @author Ivan K
	 */
	public class ActionSprite extends Sprite
	{
		public var draw:ActionGL
		public var resizable:Resizable
		
		
		public function ActionSprite(opts:Object=null){
			this.draw = new ActionGL(this)
			this.attributes = new Options(opts, {} )
			
			this.contextMenu = new ContextMenu()
			this.contextMenu.hideBuiltInItems()
			var made_by_rizn:ContextMenuItem = new ContextMenuItem('Made By Rizn')
			made_by_rizn.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(event:ContextMenuEvent):void{ 
				navigateToURL(new URLRequest('http://www.rizn.info'),'_blank')
			})
			this.contextMenu.customItems.push(made_by_rizn)
		}
		

		/**
		 * The same ass addChild, only it returns the child added (can chain stuff) and can add ActionSprite objects
		 * @param	child
		 * @return	the child added
		 */
		public function addSprite(child:*):ActionSprite{
			this.addChild(child)
			return child
		}
		
		
		
		/**
		 * 'Chain' events - adds a 'chain' of function where each one executes after the previous one is finished
		 * You can define the event that triggers the "finish" of each function
		 * @param	closure
		 * @return
		 */
		public function chain(closure:Function):Chain{  return new Chain(this, closure)  }
		
		public function tween(options:Object):Boolean{
			return Tweener.addTween(this,options)
		}
		
		
		/**
		 * Remove Multiple children
		 * @param	... arguments
		 */
		public function removeChildren(... arguments):void {
			for (var i:int = 0; i < arguments.length; i++)
				if(arguments[i] is Array)this.removeChildren.apply(this,arguments[i])
				else if(this.contains(arguments[i]))this.removeChild(arguments[i])
			
		}
		public function addChildren(...arguments):void {
			for (var i:int = 0; i < arguments.length; i++)
				if(arguments[i] is Array)this.addChildren.apply(this,arguments[i])
				else this.addChild(arguments[i])
		}
		
		/**
		 * Extends the basic addEventListener, so that when a RESIZE or INIT_RESIZE event listener is added, the all code needed for those to work is executed
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReferance
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReferance:Boolean = false):void {
			if ((type == Event.RESIZE || type == ActionEvent.INIT_RESIZE) && !this.resizable) {
				this.resizable = new Resizable(this)
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReferance)
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if ((type == Event.RESIZE || type == ActionEvent.INIT_RESIZE) && this.resizable) {
				this.resizable.remove()
				this.resizable = null;
			}
			super.removeEventListener(type, listener, useCapture)
		}
		
		/**
		 * put this element on top of all other children in it's DisplatObjectContainer
		 */
		public function bringToFront():void {
			this.parent.setChildIndex(this,this.parent.numChildren - 1);
		}
		
		public function bringUnder(child:DisplayObject):void {
			this.parent.setChildIndex(this, this.parent.getChildIndex(child))
		}
		
		public function bringOnTopOf(child:DisplayObject):void {
			this.parent.setChildIndex(this, this.parent.getChildIndex(child))
			this.parent.swapChildren(this, child)
		}
		
		public function bringToBack():void {
			this.parent.setChildIndex(this,0)
		}
		
		
		/**
		 * Simultaniously set x and y with an array ( [x,y] )
		 */
		public function set pos(p:Array):*{	return [this.x = p[0], this.y = p[1]] }
		/**
		 * Get the x and y in an array ( [x,y] )
		 */
		public function get pos():Array{ return [this.x,this.y]	}
		
		/**
		 * sets the width and hight with an array ( [width, height] )
		 */
		public function set dims(d:Array):*{ return [this.width = d[0], this.height = d[1]] }
		
		/**
		 * get the width and hight with an array ( [width, height] )
		 */
		public function get dims():Array{ return [this.width,this.height] }
		
		public function get aspect():Aspect {
			return new Aspect(this.width, this.height)
		}		
		
		/**
		 * set multiple attributes of the clip conveniently ( with name:value pairs )
		 */
		public function set attributes(attrs:Object):*{
			for(var attr:String in attrs)this[attr] = attrs[attr]
			return attrs
		}
		
		/**
		 * Easyly modify the x within the scrollRect
		 */
		public function set scrollRectX(new_x:Number):*{
			var r:Rectangle = scrollRect
			r.x = new_x
			this.scrollRect = r
			return new_x
		}
		
		/**
		 * Easyly modify the y within the scrollRect
		 */
		public function set scrollRectY(new_y:Number):*{
			var r:Rectangle = scrollRect
			r.y = new_y
			this.scrollRect = r
			return new_y
		}
		public function get scrollRectY():Number {
			return this.scrollRect.y
		}
		public function get scrollRectX():Number {
			return this.scrollRect.x
		}	
		
		public function set scaleXY(val:Number):*{	return this.scaleX = this.scaleY = val }		
		public function get scaleXY():Number{	return (this.scaleX + this.scaleY)/2 }		
		
		/**
		 * Make some delay and the dispatch the event
		 * @param	delay
		 * @param	event
		 * @return
		 */
		public function dispatchAfter(delay:Number,event:Event):int{
			return setTimeout(this.onDispatchAfterReached,delay*1000,event)
		}
		
		public function chianEventDispather(type:String, dispatch_type:String):void {
			this.addEventListener(type, function(event:Event):void{ (event.target as ActionSprite).dispatchEvent(new Event(dispatch_type)) })
		}
		
		private function onDispatchAfterReached(event:Event):void{this.dispatchEvent(event)}
	}
	
}