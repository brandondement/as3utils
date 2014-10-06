package bdement.util
{

	import flash.utils.*;

	////////////////////////////////////////////////////////////
	//   PUBLIC API 
	////////////////////////////////////////////////////////////

	public function getPackageName(value:*):String
	{
		if (!value)
		{
			return null;
		}

		var qualifiedName:String = value is String ? value : getQualifiedClassName(value);
		var nameQuery:Array = qualifiedName.match(/^.*(?=(\.|::))/);

		if (!nameQuery || !nameQuery.length)
		{
			return null;
		}

		return nameQuery[0];
	}
}
