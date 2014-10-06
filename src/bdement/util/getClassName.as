package bdement.util
{

	import flash.utils.*;

	////////////////////////////////////////////////////////////
	//   PUBLIC API 
	////////////////////////////////////////////////////////////

	public function getClassName(value:*):String
	{
		if (!value)
		{
			return null;
		}

		var qualifiedName:String = value is String ? value : getQualifiedClassName(value);
		var nameQuery:Array = qualifiedName.match(/[^(:|.)]*\z/);

		if (!nameQuery || !nameQuery.length)
		{
			return null;
		}

		return nameQuery[0];
	}
}
