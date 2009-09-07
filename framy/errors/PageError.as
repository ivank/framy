package framy.errors 
{
	
	/**
	 * ...
	 * @author IvanK
	 */
	public class PageError extends Error
	{
		
		public function PageError(message:String, id:*=0) 
		{
			super(message, id)
		}
		
	}
	
}