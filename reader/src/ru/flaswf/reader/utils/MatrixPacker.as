package ru.flaswf.reader.utils {

	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class MatrixPacker {

		public static var count:int = 0;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MatrixPacker() {
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var bitsPending:uint = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function readMatrix(ba:ByteArray):Matrix {
			var matrix:Matrix = new Matrix(
					ba.readDouble(),
					ba.readDouble(),
					ba.readDouble(),
					ba.readDouble(),
					ba.readFloat(),
					ba.readFloat()
			);
			return matrix;
			//
			this.resetBitsPending();
			
			var scaleX:Number = 1.0;
			var scaleY:Number = 1.0;
			
			if (this.readUB(ba, 1) == 1) {
				var scaleBits:uint = this.readUB(ba, 5);
				scaleX = this.readFB(ba, scaleBits);
				scaleY = this.readFB(ba, scaleBits);
			}
			var rotateSkew0:Number = 0.0;
			var rotateSkew1:Number = 0.0;
			if (this.readUB(ba, 1) == 1) {
				var rotateBits:uint = this.readUB(ba, 5);
				rotateSkew0 = this.readFB(ba, rotateBits);
				rotateSkew1 = this.readFB(ba, rotateBits);
			}
			var translateBits:uint = this.readUB(ba, 5);
			var translateX:Number = this.readSB(ba, translateBits) / 20; // twips!
			var translateY:Number = this.readSB(ba, translateBits) / 20;
			return new Matrix(scaleX, rotateSkew0, rotateSkew1, scaleY, translateX, translateY);
		}
		
		public function writeMatrix(ba:ByteArray, matrix:Matrix):void {
			count++;
			ba.writeDouble(matrix.a);
			ba.writeDouble(matrix.b);
			ba.writeDouble(matrix.c);
			ba.writeDouble(matrix.d);
			ba.writeFloat(matrix.tx);
			ba.writeFloat(matrix.ty);
			return;

			this.resetBitsPending();
			
			var scaleX:Number = matrix.a;
			var scaleY:Number = matrix.d;
			var rotateSkew0:Number = matrix.b;
			var rotateSkew1:Number = matrix.c;

			var hasScale:Boolean = scaleX != 1 || scaleY != 1;
			var hasRotate:Boolean = rotateSkew0 != 0 || rotateSkew1 != 0;
			var translateX:int = matrix.tx * 20; // twips!
			var translateY:int = matrix.ty * 20;
			
			this.writeBits(ba, 1, hasScale ? 1 : 0);
			
			if (hasScale) {
				var scaleBits:uint;
				
				if (scaleX == 0 && scaleY == 0) {
					scaleBits = 1;
				} else {
					scaleBits = calculateMaxBits(true, [scaleX * 65536, scaleY * 65536]);
				}
				
				this.writeUB(ba, 5, scaleBits);
				this.writeFB(ba, scaleBits, scaleX);
				this.writeFB(ba, scaleBits, scaleY);
			}
			
			this.writeBits(ba, 1, hasRotate ? 1 : 0);
			
			if (hasRotate) {
				var rotateBits:uint = calculateMaxBits(true, [rotateSkew0 * 65536, rotateSkew1 * 65536]);
				
				this.writeUB(ba, 5, rotateBits);
				this.writeFB(ba, rotateBits, rotateSkew0);
				this.writeFB(ba, rotateBits, rotateSkew1);
			}
			
			var translateBits:uint = calculateMaxBits(true, [translateX, translateY]);
			this.writeUB(ba, 5, translateBits);
			this.writeSB(ba, translateBits, translateX);
			this.writeSB(ba, translateBits, translateY);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function readBits(ba:ByteArray, bits:uint, bitBuffer:uint = 0):uint {
			if (bits == 0) {
				return bitBuffer;
			}
			var partial:uint;
			var bitsConsumed:uint;
			if (this.bitsPending > 0) {
				var byte:uint = ba[ba.position - 1] & (0xff >> (8 - this.bitsPending));
				bitsConsumed = Math.min(this.bitsPending, bits);
				this.bitsPending -= bitsConsumed;
				partial = byte >> this.bitsPending;
			} else {
				bitsConsumed = Math.min(8, bits);
				this.bitsPending = 8 - bitsConsumed;
				partial = ba.readUnsignedByte() >> this.bitsPending;
			}
			bits -= bitsConsumed;
			bitBuffer = (bitBuffer << bitsConsumed) | partial;
			return (bits > 0) ? this.readBits(ba, bits, bitBuffer) : bitBuffer;
		}
		
		/**
		 * @private
		 */
		private function writeBits(ba:ByteArray, bits:uint, value:uint):void {
			if (bits == 0) {
				return;
			}
			value &= (0xffffffff >>> (32 - bits));
			var bitsConsumed:uint;
			if (this.bitsPending > 0) {
				if (this.bitsPending > bits) {
					ba[ba.position - 1] |= value << (this.bitsPending - bits);
					bitsConsumed = bits;
					this.bitsPending -= bits;
				} else if (this.bitsPending == bits) {
					ba[ba.position - 1] |= value;
					bitsConsumed = bits;
					this.bitsPending = 0;
				} else {
					ba[ba.position - 1] |= value >> (bits - this.bitsPending);
					bitsConsumed = this.bitsPending;
					this.bitsPending = 0;
				}
			} else {
				bitsConsumed = Math.min(8, bits);
				this.bitsPending = 8 - bitsConsumed;
				ba.writeByte((value >> (bits - bitsConsumed)) << this.bitsPending);
			}
			bits -= bitsConsumed;
			if (bits > 0) {
				this.writeBits(ba, bits, value);
			}
		}
		
		/**
		 * @private
		 */
		private function resetBitsPending():void {
			this.bitsPending = 0;
		}
		
		/**
		 * @private
		 */
		private function calculateMaxBits(signed:Boolean, values:Array):uint {
			var b:uint = 0;
			var vmax:int = int.MIN_VALUE;
			if (!signed) {
				for each(var usvalue:uint in values) {
					b |= usvalue;
				}
			} else {
				for each(var svalue:int in values) {
					if (svalue >= 0) {
						b |= svalue;
					} else {
						b |= (~svalue + 1) << 1;
					}
					if (vmax < svalue) {
						vmax = svalue;
					}
				}
			}
			var bits:uint = 0;
			if (b > 0) {
				bits = b.toString(2).length;
				if (signed && vmax > 0 && vmax.toString(2).length >= bits) {
					bits++;
				}
			}
			return bits;
		}
		
		/**
		 * @private
		 */
		private function readUB(ba:ByteArray, bits:uint):uint {
			return this.readBits(ba, bits);
		}
		
		/**
		 * @private
		 */
		private function writeUB(ba:ByteArray, bits:uint, value:uint):void {
			this.writeBits(ba, bits, value);
		}
		
		/**
		 * @private
		 */
		private function readSB(ba:ByteArray, bits:uint):int {
			var shift:uint = 32 - bits;
			return int(this.readBits(ba, bits) << shift) >> shift;
		}
		
		/**
		 * @private
		 */
		private function writeSB(ba:ByteArray, bits:uint, value:int):void {
			this.writeBits(ba, bits, value);
		}
		
		/**
		 * @private
		 */
		private function readFB(ba:ByteArray, bits:uint):Number {
			return Number(this.readSB(ba, bits)) / 65536;
		}
		
		/**
		 * @private
		 */
		private function writeFB(ba:ByteArray, bits:uint, value:Number):void {
			this.writeSB(ba, bits, value * 65536);
		}
	}
}