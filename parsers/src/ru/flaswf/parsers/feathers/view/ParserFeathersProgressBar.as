package ru.flaswf.parsers.feathers.view {
	
	import feathers.core.FeathersControl;
	
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;
	
	import starling.display.DisplayObject;
	
	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                03.04.2016 13:19
	 */
	public class ParserFeathersProgressBar extends ParserFeathersDisplayObjectContainer {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersProgressBar(source:DisplayObjectDescriptor) {
			super(source);
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		private var _value:Number = 0;

		public function get value():Number {
			return _value;
		}

		public function set value(value:Number):void {
			if (_value == value) return;

			if (value < minValue) value = minValue;
			else if (value > maxValue) value = maxValue;

			_value = value;
			invalidateData()
		}
		
		private var _minValue:Number = 0;

		public function get minValue():Number {
			return _minValue;
		}

		public function set minValue(value:Number):void {
			if (_minValue == value) return;

			_minValue = value;
		}

		private var _maxValue:Number = 100;

		public function get maxValue():Number {
			return _maxValue;
		}

		public function set maxValue(value:Number):void {
			if (_maxValue == value) return;

			_maxValue = value;
		}

		private var _format:String = '%v';

		/**
		 * %v — value
		 * %V — max value
		 * @example if value is 35 and maxValue is 100, then %v/%V means 35/100
		 */
		public function get format():String {
			return _format;
		}

		public function set format(value:String):void {
			if (_format == value) return;

			_format = value;
			invalidateData();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		private var _bg:DisplayObject;

		private var _bar:DisplayObject;

		private var _label:ParserFeathersTextField;
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		protected override function initialize():void {
			super.initialize();
			autoAssign();
		}

		protected override function draw():void {
			super.draw();

			if (isInvalid(FeathersControl.INVALIDATION_FLAG_DATA)) {
				var ratio:Number = (_value - _minValue) / (_maxValue - _minValue);
				_bar.width = _bg.width * ratio;
				_label.text = format.replace('%v', _value).replace('%V', _maxValue);
			}
		}
	}
}
