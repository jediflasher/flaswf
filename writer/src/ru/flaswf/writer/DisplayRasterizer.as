package ru.flaswf.writer {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import ru.flaswf.reader.descriptors.AnimationDescriptor;
	import ru.flaswf.reader.descriptors.BitmapFilterDescriptor;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;
	import ru.flaswf.reader.descriptors.FrameDescriptor;
	import ru.flaswf.reader.descriptors.LinkageDescriptor;
	import ru.flaswf.reader.descriptors.TextFieldDescriptor;
	
	public class DisplayRasterizer {

		/**
		 * @private
		 */
		private static const DEBUG:Boolean = false;

		/**
		 * @private
		 */
		private static const ADD_CLASS_NAME_TO_PART:Boolean = false;

		/**
		 * @private
		 */
		private static const HELPER_MATRIX:Matrix = new Matrix();

		/**
		 * @private
		 */
		private static const MASK_PREFIX:String = 'mask_';

		/**
		 * @private
		 */
		private static const MASKED_SUFFIX:String = '_mask';

		/**
		 * @private
		 */
		public static const CONSTRUCTOR:String = 'constructor';

		/**
		 * @private
		 */
		public static const CUSTOM_LINK:String = 'linkage#';

		/**
		 * @private
		 */
		private static const GLOW_COLORS:Array = [];

		/**
		 * @private
		 */
		private static const GLOW_ALPHA_COLORS:Array = [];

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function DisplayRasterizer() {
			super();

			var i:int = 0;
			while (i++ < 255) {
				GLOW_COLORS[i] = 0xFFFFFFFF;
				GLOW_ALPHA_COLORS[i] = 0xFF000000;
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
		private var _linkageName:String = '';

		/**
		 * @private
		 */
		private var _linkageHash:Object = {}; // linkage -> LinkageDescriptor

		/**
		 * @private
		 */
		private var _instanceToLink:Dictionary = new Dictionary(true); // DisplayObject -> LinkageDescriptor

		/**
		 * @private
		 */
		private var _linkCounter:int = 1;

		/**
		 * @private
		 */
		public var mtxCount:int = 0;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 * @param obj объект для растеризации
		 * @param linkageName
		 * @return
		 */
		public function rasterize(obj:Sprite, linkageName:String):Vector.<LinkageDescriptor> {
			this._linkageName = linkageName;
			var time:Number = getTimer();
			this.process(obj);
			trace('PROCESSED: ' + ((getTimer() - time) / 1000) + 'sec.');

			var list:Vector.<LinkageDescriptor> = new Vector.<LinkageDescriptor>();
			for each (var link:LinkageDescriptor in this._linkageHash) {
				list.push(link);
			}

			return list;
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function getLinkage(obj:Sprite):LinkageDescriptor {
			var constructor:Class = obj[CONSTRUCTOR];
			var isCustomLink:Boolean = constructor !== MovieClip && constructor !== Sprite;

			var link:String;
			var result:LinkageDescriptor = this._instanceToLink[obj] as LinkageDescriptor;
			if (result) {
				link = result.name;
			} else {
				link = isCustomLink ? getQualifiedClassName(constructor) : CUSTOM_LINK + (this._linkCounter);
				result = this._linkageHash[link] as LinkageDescriptor;
			}

			if (!result) {
				result = new LinkageDescriptor();
				this._linkageHash[link] = result;
				this._instanceToLink[obj] = result;
				result.name = link;
				result.link = this._linkCounter++;
				if (obj.scale9Grid) result.scale9Grid = obj.scale9Grid.clone();

				var mc:MovieClip = obj as MovieClip;
				var frameLabel:String = 'undefined';
				var animation:AnimationDescriptor;
				var totalFrames:int = mc ? mc.totalFrames : 1;

				for (var i:int = 0; i < totalFrames; i++) {
					if (mc) mc.gotoAndStop(i + 1);

					// animations
					var currentLabel:String = mc ? mc.currentLabel : 'def';
					if (currentLabel != frameLabel) {
						if (animation) animation.endFrame = i - 1;

						animation = new AnimationDescriptor();
						animation.startFrame = i;
						animation.name = currentLabel;
						frameLabel = currentLabel;
						result.animations.push(animation);
					}

					// frames
					var frame:FrameDescriptor = new FrameDescriptor();
					frame.owner = result;
					frame.bounds = obj.getBounds(obj);
					result.frames.push(frame);
				}

				animation.endFrame = i - 1;
			}

			return result;
		}

		/**
		 * @private
		 */
		private function process(obj:DisplayObject):DisplayObjectDescriptor {
			var result:DisplayObjectDescriptor = obj is TextField ? new TextFieldDescriptor() : new DisplayObjectDescriptor();
			result.alpha = obj.alpha;

			if (obj is MovieClip) (obj as MovieClip).gotoAndStop(0);

			if (obj.filters.length) {
				result.filters = new Vector.<BitmapFilterDescriptor>();
				for each (var f:BitmapFilter in obj.filters) {
					result.filters.push(BitmapFilterDescriptor.fromNative(f));
				}
			}

			if (obj is Sprite) {
				var sp:Sprite = obj as Sprite;
				var mc:MovieClip = obj as MovieClip;
				result.linkage = getLinkage(sp);

				var linkage:LinkageDescriptor = result.linkage;
				var totalFrames:int = mc ? mc.totalFrames : 1;
				for (var i:int = 0; i < totalFrames; i++) {
					var frameDescriptor:FrameDescriptor = linkage.frames[i];
					if (frameDescriptor.objects.length) continue;

					if (mc) mc.gotoAndStop(i + 1);
					this.parseContainer(sp, frameDescriptor);
				}
			} else if (obj is TextField) {
				var tf:TextField = obj as TextField;
				var resultTf:TextFieldDescriptor = result as TextFieldDescriptor;
				resultTf.x = tf.x;
				resultTf.y = tf.y;
				resultTf.width = tf.width;
				resultTf.height = tf.height;
				resultTf.textFormat = tf.defaultTextFormat;
				resultTf.text = tf.text;
				resultTf.embedFonts = tf.embedFonts;
				resultTf.multiline = tf.multiline;
				resultTf.wordWrap = tf.wordWrap;
				resultTf.restrict = tf.restrict;
				resultTf.editable = tf.type == TextFieldType.INPUT;
				resultTf.selectable = tf.selectable;
				resultTf.displayAsPassword = tf.displayAsPassword;
				resultTf.maxChars = tf.maxChars;
			} else {
				throw new Error('unknown object ' + obj);
			}

			return result;
		}

		/**
		 * @private
		 */
		private function parseContainer(container:Sprite, frameDescriptor:FrameDescriptor):void {
			for (var j:int = 0; j < container.numChildren; j++) {
				var child:DisplayObject = container.getChildAt(j);
				if (!(child is MovieClip || child is TextField)) {
					trace('child is ' + child[CONSTRUCTOR] + '. Skip');
					continue;
				}
				var name:String = child.name;

				var objectInstance:DisplayObjectDescriptor = this.process(child);

				objectInstance.name = name;
				objectInstance.transform = child.transform.matrix;
				frameDescriptor.objects.push(objectInstance);
			}
		}
	}
}