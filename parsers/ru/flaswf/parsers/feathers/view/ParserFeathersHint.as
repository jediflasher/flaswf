package ru.flaswf.parsers.feathers.view {

	import feathers.core.FeathersControl;
	import feathers.core.IValidating;

	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.display.DisplayObject;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                31.10.2015 18:55
	 */
	public class ParserFeathersHint extends ParserFeathersMovieClip {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const DIRECTION_TOP_LEFT:String = 'topLeft';

		public static const DIRECTION_TOP_RIGHT:String = 'topRight';

		public static const DIRECTION_TOP_CENTER:String = 'top';

		public static const DIRECTION_BOTTOM_LEFT:String = 'bottomLeft';

		public static const DIRECTION_BOTTOM_RIGHT:String = 'bottomRight';

		public static const DIRECTION_BOTTOM_CENTER:String = 'bottom';

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersHint(source:DisplayObjectDescriptor) {
			super(source);
			touchable = false;

			var className:String = source.linkage.name;

			if (className.indexOf(DIRECTION_TOP_LEFT) >= 0) _direction = DIRECTION_TOP_LEFT;
			else if (className.indexOf(DIRECTION_TOP_RIGHT) >= 0) _direction = DIRECTION_TOP_RIGHT;
			else if (className.indexOf(DIRECTION_BOTTOM_LEFT) >= 0) _direction = DIRECTION_BOTTOM_LEFT;
			else if (className.indexOf(DIRECTION_BOTTOM_RIGHT) >= 0) _direction = DIRECTION_BOTTOM_RIGHT;
			else if (className.indexOf(DIRECTION_BOTTOM_CENTER)) _direction = DIRECTION_BOTTOM_CENTER;
			else if (className.indexOf(DIRECTION_TOP_CENTER)) _direction = DIRECTION_TOP_CENTER;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		private var _text:String;

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			if (_text == value) return;

			_text = value;
			invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		private var _direction:String;

		public function get direction():String {
			return _direction;
		}

		public function set direction(value:String):void {
			if (_direction == value) return;

			_direction = value;
			invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		}

		public override function get visible():Boolean {
			return super.visible;
		}

		public override function set visible(value:Boolean):void {
			super.visible = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		private var _paddingTop:Number;

		private var _paddingBottom:Number;

		private var _paddingLeft:Number;

		private var _paddingRight:Number;

		private var _bg:DisplayObject;

		private var _textField:ParserFeathersTextField;

		private var _hintContainer:ParserFeathersDisplayObjectContainer;

		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		protected override function initialize():void {
			super.initialize();

			_hintContainer = getMovieClip('hint');

			_textField = getTextField('hint.text');
			_textField.maxWidth = _textField.width;
			_bg = getChildByName('hint.bg');

			if (_bg is IValidating) (_bg as IValidating).validate();

			_paddingLeft = _textField.x - _bg.x;
			_paddingRight = _bg.width - _textField.width - _paddingLeft;
			_paddingTop = _textField.y - _bg.y;
			_paddingBottom = _bg.height - _textField.height - _paddingTop;
		}

		protected override function draw():void {
			super.draw();

			if (isInvalid(FeathersControl.INVALIDATION_FLAG_DATA)) {
				_textField.width = NaN;
				_textField.height = NaN;
				_textField.text = _text;
				_textField.invalidate(INVALIDATION_FLAG_ALL);
				_textField.validate();

				_bg.width = _textField.width + _paddingLeft + _paddingRight;
				_bg.height = _textField.height + _paddingTop + _paddingBottom;

				_textField.x = _bg.x + _paddingLeft;
				_textField.y = _bg.y + _paddingTop;

				switch (_direction) {
					case DIRECTION_BOTTOM_LEFT:
						_hintContainer.x = 0;
						_hintContainer.y = -_bg.height;
						break;
					case DIRECTION_BOTTOM_RIGHT:
						_hintContainer.x = -_bg.width;
						_hintContainer.y = -_bg.height;
						break;
					case DIRECTION_TOP_LEFT:
						_hintContainer.x = 0;
						_hintContainer.y = 0;
						break;
					case DIRECTION_TOP_RIGHT:
						_hintContainer.x = -_bg.width;
						_hintContainer.y = 0;
						break;
					case DIRECTION_BOTTOM_CENTER:
						_hintContainer.x = -_bg.width / 2;
						_hintContainer.y = -_bg.height;
						break;
					case DIRECTION_TOP_CENTER:
						_hintContainer.x = -_bg.width / 2;
						_hintContainer.y = 0;
						break;
				}
			}
		}
	}
}
