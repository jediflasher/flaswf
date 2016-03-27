package ru.flaswf.reader.descriptors.dict {

	import flash.utils.ByteArray;

	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 17:30
	 */
	public class SubTextureDictionary {

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function SubTextureDictionary() {
			super();
		}

		public var name:String;

		public var x:int;

		public var y:int;

		public var width:int;

		public var height:int;

		public function fromByteArray(byteArray:ByteArray):void {
			this.name = byteArray.readUTF();
			this.x = byteArray.readShort();
			this.y = byteArray.readShort();
			this.width = byteArray.readShort();
			this.height = byteArray.readShort();
		}

		public function toByteArray(byteArray:ByteArray):void {
			byteArray.writeUTF(this.name);
			byteArray.writeShort(this.x);
			byteArray.writeShort(this.y);
			byteArray.writeShort(this.width);
			byteArray.writeShort(this.height);
		}
	}
}
