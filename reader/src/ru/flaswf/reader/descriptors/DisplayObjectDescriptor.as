package ru.flaswf.reader.descriptors {
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import ru.flaswf.reader.utils.MatrixPacker;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    11.12.2014
	 */
	public class DisplayObjectDescriptor {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const matrixPacker:MatrixPacker = new MatrixPacker();

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function DisplayObjectDescriptor() {
			super();
		}

		public var linkage:LinkageDescriptor;

		public var linkToDescriptor:int;

		public var transform:Matrix;

		public var name:String;

		public var alpha:Number;

		public var filters:Vector.<BitmapFilterDescriptor>;

		public function fromByteArray(byteArray:ByteArray):void {
			linkToDescriptor = byteArray.readInt();
			name = byteArray.readUTF();
			transform = matrixPacker.readMatrix(byteArray);

			alpha = byteArray.readFloat();

			var filtersCount:int = byteArray.readUnsignedInt();
			if (filtersCount > 0) {
				filters = new Vector.<BitmapFilterDescriptor>();
				for (var i:int = 0; i < filtersCount; i++) {
					var f:BitmapFilterDescriptor = new BitmapFilterDescriptor();
					f.fromByteArray(byteArray);
					filters.push(f);
				}
			}
		}

		public function toByteArray(byteArray:ByteArray):void {
			if (!linkToDescriptor && linkage) linkToDescriptor = linkage.link;
			byteArray.writeInt(linkToDescriptor);
			byteArray.writeUTF(name);
			matrixPacker.writeMatrix(byteArray, transform);

			byteArray.writeFloat(alpha);

			var filtersCount:int = filters ? filters.length : 0;
			byteArray.writeUnsignedInt(filtersCount);

			for (var i:int = 0; i < filtersCount; i++) {
				var f:BitmapFilterDescriptor = filters[i];
				f.toByteArray(byteArray);
			}
		}

		public function getFrameBounds(frame:int = 0):Rectangle {
			return linkage ? linkage.frames[frame].bounds : null;
		}
	}
}