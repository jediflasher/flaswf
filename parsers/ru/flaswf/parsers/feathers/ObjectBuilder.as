package ru.flaswf.parsers.feathers {

	import ru.flaswf.parsers.feathers.view.ParserFeathersButton;
	import ru.flaswf.parsers.feathers.view.ParserFeathersDummy;
	import ru.flaswf.parsers.feathers.view.ParserFeathersHint;
	import ru.flaswf.parsers.feathers.view.ParserFeathersImage;
	import ru.flaswf.parsers.feathers.view.ParserFeathersMovieClip;
	import ru.flaswf.parsers.feathers.view.ParserFeathersScale9Image;
	import ru.flaswf.parsers.feathers.view.ParserFeathersTextField;
	import ru.flaswf.parsers.feathers.view.ParserFeathersTextInput;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;
	import ru.flaswf.reader.descriptors.TextFieldDescriptor;

	import starling.display.DisplayObject;
	import starling.textures.Texture;
	
	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.05.2015
	 */
	public class ObjectBuilder {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const _MAP:Object = {};

		/**
		 * Returns texture by name. Should be set from outside
		 */
		public static var getTexture:Function = function (name:String):Texture {
			return null;
		};

		/**
		 * Translates value to current workspace scale. Should be set from outside
		 * @return
		 */
		public static var t:Function = function (value:*):Number {
			return value;
		};

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function registerDependency(linkage:String, dependentClass:Class):void {
			_MAP[linkage] = dependentClass;
		}

		public static function build(descriptor:DisplayObjectDescriptor, customFactory:Object = null):DisplayObject {
			var result:DisplayObject;
			var linkage:String = descriptor.linkage ? descriptor.linkage.name : null;

			var targetFactory:Object;
			if (linkage) {
				if (customFactory && (linkage in customFactory || descriptor.name in customFactory)) targetFactory = customFactory;
				else if (linkage in _MAP) targetFactory = _MAP;
			}

			if (targetFactory) {
				result = new (targetFactory[linkage] as Class)(descriptor);
			} else {
				if (descriptor is TextFieldDescriptor) {
					var td:TextFieldDescriptor = (descriptor as TextFieldDescriptor);
					result = td.editable ? new ParserFeathersTextInput(td) : new ParserFeathersTextField(td);
				} else if (isTexture(linkage)) {
					if (descriptor.linkage.scale9Grid) {
						result = new ParserFeathersScale9Image(descriptor);
					} else {
						result = new ParserFeathersImage(descriptor);
					}

				} else if (isButton(linkage)) {
					result = new buttonRenderer(descriptor);
				} else if (isHint(linkage)) {
					result = new ParserFeathersHint(descriptor);
				} else if (isDummy(linkage)) {
					result = new ParserFeathersDummy(descriptor);
				} else {
					result = new ParserFeathersMovieClip(descriptor);
				}
			}

			if (descriptor.name) result.name = descriptor.name;

			return result;
		}

		public static function isTexture(name:String):Boolean {
			return name.indexOf('tx_') > -1;
		}

		public static function normalize(name:String):String {
			return name.replace(/tx_|anim_/g, '');
		}

		public static function isButton(name:String):Boolean {
			return name.indexOf('button_') == 0;
		}

		public static function isSlider(name:String):Boolean {
			return name.indexOf('slider_') == 0;
		}

		public static function isHint(name:String):Boolean {
			return name.indexOf('hint_') == 0;
		}

		public static function isDummy(name:String):Boolean {
			return name == 'dummy';
		}

		/*
		 public static function setChildProperties(flash:flash.display.DisplayObject, starling:DisplayObject):void {
		 if (flash.name) {
		 starling.name = flash.name;
		 }

		 if (starling is ParserFeathersImage) {
		 var px:Number = starling.pivotX;
		 var py:Number = starling.pivotY;
		 starling.transformationMatrix = flash.transform.matrix;
		 starling.pivotX = px;
		 starling.pivotY = py;
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);
		 } else {
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);

		 if (starling is Scale9Image || starling is LayoutGroup) {
		 starling.width = t(flash.width);
		 starling.height = t(flash.height);
		 } else {
		 if (flash.width > 0) {
		 starling.width = t(flash.width) / flash.scaleX;
		 }

		 if (flash.height > 0) {
		 starling.height = t(flash.height) / flash.scaleY;
		 }

		 var matrix:Matrix = flash.transform.matrix;
		 var skewX:Number = Math.atan(-matrix.c / matrix.d);
		 var skewY:Number = Math.atan( matrix.b / matrix.a);

		 // NaN check ("isNaN" causes allocation)
		 if (skewX != skewX) skewX = 0.0;
		 if (skewY != skewY) skewY = 0.0;

		 const PI_Q:Number = Math.PI / 4;
		 starling.scaleX = (skewX > -PI_Q && skewX < PI_Q) ?  matrix.d / Math.cos(skewX)
		 : -matrix.c / Math.sin(skewX);
		 starling.scaleY = (skewY > -PI_Q && skewY < PI_Q) ?  matrix.a / Math.cos(skewY)
		 :  matrix.b / Math.sin(skewY);

		 starling.skewX = skewX;
		 starling.skewY = skewY;
		 }

		 starling.rotation = flash.rotation / 180 * Math.PI;

		 /*if (!(starling is LayoutGroup)) {
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);
		 starling.width = t(flash.width);
		 starling.height = t(flash.height);
		 starling.rotation = flash.rotation / 180 * Math.PI;
		 }*/
//			}

//			starling.alpha = flash.alpha;
//		}

		/*	public static function setFlashChildProperties(flash:flash.display.DisplayObject, starling:DisplayObject):void {
		 if (flash.name) {
		 starling.name = flash.name;
		 }

		 if (starling is ParserFeathersImage) {
		 var px:Number = starling.pivotX;
		 var py:Number = starling.pivotY;
		 starling.transformationMatrix = flash.transform.matrix;
		 starling.pivotX = px;
		 starling.pivotY = py;
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);

		 //				var color:uint = 0xFFFFFF;
		 //				(starling as ParserFeathersImage).color = flash.transform.colorTransform
		 } else {
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);

		 if (starling is Scale9Image || starling is ParserFeathersDummy) {
		 starling.width = t(flash.width);
		 starling.height = t(flash.height);
		 starling.rotation = flash.rotation / 180 * Math.PI;
		 } else if (!(starling is LayoutGroup)) {
		 if (flash.width > 0) starling.width = t(flash.width) / flash.scaleX;
		 if (flash.height > 0) starling.height = t(flash.height) / flash.scaleY;

		 starling.scaleX = flash.scaleX;
		 starling.scaleY = flash.scaleY;

		 var matrix:Matrix = flash.transform.matrix;
		 var skewX:Number = Math.atan(-matrix.c / matrix.d);
		 var skewY:Number = Math.atan(matrix.b / matrix.a);

		 // NaN check ("isNaN" causes allocation)
		 if (skewX != skewX) skewX = 0.0;
		 if (skewY != skewY) skewY = 0.0;

		 const PI_Q:Number = Math.PI / 4;
		 starling.scaleX = (skewX > -PI_Q && skewX < PI_Q) ? matrix.d / Math.cos(skewX)
		 : -matrix.c / Math.sin(skewX);
		 starling.scaleY = (skewY > -PI_Q && skewY < PI_Q) ? matrix.a / Math.cos(skewY)
		 : matrix.b / Math.sin(skewY);

		 //					starling.skewX = skewX;
		 //					starling.skewY = skewY;

		 starling.rotation = flash.rotation / 180 * Math.PI;
		 }
		 }

		 starling.alpha = flash.alpha;
		 }

		 public static function setChildPropertiesForAnimation(flash:flash.display.DisplayObject, starling:DisplayObject):void {
		 setFlashChildProperties(flash, starling);
		 return;

		 if (flash.name) {
		 starling.name = flash.name;
		 }

		 if (starling is ParserFeathersImage) {
		 starling.transformationMatrix = flash.transform.matrix;
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);
		 } else {
		 if (!(starling is LayoutGroup)) {
		 starling.x = t(flash.x);
		 starling.y = t(flash.y);
		 starling.width = t(flash.width);
		 starling.height = t(flash.height);
		 starling.rotation = flash.rotation / 180 * Math.PI;
		 }
		 }

		 starling.alpha = flash.alpha;
		 }
		 */
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------

		public static var buttonRenderer:Class = ParserFeathersButton;

		public static var textInputRenderer:Class = ParserFeathersTextInput;

		public static var textFieldRenderer:Class = ParserFeathersTextField;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ObjectBuilder() {
			super();
		}
	}
}
