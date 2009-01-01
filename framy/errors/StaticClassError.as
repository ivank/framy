package framy.errors 
{
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class StaticClassError extends Error
	{
		
		public function StaticClassError(message:String="")
		{
			super("This is only a static class - you cannot create objects of it, only use its functions "+message)
		}
		
	}
	
}