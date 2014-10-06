package bdement.util
{

	/**
	 * Implementors of this interface should clear their own memory when
	 * <em>dispose()</em> is called. <em>dispose()</em> should be safe to
	 * call multiple times.
	 *
	 * IDisposable objects should NOT call their own dispose() method. It
	 * should be called by other objects that are managing it.
	 */
	public interface IDisposable
	{
		/**
		 * Frees memory used by the object
		 */
		function dispose():void;
	}
}
