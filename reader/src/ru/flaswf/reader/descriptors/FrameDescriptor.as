package ru.flaswf.reader.descriptors {
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 15:20
	 */
	public class FrameDescriptor {

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function FrameDescriptor() {
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
		private var _hash:Object = {}; // name -> DisplayObjectInstance

		//--------------------------------------------------------------------------
		//
		//	Properties
		//
		//--------------------------------------------------------------------------

		public var bounds:Rectangle;

		public var owner:LinkageDescriptor;

		public const objects:Vector.<DisplayObjectDescriptor> = new Vector.<DisplayObjectDescriptor>();

		public var objectsCount:int = 0;

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function toByteArray(byteArray:ByteArray):void {
			var len:int = this.objects.length;
			byteArray.writeShort(len);

			byteArray.writeFloat(this.bounds.x);
			byteArray.writeFloat(this.bounds.y);
			byteArray.writeFloat(this.bounds.width);
			byteArray.writeFloat(this.bounds.height);

			for each (var obj:DisplayObjectDescriptor in objects) {
				byteArray.writeBoolean(obj is TextFieldDescriptor);
				obj.toByteArray(byteArray);
			}
		}

		public function fromByteArray(byteArray:ByteArray):void {
			var len:int = byteArray.readShort();

			this.bounds = new Rectangle(
					byteArray.readFloat(),
					byteArray.readFloat(),
					byteArray.readFloat(),
					byteArray.readFloat()
			);

			for (var i:int = 0; i < len; i++) {
				var isTextField:Boolean = byteArray.readBoolean();
				var obj:DisplayObjectDescriptor = isTextField ? new TextFieldDescriptor() : new DisplayObjectDescriptor();
				obj.fromByteArray(byteArray);
				this.objects.push(obj);
				this._hash[obj.name] = obj;
			}

			this.objectsCount = len;
		}

		public function getObjectByName(name:String):DisplayObjectDescriptor {
			return this._hash[name];
		}

		public function hasObject(name:String):Boolean {
			return name in this._hash;
		}
	}
}
