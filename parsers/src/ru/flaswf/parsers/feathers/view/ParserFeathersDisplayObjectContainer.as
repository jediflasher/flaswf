////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {
	
	import feathers.core.FeathersControl;
	import feathers.core.FeathersControl;

	import flash.geom.Rectangle;

	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    25.05.2015
	 */
	public class ParserFeathersDisplayObjectContainer extends FeathersControl {

		private static const P:String = '.';
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersDisplayObjectContainer(source:DisplayObjectDescriptor) {
			super();
			if (this['constructor'] === ParserFeathersDisplayObjectContainer) {
				throw new Error('Virtual class');
			}

			this.source = source;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		protected var _childrenHash:Object = {};

		protected var _boundArea:Rectangle;

		protected var _customFactory:Object = {}; // Flash linkage name -> Class

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var source:DisplayObjectDescriptor;
		
		/**
		 * @private
		 */
		private var _smoothing:Boolean;
		
		public function get smoothing():Boolean {
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			if (_smoothing == value) return;
			
			_smoothing = value;
		}
		
		protected function get isDataInvalid():Boolean {
			return isInvalid(FeathersControl.INVALIDATION_FLAG_DATA);
		}

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function addFactory(flashChildName:String, starlingClass:Class):void {
			_customFactory[flashChildName] = starlingClass;
		}

		public override function getChildByName(name:String):DisplayObject {
			var result:DisplayObject = _childrenHash[name] as DisplayObject;
			if (result) return result;

			if (name.indexOf(P) == -1) return super.getChildByName(name);
			
			var path:Array = name.split('.');

			var firstElement:DisplayObjectContainer = getChildByName(path.shift()) as DisplayObjectContainer;
			if (!firstElement) return null;

			return firstElement.getChildByName(path.join('.'));
		}

		public function getTextField(name:String):ParserFeathersTextField {
			return this.getChildByName(name) as ParserFeathersTextField;
		}

		public function getButton(name:String):ParserFeathersButton {
			return this.getChildByName(name) as ParserFeathersButton;
		}

		public function getImage(name:String):ParserFeathersImage {
			return this.getChildByName(name) as ParserFeathersImage;
		}

		public function getMovieClip(name:String):ParserFeathersMovieClip {
			return this.getChildByName(name) as ParserFeathersMovieClip;
		}

		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		protected function added():void {

		}

		protected function removed():void {

		}

		protected function assign(childName:String):void {
			var variableName:String = '_' + childName;

			var child:DisplayObject = getChildByName(childName);
			if (child) {
				this[variableName] = child;
			} else {
				throw new Error('Child ' + childName + ' not found');
			}
		}

		protected function autoAssign():void {
			for (var childName:String in _childrenHash) {
				var child:DisplayObject = _childrenHash[childName];
				var propName:String = '_' + child.name;
				if (propName in this) {
					this[propName] = child;
				}
			}
		}

		protected function invalidateData(arg:* = null):void {
			invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		protected override function feathersControl_addedToStageHandler(event:Event):void {
			super.feathersControl_addedToStageHandler(event);
			added();
		}

		protected override function feathersControl_removedFromStageHandler(event:Event):void {
			super.feathersControl_removedFromStageHandler(event);
			removed();
		}
	}
}