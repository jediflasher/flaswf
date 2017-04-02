////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {
	
	import feathers.core.IValidating;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.parsers.feathers.view.ParserFeathersImage;
	import ru.flaswf.reader.descriptors.AnimationDescriptor;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;
	import ru.flaswf.reader.descriptors.FrameDescriptor;
	import ru.flaswf.reader.descriptors.TextFieldDescriptor;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	
	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.05.2015
	 */
	public class ParserFeathersMovieClip extends ParserFeathersDisplayObjectContainer implements IAnimatable {
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		private static const INVALIDATION_FLAG_FRAME:String = 'invalidationFlagFrame';
		
		private static const HELPER_BOUNDS:Rectangle = new Rectangle();
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const DEF:String = 'def';
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersMovieClip(source:DisplayObjectDescriptor = null) {
			super(source);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _childrenToRemove:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _updated:Boolean = false;
		
		private var _bounds:Rectangle = new Rectangle();
		
		private var _frameHandlers:Object = {};
		'frame -> Vector.<Function>'
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _playingAnimation:Animation;
		
		public function get playingAnimation():Animation {
			return _playingAnimation;
		}
		
		private var _currentFrame:int = 1;
		
		public function get currentFrame():int {
			return _currentFrame;
		}
		
		public function get totalFrames():int {
			return source ? source.linkage.framesCount : 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function play(animationName:String = 'def', repeatsCount:int = 0, onComplete:Function = null, onCompleteParams:Array = null, startFrame:int = 0):void {
			if (!source) return;
			
			if (!source.linkage.hasAnimation(animationName)) throw new Error('No animation ' + animationName);
//			if (this._playingAnimation && this._playingAnimation.proto.name == animationName) return;
			
			var animationProto:AnimationDescriptor = getAnimation(animationName);
			
			var animation:Animation = new Animation();
			animation.proto = animationProto;
			animation.onComplete = onComplete;
			animation.onCompleteParams = onCompleteParams;
			animation.currentFrame = animation.proto.startFrame + startFrame;
			animation.repeatsLeft = repeatsCount > 0 ? repeatsCount : -1;
			
			Starling.current.juggler.add(this);
			this._playingAnimation = animation;
		}
		
		public function stop(applyOnComplete:Boolean = true):void {
			if (!this._playingAnimation) return;
			
			var onComplete:Function = this._playingAnimation.onComplete;
			var onCompleteParams:Array = this._playingAnimation.onCompleteParams;
			this._playingAnimation = null;
			
			if (applyOnComplete && onComplete is Function) onComplete.apply(null, onCompleteParams);
		}
		
		public function gotoAndStop(frame:Object):void {
			if (!source) return;
			
			if (frame is int) {
				if (_currentFrame == frame) return;
				
				_currentFrame = frame as int;
				
				if (_currentFrame > totalFrames) _currentFrame = totalFrames;
				else if (_currentFrame < 1) _currentFrame = 1;
				
				invalidate(INVALIDATION_FLAG_FRAME);
				validate();
			} else {
				var animation:AnimationDescriptor = getAnimation(frame as String);
				if (!animation) return;
				
				this.gotoAndStop(animation.startFrame + 1);
			}
		}
		
		public function getAnimation(name:String):AnimationDescriptor {
			return source.linkage.getAnimationByName(name);
		}
		
		public function advanceTime(time:Number):void {
			if (!this._playingAnimation) {
				Starling.current.juggler.remove(this);
				return;
			}
			
			var delta:int = Math.round(60 * time);
			
			var animation:Animation = this._playingAnimation;
			var framesLeft:int = animation.proto.endFrame - animation.currentFrame;
			if (framesLeft > 0 && framesLeft < delta) {
				delta = framesLeft;
			}
			
			animation.currentFrame += delta;
			
			if (animation.currentFrame > animation.proto.endFrame) {
				animation.repeatsLeft--;
				if (animation.repeatsLeft == 0) {
					this.stop();
					return;
				} else {
					animation.currentFrame = animation.proto.startFrame;
					if (animation.repeatsLeft < -1) animation.repeatsLeft = -1;
				}
			}
			
			gotoAndStop(animation.currentFrame + 1);
		}
		
		public function hide(onComplete:Function = null):void {
			if (!this.visible) return;
			if (!super.stage) {
				this.visible = false;
				return;
			}
			
			this.play('OnHide', 1, function ():void {
				visible = false;
				if (onComplete is Function) onComplete.apply();
			});
		}
		
		public function show(onComplete:Function = null):void {
			if (this.visible) return;
			
			this.visible = true;
			this.play('OnShow', 1, onComplete);
		}
		
		public function hasAnimation(animation:String):Boolean {
			return source ? source.linkage.hasAnimation(animation) : false;
		}
		
		public function getFrameBounds():Rectangle {
			if (!source) return getBounds(this);
			
			var frameBounds:Rectangle = source.linkage.frames[_currentFrame - 1].bounds;
			_bounds.setTo(x + ObjectBuilder.t(frameBounds.x), y + ObjectBuilder.t(frameBounds.y), ObjectBuilder.t(frameBounds.width), ObjectBuilder.t(frameBounds.height));
			return _bounds;
		}
		
		public function addFrameHandler(frame:int, handler:Function):void {
			var list:Vector.<Function> = _frameHandlers[frame] || new Vector.<Function>();
			var index:int = list.indexOf(handler);
			if (index >= 0) return;
			
			list.push(handler);
			_frameHandlers[frame] = list;
		}
		
		public function removeFrameHandler(frame:int, handler:Function):void {
			var list:Vector.<Function> = _frameHandlers[frame];
			if (!list) return;
			
			var index:int = list.indexOf(handler);
			if (index >= 0) list.splice(index, 1);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected override function draw():void {
			super.draw();
			
			if (isInvalid()) {
				if (this._boundArea) {
					super.setSizeInternal(ObjectBuilder.t(_boundArea.width), ObjectBuilder.t(_boundArea.height), false);
				}
			}
			
			if (isInvalid(INVALIDATION_FLAG_FRAME)) {
				updateFrame();
			}
		}
		
		/**
		 * @private
		 */
		protected override function initialize():void {
			super.initialize();
			updateFrame();
			
			if (this.hasAnimation('idle')) this.play('idle');
		}
		
		/**
		 * @private
		 */
		protected function updateFrame():void {
			if (!source) return;
			
			if (source.linkage.framesCount == 1 && _updated) return;
			
			var frames:Vector.<FrameDescriptor> = source.linkage.frames;
			if (_currentFrame > source.linkage.framesCount) return;
			
			if (_playingAnimation) _currentFrame = _playingAnimation.currentFrame + 1;
			
			var frame:FrameDescriptor = frames[_currentFrame - 1];

//			removeChildren();
			
			var numChildren:int = this.numChildren;
			
			// update created objects
			for (var i:int = 0; i < numChildren; i++) {
				var starlingChild:DisplayObject = getChildAt(i);
				if (!frame.hasObject(starlingChild.name)) _childrenToRemove.push(starlingChild);
			}
			
			var len:int = _childrenToRemove.length;
			while (len--) removeChild(_childrenToRemove.pop());
			
			HELPER_BOUNDS.setEmpty();
			// create new objects
			numChildren = frame.objectsCount;
			for (i = 0; i < numChildren; i++) {
				var descriptorChild:DisplayObjectDescriptor = frame.objects[i];
				if (!descriptorChild) continue;
				
				var name:String = descriptorChild.name;
				if (!(name in _childrenHash)) {
					if (name == 'boundArea') {
						this._boundArea = descriptorChild.linkage.frames[0].bounds.clone();
					}
					
					if (this._customFactory && name in this._customFactory) {
						starlingChild = new (this._customFactory[name] as Class)(descriptorChild);
						starlingChild.name = name;
					} else {
						starlingChild = ObjectBuilder.build(descriptorChild);
					}
					
					if (starlingChild) {
						this._childrenHash[starlingChild.name] = starlingChild;
					}
				} else {
					starlingChild = _childrenHash[name];
				}
				
				if (starlingChild is ParserFeathersDisplayObjectContainer) {
					(starlingChild as ParserFeathersDisplayObjectContainer).smoothing = smoothing;
				} else if (starlingChild is ParserFeathersImage && smoothing) {
					(starlingChild as ParserFeathersImage).textureSmoothing = TextureSmoothing.TRILINEAR;
				}
				
				if (!starlingChild.parent || source.linkage.framesCount > 1) addChild(starlingChild);
				
				starlingChild.x = ObjectBuilder.t(descriptorChild.transform.tx);
				starlingChild.y = ObjectBuilder.t(descriptorChild.transform.ty);
				var mtx:Matrix = starlingChild.transformationMatrix;
				
				mtx.copyFrom(descriptorChild.transform);
				mtx.tx = ObjectBuilder.t(mtx.tx);
				mtx.ty = ObjectBuilder.t(mtx.ty);
				starlingChild.transformationMatrix = mtx;
				starlingChild.alpha = descriptorChild.alpha;
				
				if (starlingChild is ParserFeathersTextField || starlingChild is ParserFeathersTextInput) {
					starlingChild.scaleX = 1;
					starlingChild.scaleY = 1;
					starlingChild.x = int(ObjectBuilder.t((descriptorChild as TextFieldDescriptor).x));
					starlingChild.y = int(ObjectBuilder.t((descriptorChild as TextFieldDescriptor).y));
					starlingChild.width = ObjectBuilder.t((descriptorChild as TextFieldDescriptor).width);
					starlingChild.height = ObjectBuilder.t((descriptorChild as TextFieldDescriptor).height);
				} else if (starlingChild is ParserFeathersImage) {
					var img:ParserFeathersImage = starlingChild as ParserFeathersImage;
					if (img.scale9Grid) {
						starlingChild.scaleX = 1;
						starlingChild.scaleY = 1;
						var b:Rectangle = descriptorChild.getFrameBounds();
						starlingChild.width = ObjectBuilder.t(b.width * descriptorChild.transform.a);
						starlingChild.height = ObjectBuilder.t(b.height * descriptorChild.transform.d);
					}
				} else {
					b = descriptorChild.getFrameBounds();
					starlingChild.width = ObjectBuilder.t(b.width * descriptorChild.transform.a);
					starlingChild.height = ObjectBuilder.t(b.height * descriptorChild.transform.d);
				}
				
				if (starlingChild is IValidating) (starlingChild as IValidating).validate();
			}
			
			var frameBounds:Rectangle = source.linkage.frames[_currentFrame - 1].bounds;
			_bounds.setTo(ObjectBuilder.t(frameBounds.x), ObjectBuilder.t(frameBounds.y), ObjectBuilder.t(frameBounds.width), ObjectBuilder.t(frameBounds.height));
			setSizeInternal(_bounds.width, _bounds.height, false);
			
			clearInvalidationFlag(INVALIDATION_FLAG_FRAME);
			_updated = true;
			
			var handlers:Vector.<Function> = _frameHandlers[_currentFrame];
			for each (var h:Function in handlers) {
				h.apply();
			}
		}
		
		
		protected override function added():void {
			super.added();
			
			if (this._playingAnimation) Starling.current.juggler.add(this);
		}
		
		protected override function removed():void {
			Starling.current.juggler.remove(this);
			
			super.removed();
		}
	}
}

import ru.flaswf.reader.descriptors.AnimationDescriptor;

class Animation {
	public var onComplete:Function;
	public var onCompleteParams:Array;
	public var currentFrame:int;
	public var repeatsLeft:int = -1;
	public var proto:AnimationDescriptor;
}