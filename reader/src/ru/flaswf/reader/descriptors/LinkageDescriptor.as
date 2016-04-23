package ru.flaswf.reader.descriptors {
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 15:21
	 */
	public class LinkageDescriptor {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function LinkageDescriptor() {
			super();
		}

		//---------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------

		public var link:int;

		public var name:String;

		public var framesCount:int = 0;

		public var _frames:Vector.<FrameDescriptor>;

		public var scale9Grid:Rectangle;

		public function get frames():Vector.<FrameDescriptor> {
			if (!this._frames)  this._frames = new Vector.<FrameDescriptor>();
			return this._frames;
		}

		private var _animations:Vector.<AnimationDescriptor>;

		public function get animations():Vector.<AnimationDescriptor> {
			if (!this._animations) this._animations = new Vector.<AnimationDescriptor>();

			return this._animations;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _animationsHash:Object = {}; // name -> AnimationDescriptor

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function fromByteArray(byteArray:ByteArray):void {
			this.link = byteArray.readInt();
			this.name = byteArray.readUTF();

			var len:int = byteArray.readShort();
			for (var i:int = 0; i < len; i++) {
				var animation:AnimationDescriptor = new AnimationDescriptor();
				animation.fromByteArray(byteArray);
				this.animations.push(animation);
				this._animationsHash[animation.name] = animation;
			}

			this.framesCount = byteArray.readShort();
			for (i = 0; i < this.framesCount; i++) {
				var frame:FrameDescriptor = new FrameDescriptor();
				frame.fromByteArray(byteArray);
				frame.owner = this;
				frames.push(frame);
			}

			var hasScaleGrid:Boolean = byteArray.readBoolean();
			if (hasScaleGrid) {
				scale9Grid = new Rectangle();
				scale9Grid.x = byteArray.readFloat();
				scale9Grid.y = byteArray.readFloat();
				scale9Grid.width = byteArray.readFloat();
				scale9Grid.height = byteArray.readFloat();
			}
		}

		public function toByteArray(byteArray:ByteArray):void {
			byteArray.writeInt(this.link);
			byteArray.writeUTF(this.name);

			var len:int = this._animations ? this._animations.length : 0;
			byteArray.writeShort(len);

			for (var i:int = 0; i < len; i++) {
				var animation:AnimationDescriptor = this._animations[i];
				animation.toByteArray(byteArray);
			}

			this.framesCount = _frames ? _frames.length : 0;
			byteArray.writeShort(this.framesCount);

			for (i = 0; i < this.framesCount; i++) {
				var frame:FrameDescriptor = this._frames[i];
				frame.toByteArray(byteArray);
			}

			byteArray.writeBoolean(Boolean(scale9Grid));

			if (scale9Grid) {
				byteArray.writeFloat(scale9Grid.x);
				byteArray.writeFloat(scale9Grid.y);
				byteArray.writeFloat(scale9Grid.width);
				byteArray.writeFloat(scale9Grid.height);
			}
		}

		public function getAnimationByName(name:String):AnimationDescriptor {
			if (!this._animationsHash) return null;
			return this._animationsHash[name];
		}

		public function hasAnimation(name:String):Boolean {
			if (!this._animationsHash) return false;
			return name in this._animationsHash;
		}
	}
}