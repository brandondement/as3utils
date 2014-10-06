package bdement.util 
{

	import flash.geom.Vector3D;

	public class V3
	{
		public static function Add(a:Vector3D, b:Vector3D):Vector3D
		{
			var res:Vector3D = a.add(b);
			return res;
		}

		public static function Cross(a:Vector3D, b:Vector3D):Vector3D
		{
			var res:Vector3D = a.crossProduct(b);
			return res;
		}

		public static function Dist(a:Vector3D, b:Vector3D):Number
		{
			return Sub(a, b).length;
		}

		public static function DistSq(a:Vector3D, b:Vector3D):Number
		{
			return Sub(a, b).lengthSquared;
		}

		public static function Dot(a:Vector3D, b:Vector3D):Number
		{
			var res:Number = a.dotProduct(b);
			return res;
		}

		public static function Lerp(k:Number, a:Vector3D, b:Vector3D):Vector3D
		{
			return Add(Scale(1 - k, a), Scale(k, b));
		}

		public static function Scale(b:Number, a:Vector3D):Vector3D
		{
			var res:Vector3D = new Vector3D(a.x, a.y, a.z);
			res.scaleBy(b);
			return res;
		}

		public static function Sub(a:Vector3D, b:Vector3D):Vector3D
		{
			var res:Vector3D = a.subtract(b);
			return res;
		}
	}
}
