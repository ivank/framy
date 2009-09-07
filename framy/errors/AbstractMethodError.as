package framy.errors 
{
	
	/**
	 * ...
	 * @author IvanK (ikerin@gmail.com)
	 */
	public class AbstractMethodError extends Error
	{
		public function AbstractMethodError(message:String = null) 
		{
			super("This is only an abstract method, you must override it to use it "+message)
		}
		
	}
	
}