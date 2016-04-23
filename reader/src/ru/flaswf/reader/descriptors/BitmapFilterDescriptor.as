package ru.flaswf.reader.descriptors {
	
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.ByteArray;
	
	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                19.12.2015 18:52
	 */
	public class BitmapFilterDescriptor {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const TYPE_BLUR:int = 1;

		public static const TYPE_GLOW:int = 2;

		public static const TYPE_DROP_SHADOW:int = 3;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function fromNative(nativeFilter:BitmapFilter):BitmapFilterDescriptor {
			var result:BitmapFilterDescriptor = new BitmapFilterDescriptor();
			
			if (nativeFilter is BlurFilter) {
				var bf:BlurFilter = nativeFilter as BlurFilter;
				result.type = TYPE_BLUR;
				result.blurX = bf.blurX;
				result.blurY = bf.blurY;
				result.color = -1;
			} else if (nativeFilter is GlowFilter) {
				var gf:GlowFilter = nativeFilter as GlowFilter;
				result.type = TYPE_GLOW;
				result.blurX = gf.blurX;
				result.blurY = gf.blurY;
				result.color = gf.color;
				result.alpha = gf.alpha;
				result.strength = gf.strength;
				result.inner = gf.inner;
				result.knockout = gf.knockout;
			} else if (nativeFilter is DropShadowFilter) {
				var df:DropShadowFilter = nativeFilter as DropShadowFilter;
				result.type = TYPE_DROP_SHADOW;
				result.blurX = df.blurX;
				result.blurY = df.blurY;
				result.color = df.color;
				result.alpha = df.alpha;
				result.angle = df.angle;
				result.distance = df.distance;
				result.strength = df.strength;
				result.inner = df.inner;
				result.knockout = df.knockout;
			}

			return result;
		}

		public static function toNative(filterDescriptor:BitmapFilterDescriptor):BitmapFilter {
			var result:BitmapFilter;
			switch (filterDescriptor.type) {
				case TYPE_BLUR:
					result = new BlurFilter(filterDescriptor.blurX, filterDescriptor.blurY);
					break;
				case TYPE_DROP_SHADOW:
					result = new DropShadowFilter(
							filterDescriptor.distance, filterDescriptor.angle, filterDescriptor.color,
							filterDescriptor.alpha, filterDescriptor.blurX, filterDescriptor.blurY,
							filterDescriptor.strength, 1, filterDescriptor.inner, filterDescriptor.knockout
					);
					break;
				case TYPE_GLOW:
					result = new GlowFilter(
							filterDescriptor.color, filterDescriptor.alpha, filterDescriptor.blurX,
							filterDescriptor.blurY, filterDescriptor.strength, 1, filterDescriptor.inner,
							filterDescriptor.knockout
					);
					break;
			}
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapFilterDescriptor() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var type:int;

		public var blurX:Number;
		
		public var blurY:Number;
		
		public var color:int;
		
		public var angle:Number = 0;
		
		public var distance:Number = 0;
		
		public var strength:Number = 0;
		
		public var alpha:Number = 1;
		
		public var inner:Boolean;
		
		public var knockout:Boolean;

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function fromByteArray(byteArray:ByteArray):void {
			type = byteArray.readShort();

			switch (type) {
				case TYPE_BLUR:
					blurX = byteArray.readFloat();
					blurY = byteArray.readFloat();
					break;
				case TYPE_DROP_SHADOW:
					distance = byteArray.readFloat();
					angle = byteArray.readUnsignedInt();
					color = byteArray.readUnsignedInt();
					alpha = byteArray.readFloat();
					blurX = byteArray.readFloat();
					blurY = byteArray.readFloat();
					strength = byteArray.readFloat();
					inner = byteArray.readBoolean();
					knockout = byteArray.readBoolean();
					break;
				case TYPE_GLOW:
					color = byteArray.readUnsignedInt();
					alpha = byteArray.readFloat();
					blurX = byteArray.readFloat();
					blurY = byteArray.readFloat();
					strength = byteArray.readFloat();
					inner = byteArray.readBoolean();
					knockout = byteArray.readBoolean();
					break;
			}
		}

		public function toByteArray(byteArray:ByteArray):void {
			byteArray.writeShort(type);
			
			switch (type) {
				case TYPE_BLUR:
					byteArray.writeFloat(blurX);
					byteArray.writeFloat(blurY);
					break;
				case TYPE_DROP_SHADOW:
					byteArray.writeFloat(distance);
					byteArray.writeUnsignedInt(angle);
					byteArray.writeUnsignedInt(color);
					byteArray.writeFloat(alpha);
					byteArray.writeFloat(blurX);
					byteArray.writeFloat(blurY);
					byteArray.writeFloat(strength);
					byteArray.writeBoolean(inner);
					byteArray.writeBoolean(knockout);
					break;
				case TYPE_GLOW:
					byteArray.writeUnsignedInt(color);
					byteArray.writeFloat(alpha);
					byteArray.writeFloat(blurX);
					byteArray.writeFloat(blurY);
					byteArray.writeFloat(strength);
					byteArray.writeBoolean(inner);
					byteArray.writeBoolean(knockout);
					break;
			}
		}
	}
}
