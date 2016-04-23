package ru.flaswf.reader.descriptors {
	
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import ru.flaswf.reader.descriptors.dict.AtlasDictionary;
	
	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 10:59
	 */
	public class SwfDescriptor {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function SwfDescriptor(byteArray:ByteArray = null) {
			super();
			if (byteArray) {
				byteArray.uncompress('lzma');
				byteArray.position = 0;
				fromByteArray(byteArray);
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private const _linkageHash:Object = {}; // linkage -> LinkageDescriptor

		/**
		 * @private
		 */
		private const _linkCountHash:Object = {}; // count -> LinkageDescriptor

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public const atlas:AtlasDictionary = new AtlasDictionary();

		public const linkages:Vector.<LinkageDescriptor> = new Vector.<LinkageDescriptor>();

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function fromByteArray(byteArray:ByteArray):void {
			atlas.fromByteArray(byteArray);

			var t:Number = getTimer();
			var count:int = byteArray.readInt();
			for (var i:int = 0; i < count; i++) {
				var linkageDescriptor:LinkageDescriptor = new LinkageDescriptor();
				linkageDescriptor.fromByteArray(byteArray);
				_linkageHash[linkageDescriptor.name] = linkageDescriptor;
				_linkCountHash[linkageDescriptor.link] = linkageDescriptor;
				linkages.push(linkageDescriptor);
			}
			trace('from ByteArray: ' + (getTimer() - t) + ' ms.');

			t = getTimer();
			for (i = 0; i < count; i++) {
				linkageDescriptor = linkages[i];
				var frames:Vector.<FrameDescriptor> = linkageDescriptor._frames;
				var len:int = linkageDescriptor.framesCount;
				for (var j:int = 0; j < len; j++) {
					var frame:FrameDescriptor = frames[j];
					var objects:Vector.<DisplayObjectDescriptor> = frame.objects;
					var objectsCount:int = objects.length;
					for (var k:int = 0; k < objectsCount; k++) {
						var obj:DisplayObjectDescriptor = objects[k];
						if (!obj.linkage) {
							obj.linkage = _linkCountHash[obj.linkToDescriptor];
						}
					}
				}
			}
			trace('set linkages: ' + (getTimer() - t) + ' ms.')
		}

		public function toByteArray(byteArray:ByteArray):void {
			atlas.toByteArray(byteArray);

			var len:int = linkages.length;
			byteArray.writeInt(len);
			for (var i:int = 0; i < len; i++) {
				var linkage:LinkageDescriptor = linkages[i];
				linkage.toByteArray(byteArray);
			}
		}

		public function getLinkageByName(name:String):LinkageDescriptor {
			return _linkageHash[name];
		}

		public function addLinkage(linkage:LinkageDescriptor):void {
			if (linkage.name in _linkageHash) return;

			_linkageHash[linkage.name] = linkage;
			linkages.push(linkage);
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}
