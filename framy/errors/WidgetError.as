package framy.errors 
{
	
	/**
	 * ...
	 * @author IvanK
	 */
	public class WidgetError extends Error
	{
		public function WidgetError(message:String = null, id:*=0) 
		{
			super(message, id)
		}
		
	}
	
}