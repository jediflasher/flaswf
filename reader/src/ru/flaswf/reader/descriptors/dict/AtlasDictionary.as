package ru.flaswf.reader.descriptors.dict {

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;

	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 17:24
	 */
	public class AtlasDictionary {

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function AtlasDictionary() {
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
		private const _nameHash:Object = {}; // name -> SubTextureDictionary

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public const textures:Vector.<SubTextureDictionary> = new Vector.<SubTextureDictionary>();

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function add(name:String, x:int, y:int, width:int, height:int):void {
			if (name in this._nameHash) throw new IllegalOperationError('already added');

			var sub:SubTextureDictionary = new SubTextureDictionary();
			sub.name = name;
			sub.x = x;
			sub.y = y;
			sub.width = width;
			sub.height = height;

			this._nameHash[sub.name] = sub;
			this.textures.push(sub);
		}

		public function getByName(name:String):SubTextureDictionary {
			return this._nameHash[name];
		}

		public function fromByteArray(byteArray:ByteArray):void {
			var count:int = byteArray.readInt();
			for (var i:int = 0; i < count; i++) {
				var sub:SubTextureDictionary = new SubTextureDictionary();
				sub.fromByteArray(byteArray);
				this.textures.push(sub);
				this._nameHash[sub.name] = sub;
			}
		}

		public function toByteArray(byteArray:ByteArray):void {
			byteArray.writeInt(textures.length);
			for each (var sub:SubTextureDictionary in this.textures) {
				sub.toByteArray(byteArray);
			}
		}
	}
}
