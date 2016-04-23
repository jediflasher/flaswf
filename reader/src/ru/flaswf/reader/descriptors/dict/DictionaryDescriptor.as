package ru.flaswf.reader.descriptors.dict {
	
	import flash.utils.ByteArray;
	
	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 15:36
	 */
	public class DictionaryDescriptor {

		/**
		 [dict] – Содержит список текстур, где порядковый номер записи – название текстуры в описаниях анимаций, и список анимаций
		 [textcount][textures][linkagecount][linkage][animcount][animation1][endframe][animation2][endframe]
		 [linkage][animcount][animation1][endframe][animation2][endframe]
		 [textcount] – int количество записей текстур
		 [textures] – список текстур
		 [short][short][short][short][string]
		 [short] x 4 – x, y, width, height of sub texture
		 [string] name of sub texture
		 [linkagecount] – byte количество linkages
		 [linkage] – UTF название класса
		 [animcount] – byte количество записей
		 [animationN] – UTF название анимации
		 [endframe] – int конечный фрейм анимации (начальный фрейм опеределяется как (предыдущий конечный || 0) + 1
		 */

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function DictionaryDescriptor(bytes:ByteArray) {
			super();
			this._bytes = bytes;

			this.read();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _bytes:ByteArray;

		/**
		 * @private
		 */
		private const _hash:Object = {}; // linkage -> LinkageDescriptor

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public const atlas:AtlasDictionary = new AtlasDictionary();

		public const linkages:Vector.<String> = new Vector.<String>();

		public var totalFrames:int = 0;

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function read():void {
			// read atlas info
			var texturesCount:int = this._bytes.readInt();
			for (var i:int = 0; i < texturesCount; i++) {
				var x:int = this._bytes.readShort();
				var y:int = this._bytes.readShort();
				var w:int = this._bytes.readShort();
				var h:int = this._bytes.readShort();
				var name:String = this._bytes.readUTF();
				atlas.add(name, x, y, w, h);
			}

			// read linkage info
			var linkagesCount:int = this._bytes.readByte();
			for (i = 0; i < linkagesCount; i++) {
				var linkageName:String = this._bytes.readUTF();
				var linkage:LinkageDictionary = new LinkageDictionary(linkageName);
				this._hash[linkageName] = linkage;
				this.linkages.push(linkageName);

				var animationCount:int = this._bytes.readByte();
				var firstFrame:int = 0;

				for (var j:int = 0; j < animationCount; j++) {
					var animationName:String = this._bytes.readUTF();
					var endFrame:int = this._bytes.readInt();

					var animation:AnimationDictionary = new AnimationDictionary(animationName);
					animation.startFrame = firstFrame;
					animation.endFrame = endFrame;

					firstFrame = endFrame + 1;
					linkage.add(animation);
				}
			}

			this.totalFrames = endFrame;
		}

	}
}
