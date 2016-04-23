package ru.flaswf.parsers.feathers.view {
	
	import flash.geom.Rectangle;

	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.display.DisplayObject;
	import starling.rendering.Painter;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                02.11.2015 19:35
	 */
	public class ParserFeathersDummy extends DisplayObject {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		private static const BOUNDS:Rectangle = new Rectangle();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersDummy(source:DisplayObjectDescriptor) {
			super();
			touchable = false;

			var b:Rectangle = source.getFrameBounds();
			x = ObjectBuilder.t(b.x);
			y = ObjectBuilder.t(b.y);
			width = ObjectBuilder.t(b.width * source.transform.a);
			height = ObjectBuilder.t(b.height * source.transform.d);
			name = source.name;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _width:Number;

		public override function get width():Number {
			return _width;
		}

		public override function set width(value:Number):void {
			if (_width == value) return;

			_width = value;
		}
		
		/**
		 * @private
		 */
		private var _height:Number;
		
		public override function get height():Number {
			return _height;
		}
		
		public override function set height(value:Number):void {
			if (_height == value) return;
			
			_height = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public override function render(painter:Painter):void {
			// nothing
		}

		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle {
			BOUNDS.setTo(x, y, width, height);
			return BOUNDS;
		}
	}
}
