package bdement.ui.components
{

	import bdement.ui.Align;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Label extends Component
	{

		////////////////////////////////////////////////////////////
		//   ATTRIBUTES 
		////////////////////////////////////////////////////////////

		public var _textField:TextField;

		private var _align:String = Align.LEFT;

		private var _color:uint = 0x000000;

		private var _font:Font;

		private var _maxWidth:Number;

		private var _size:Number = 12;

		private var _text:String;

		private var _textFormat:TextFormat;

		////////////////////////////////////////////////////////////
		//   CONSTRUCTOR 
		////////////////////////////////////////////////////////////

		//TODO: bold
		//TODO: italics
		//TODO: outline
		[DefaultProperty("text")]
		public function Label(font:Font = null, size:Number = 12, color:uint = 0x000000, text:String = "", alignment:String = Align.LEFT)
		{
			super();
			constructor(font, size, color, text);
		}

		private function constructor(font:Font = null, size:Number = 12, color:uint = 0x000000, text:String = "", align:String = Align.LEFT):void
		{
			_font = font;
			_size = size;
			_color = color;
			_text = text;
			_align = align;

			_textField = new TextField();
			_textField.gridFitType = GridFitType.SUBPIXEL;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			addChild(_textField);

			validate();
		}

		////////////////////////////////////////////////////////////
		//   PUBLIC API 
		////////////////////////////////////////////////////////////

		public override function dispose():void
		{
			if (_textField)
			{
				removeChild(_textField);
				_textField = null;
			}

			_textFormat = null;
			_textField = null;
			_text = null;
			_font = null;
			_align = null;

			if (hasEventListener(Event.RENDER))
			{
				removeEventListener(Event.RENDER, onRender);
			}
		}

		public function draw():void
		{
			_textField.text = String(_text);
		}

		////////////////////////////////////////////////////////////
		//   EVENT HANDLERS 
		////////////////////////////////////////////////////////////

		protected override function onAddedToStage(event:Event):void
		{
			validate();

			super.onAddedToStage(event);
		}

		private function onRemovedFromStage(event:Event):void
		{
			dispose();
		}

		private function onRender(event:Event):void
		{
			removeEventListener(Event.RENDER, onRender);
			validate();
		}

		////////////////////////////////////////////////////////////
		//   PRIVATE METHODS 
		////////////////////////////////////////////////////////////

		private function invalidate():void
		{
			if (stage)
			{
				stage.invalidate();
				addEventListener(Event.RENDER, onRender);
			}
			else
			{
				validate();
			}
		}

		private function validate():void
		{
			if (hasEventListener(Event.RENDER))
			{
				removeEventListener(Event.RENDER, onRender);
			}

			if (_font)
			{
				_textField.embedFonts = true;
				_textFormat = new TextFormat(_font.fontName, _size, _color, null, null, null, null, null, _align, null, null, null, null);
				_textField.defaultTextFormat = _textFormat;
				_textField.setTextFormat(_textFormat);
			}

			var isMaxWidthSet:Boolean = !isNaN(_maxWidth);
			_textField.multiline = isMaxWidthSet;
			_textField.wordWrap = isMaxWidthSet;

			if (isMaxWidthSet)
			{
				_textField.width = _maxWidth;
			}

			switch (_align)
			{
				default:
				case TextFormatAlign.LEFT:
					_textField.autoSize = TextFieldAutoSize.LEFT;
					_textField.x = 0;
					break;

				case TextFormatAlign.RIGHT:
					_textField.autoSize = TextFieldAutoSize.RIGHT;
					_textField.x = -maxWidth >> 0;
					break;

				case TextFormatAlign.CENTER:
					_textField.autoSize = TextFieldAutoSize.CENTER;
					_textField.x = -maxWidth >> 1;
					break;
			}

			if (hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		////////////////////////////////////////////////////////////
		//   GETTERS / SETTERS 
		////////////////////////////////////////////////////////////

		[Bindable(event = "labelAlignChanged")]
		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;
			invalidate();
		}

		public function get color():uint
		{
			return _color;
		}

		[Bindable(event = "labelColorChanged")]
		public function set color(value:uint):void
		{
			_color = value;
			invalidate();
		}

		public function get editable():Boolean
		{
			return _textField.type == TextFieldType.INPUT;
		}

		[Bindable(event = "labelEditableChanged")]
		public function set editable(value:Boolean):void
		{
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;

			if (value)
			{
				_textField.selectable = true;
			}
		}

		[Bindable(event = "labelFontChanged")]
		public function get font():Font
		{
			return _font;
		}

		public function set font(value:Font):void
		{
			_font = value;
			invalidate();
		}

		public override function get height():Number
		{
			if (_textField.parent)
			{
				return _textField.getBounds(_textField.parent).height;
			}

			return _textField.textHeight;
		}

		public function get maxWidth():Number
		{
			return isNaN(_maxWidth) ? _textField.textWidth : _maxWidth;
		}

		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
			invalidate();
		}

		public function get selectable():Boolean
		{
			return _textField.selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_textField.selectable = value;
		}

		[Bindable(event = "labelSizeChanged")]
		public function get size():Number
		{
			return _size;
		}

		public function set size(value:Number):void
		{
			_size = value;
			invalidate();
		}

		[Bindable(event = "labelTextChanged")]
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
			_textField.text = String(_text);

			if (hasEventListener(Event.RESIZE))
			{
				dispatchEvent(new Event(Event.RESIZE));
			}
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public override function get width():Number
		{
			if (_textField.parent)
			{
				return _textField.getBounds(_textField.parent).width;
			}

			return _textField.textWidth;
		}

		public override function set width(value:Number):void
		{
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.width = value;
			invalidate();
		}

		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
			invalidate();
		}
	}
}
