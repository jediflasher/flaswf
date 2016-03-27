package ru.flaswf.reader.descriptors {

	import flash.utils.ByteArray;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    25.11.2014
	 */
	public class AnimationDescriptor {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function AnimationDescriptor() {
			super();
		}

		public var startFrame:int;

		public var endFrame:int;

		public var name:String;

		public function fromByteArray(byteArray:ByteArray):void {
			this.name = byteArray.readUTF();
			this.startFrame = byteArray.readShort();
			this.endFrame = byteArray.readShort();
		}

		public function toByteArray(byteArray:ByteArray):void {
			byteArray.writeUTF(this.name || 'def');
			byteArray.writeShort(this.startFrame);
			byteArray.writeShort(this.endFrame);
		}
	}
}
