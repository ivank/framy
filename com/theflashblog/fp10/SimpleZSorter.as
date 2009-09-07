package com.theflashblog.fp10 {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix3D;	
	
	/**
	 * @author Ralph Hauwert / UnitZeroOne
	 */
	public class SimpleZSorter
	{
		
		/**
		 * SimpleZSorter.sortClips(container, recursive);
		 * 
		 * @param container the display object containing the children to be sorted according to their Z Depth.
		 * @param recursive if set to true, the sortClips will recurse to all nested display objects, and sort their children if necessary.
		 */
		public static function sortClips(container : DisplayObjectContainer, recursive : Boolean = false) : void
		{
			//Check if something was passed.
			if(container != null){
				//Check if this displayobjectcontainer has more then 1 child.
				var nc:int = container.numChildren;
				if(nc > 1){
					
					var index:int = 0;
					var vo : SimpleZSortVO;
					var displayObject:DisplayObject;
					var transformedMatrix : Matrix3D;
					var mainParent : DisplayObject = traverseParents(container);
					if (mainParent) {
						//This array we will use to store & sort the objects and the relative screenZ's.
						var sortArray : Array = new Array();
						
						//cycle through all the displayobjects.
						for(var c:int = 0; c < container.numChildren; c++){
							displayObject = container.getChildAt(c);
							//If we are recursing all children, we also sort the children within these children.
							if(recursive && (displayObject is DisplayObjectContainer)){
								sortClips(displayObject as DisplayObjectContainer, true);
							}
							//This transformed matrix contains the actual transformed Z position.
							transformedMatrix = displayObject.transform.getRelativeMatrix3D(mainParent);
							
							//Push this object in the sortarray. [Maybe replace the new for a pool]
							sortArray.push(new SimpleZSortVO(displayObject, transformedMatrix.position.z));
						}
						
						//Sort the array (Array.sort is still king of speed).
						sortArray.sortOn("screenZ", Array.NUMERIC | Array.DESCENDING);
						for each(vo in sortArray){
							//Change the indices of all objects according to their Z Sorted value.
							container.setChildIndex(vo.object, index++);
						}
						
						//Let's make sure all ref's are released.
						sortArray = null;						
					}

				}
			}else{
				throw new Error("No displayobject was passed as an argument");
			}
		}
		
		/**
		 * This traverses the displayobject to the parent.
		 */
		private static function traverseParents(container : DisplayObject) : DisplayObject
		{
			//Take the current parent.
			var parent : DisplayObject = container.parent;
			if(!parent)return parent 
			var lastParent : DisplayObject = parent;
			//Iterate until the parent value is null (we've reached the end of this displayobject chain).
			while((parent = parent.parent) != null){
				lastParent = parent;
			}
			//Return the "top most" parent.
			return lastParent;
		}
	}
}