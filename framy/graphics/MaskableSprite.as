package framy.graphics 
{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer
	import flash.display.DisplayObject
	import flash.geom.Point;
	import framy.structure.Initializer;
	import framy.utils.Hash;
	
	/**
	 * Allows to easily apply masks to sprites
	 * @author IvanK (ikerin@gmail.com)
	 */
	dynamic public class MaskableSprite extends Sprite
	{
		private var _maskable_mask:fySprite
		private var _maskable_options:Hash
		private var _maskable_content:Sprite
		
		public function MaskableSprite() 
		{
			super()
		}
		
		/**
		 *	<p>Creates a mask that encompases all of the children of this sprite. All newly added children are also affected by the mask.
		 *	The default mask is with the dimensions of the sprite, but this can be tweaked with the options. </p>
		 *	<p>You can also assign debug: true in the options to see where the mask really is.
		 *	Also, you can view all masks by setting "debug: { show_masks:true }" option in the Initializer )</p>
		 *	@param	options	 The options for the mask, accepts x, y, width, height, alpha, color and debug
		 *	@param	mask_attributes	 Attributes to be applied to the mask sprite
		 *	@return		The created mask sprite
		 */
		public function setMasking(options:Object = null, mask_attributes:Object = null):fySprite {
			this._maskable_options = new Hash( { debug: Initializer.options.debug.show_masks, width:super.width, height: super.height } ).merge(options)
			if (this._maskable_options.debug) {
				this._maskable_options.extend({ alpha: 0.3, color: [0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF,0xFF00FF][Math.floor(Math.random()*5)]})
			}
			this._maskable_mask = fySprite.newRect(this._maskable_options, mask_attributes)
			this._maskable_content = new Sprite()
			if(!this._maskable_options.debug)this._maskable_content.mask = this._maskable_mask
			var children_count:int = super.numChildren
			
			for (var i:uint = 0; i < children_count; i++) {
				this._maskable_content.addChild(super.getChildAt(0))
			}
			super.addChild(this._maskable_content)
			super.addChild(this._maskable_mask)
			return this._maskable_mask
		}
		
		/**
		 *	Removes the masksing, leaving everything as it was before the mask was set
		 */
		public function removeMasking():void{
		  super.removeChild(this._maskable_content)
		  super.removeChild(this._maskable_mask)
		  var children_count:int = this._maskable_content.numChildren
			for (var i:uint = 0; i < children_count; i++) {
				super.addChild(this._maskable_content.getChildAt(0))
			}
		  this._maskable_content = this._maskable_mask = null
		}
		
		/**
		 *	Get the mask sprite
		 */
		public function getMasking():fySprite {
			return _maskable_mask
		}

		/**
		 *	Modify the x position of the mask
		 */
		public function get masking_x():Number { return this._maskable_mask.x; }
		public function set masking_x(value:Number):void { this._maskable_mask.x = value; }
		
		/**
		 *	Modify the y position of the mask
		 */
		public function get masking_y():Number { return this._maskable_mask.y; }
		public function set masking_y(value:Number):void { this._maskable_mask.y = value; }
		
		/**
		 *	Modify the width of the mask
		 */
		public function get masking_width():Number { return this._maskable_mask.width; }
		public function set masking_width(value:Number):void { this._maskable_mask.width = value; }
		
		/**
		 *	Modify the height of the mask
		 */
		public function get masking_height():Number { return this._maskable_mask.height; }
		public function set masking_height(value:Number):void { this._maskable_mask.height = value; }
		
		/* ================================================= */
		/* = Override all methods that modify the children = */
		/* ================================================= */
		
		/**
		 *	@private
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject		{ return _maskable_content ? _maskable_content.addChildAt(child, index) : super.addChildAt(child, index); }
		
		/**
		 *	@private
		 */
		override public function addChild(child:DisplayObject):DisplayObject					{ return _maskable_content ? _maskable_content.addChild(child) : super.addChild(child); }
		
		/**
		 *	@private
		 */
		override public function getChildAt(index:int):DisplayObject							{ return _maskable_content ? _maskable_content.getChildAt(index) : super.getChildAt(index); }
		
		/**
		 *	@private
		 */
		override public function getChildByName(name:String):DisplayObject						{ return _maskable_content ? _maskable_content.getChildByName(name) : super.getChildByName(name); }
		
		/**
		 *	@private
		 */
		override public function getChildIndex(child:DisplayObject):int							{ return _maskable_content ? _maskable_content.getChildIndex(child) : super.getChildIndex(child); }
		
		/**
		 *	@private
		 */
		override public function removeChild(child:DisplayObject):DisplayObject					{ return _maskable_content ? _maskable_content.removeChild(child) : super.removeChild(child); }
		
		/**
		 *	@private
		 */
		override public function removeChildAt(index:int):DisplayObject							{ return _maskable_content ? _maskable_content.removeChildAt(index) : super.removeChildAt(index); }
		
		/**
		 *	@private
		 */
		override public function contains(child:DisplayObject):Boolean							{ return _maskable_content ? _maskable_content.contains(child) : super.contains(child); }
		
		/**
		 *	@private
		 */
		override public function get numChildren():int											{ return _maskable_content ? _maskable_content.numChildren : super.numChildren }
		
		/**
		 *	@private
		 */
		override public function getObjectsUnderPoint(point:Point):Array						{ return _maskable_content ? _maskable_content.getObjectsUnderPoint(point) : super.getObjectsUnderPoint(point) }
		
		/**
		 *	@private
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void				{ _maskable_content ? _maskable_content.setChildIndex(child, index) : super.setChildIndex(child, index); }
		
		/**
		 *	@private
		 */
		override public function swapChildrenAt(index1:int, index2:int):void					{ _maskable_content ? _maskable_content.swapChildrenAt(index1, index2) : super.swapChildrenAt(index1, index2); }
		
		/**
		 *	@private
		 */
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void	{ _maskable_content ? _maskable_content.swapChildren(child1, child2) : super.swapChildren(child1, child2); }		
		
	}
	
}