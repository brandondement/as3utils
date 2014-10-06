package bdement.ui.effects
{

	import com.greensock.TweenLite;
	import bdement.util.IDisposable;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class SlidePageEffect extends ListPageEffect implements IDisposable
	{

		////////////////////////////////////////////////////////////
		//   CONSTANTS 
		////////////////////////////////////////////////////////////

		public static const HORIZONTAL:String = "horizontal";

		public static const VERTICAL:String = "vertical";

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var direction:String;

		public var ease:Function;

		private var _currentPageIndex:int;

		private var _height:Number;

		private var _isForward:Boolean;

		private var _list:DisplayObjectContainer;

		private var _mask:Shape = new Shape();

		private var _nextPageIndex:int;

		private var _snapshot:Bitmap = new Bitmap(null, "auto", true);

		private var _snapshotHeight:Number;

		private var _snapshotWidth:Number;

		private var _width:Number;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		public function SlidePageEffect(duration:Number = 0.3, direction:String = "horiztonal", ease:Function = null)
		{
			this.duration = duration;
			this.direction = direction;
			this.ease = ease;
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public function dispose():void
		{
			//TODO: dispose during tween
			_list = null;
			_snapshot = null;
			_mask = null;
			ease = null;
		}

		public override function play(target:DisplayObject):void
		{
			// sometimes a list can change size when showing incomplete pages 
			if (_list.width > _width || _list.height > _height)
			{
				if (direction == HORIZONTAL)
				{
					_snapshotWidth = _list.width * 2;
					_snapshotHeight = _list.height;
				}
				else if (direction == VERTICAL)
				{
					//TODO: invertVertical:Boolean
					_snapshotWidth = _list.width;
					_snapshotHeight = _list.height * 2;
				}

				var bmd:BitmapData = new BitmapData(_snapshotWidth, _snapshotHeight, true, 0x000000);
				bmd.copyPixels(_snapshot.bitmapData, new Rectangle(0, 0, _snapshotWidth, _snapshotHeight), new Point(0, 0));
				_snapshot.bitmapData = bmd;
			}

			// figure out where our anchor point is on the stage
			var anchorPoint:Point = _list.localToGlobal(new Point(0, 0));
			_mask.x = anchorPoint.x;
			_mask.y = anchorPoint.y;

			// fill in the mask
			var g:Graphics = _mask.graphics;
			g.beginFill(0xFFFFFF, 1.0);
			g.drawRect(0, 0, _width, _height);
			g.endFill();

			// take a snapshot of the next page
			var drawOffsetX:Number = 0;
			var drawOffsetY:Number = 0;
			var xBy:Number = 0;
			var yBy:Number = 0;

			//TODO: handle case where new and old page bounds don't match
			if (direction == HORIZONTAL)
			{
				drawOffsetX = _isForward ? _width : 0;
				xBy = _isForward ? -_width : _width;
				anchorPoint.x += _isForward ? 0 : -_width;
			}
			else if (direction == VERTICAL)
			{
				//TODO: invertVertical:Boolean
				drawOffsetY = _isForward ? _height : 0;
				yBy = _isForward ? -_height : _height;
				anchorPoint.y += _isForward ? 0 : -_height;
			}

			// only fill in half of the bitmap
			var matrix:Matrix = new Matrix();
			matrix.translate(drawOffsetX, drawOffsetY);
			_snapshot.bitmapData.draw(_list, matrix);

			_snapshot.x = anchorPoint.x;
			_snapshot.y = anchorPoint.y;

			// swap the list for the snapshot
			_list.visible = false;
			_list.stage.addChild(_snapshot);
			_snapshot.mask = _mask;

			// tween the snapshot
			TweenLite.to(_snapshot, this.duration, {x:String(xBy), y:String(yBy), ease:this.ease, onComplete:onSlideComplete});
		}

		public override function prePlay(list:DisplayObjectContainer, currentPageIndex:int, nextPageIndex:int):void
		{
			_list = list;
			_currentPageIndex = currentPageIndex;
			_nextPageIndex = nextPageIndex;

			var bounds:Rectangle = _list.getBounds(_list);
			_width = bounds.width;
			_height = bounds.height;

			_isForward = (_nextPageIndex > _currentPageIndex);

			_snapshotWidth = _width;
			_snapshotHeight = _height;

			var drawOffsetX:Number = 0;
			var drawOffsetY:Number = 0;

			if (direction == HORIZONTAL)
			{
				drawOffsetX = _isForward ? 0 : _width;
				_snapshotWidth = _width * 2;
			}
			else if (direction == VERTICAL)
			{
				//TODO: invertVertical:Boolean
				drawOffsetY = _isForward ? 0 : _height;
				_snapshotHeight = _height * 2;
			}

			// only fill in half of the snapshot right now
			var matrix:Matrix = new Matrix();
			matrix.translate(drawOffsetX, drawOffsetY);

			// take a snapshot of the original page
			var bitmapData:BitmapData = new BitmapData(_snapshotWidth, _snapshotHeight, true, 0x000000);
			bitmapData.draw(_list, matrix);
			_snapshot.bitmapData = bitmapData;
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		private function onSlideComplete():void
		{
			_list.visible = true;
			_list.stage.removeChild(_snapshot);
			_snapshot.bitmapData.dispose();
		}
	}
}
