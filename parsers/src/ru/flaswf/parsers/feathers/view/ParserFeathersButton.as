////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {
	
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;
	import feathers.core.FeathersControl;

	import flash.geom.Rectangle;

	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.AnimationDescriptor;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.display.DisplayObject;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.05.2015
	 */
	public class ParserFeathersButton extends ToggleButton {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersButton(source:DisplayObjectDescriptor) {
			super();
			isToggle = false;
			_source = source;

			var frameBounds:Rectangle = source.linkage.frames[0].bounds;
			pivotX = ObjectBuilder.t(-frameBounds.x);
			pivotY = ObjectBuilder.t(-frameBounds.y);

			parse();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		private var _frameLabels:Object = {};

		private var _hitAreaRect:Rectangle;

		private var _source:DisplayObjectDescriptor;

		private var _skin:ParserFeathersMovieClip;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _overwrittenLabel:String;

		public override function set label(value:String):void {
			if (this._overwrittenLabel != value) {
				this._overwrittenLabel = value;
				super.invalidate(FeathersControl.INVALIDATION_FLAG_DATA);
			}
		}

		public override function get label():String {
			return this._overwrittenLabel;
		}

		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		protected override function initialize():void {
			super.initialize();
			super.useHandCursor = true;
		}

		/**
		 * @private
		 */
		protected override function draw():void {
			var stateInvalid:Boolean = super.isInvalid(FeathersControl.INVALIDATION_FLAG_STATE);
			super.clearInvalidationFlag(FeathersControl.INVALIDATION_FLAG_STATE);
			super.draw();

			if (stateInvalid) {
				this._skin.gotoAndStop(getStateBySkin(currentState));
			}

			if (stateInvalid || super.isInvalid(FeathersControl.INVALIDATION_FLAG_SIZE)) {
				var hitArea:DisplayObject = _skin.getChildByName('_hitArea');
				if (hitArea) {
					this._hitAreaRect = new Rectangle();
					this._hitAreaRect.x = ObjectBuilder.t(hitArea.bounds.x);
					this._hitAreaRect.y = ObjectBuilder.t(hitArea.bounds.y);
					this._hitAreaRect.width = ObjectBuilder.t(hitArea.bounds.width);
					this._hitAreaRect.height = ObjectBuilder.t(hitArea.bounds.height);
				}
				if (this._hitAreaRect) {
					this.isQuickHitAreaEnabled = true;
					this.minTouchWidth = ObjectBuilder.t(this._hitAreaRect.width);
					this.minTouchHeight = ObjectBuilder.t(this._hitAreaRect.height);
				}
			}

			if (stateInvalid || super.isInvalid(FeathersControl.INVALIDATION_FLAG_DATA)) {
				var tf:ParserFeathersTextField = _skin.getTextField('label');
				if (tf) {
					tf.text = this._overwrittenLabel;
					tf.validate();
				}
			}
		}

		/**
		 * @private
		 */
		protected override function refreshHitAreaX():void {
			if (this._hitAreaRect) {
				super._hitArea.x = ObjectBuilder.t(this._hitAreaRect.x);
				super._hitArea.width = ObjectBuilder.t(this._hitAreaRect.width);
			} else {
				super.refreshHitAreaX();
			}
		}

		/**
		 * @private
		 */
		protected override function refreshHitAreaY():void {
			if (this._hitAreaRect) {
				super._hitArea.y = ObjectBuilder.t(this._hitAreaRect.y);
				super._hitArea.height = ObjectBuilder.t(this._hitAreaRect.height);
			} else {
				super.refreshHitAreaY();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		private function parse():void {
			var labels:Vector.<AnimationDescriptor> = _source.linkage.animations;
			for each (var label:AnimationDescriptor in labels) this._frameLabels[label.name] = true;

			this._skin = new ParserFeathersMovieClip(_source) as ParserFeathersMovieClip;
			if (_source.name) this._skin.name = _source.name;
			this.defaultSkin = this._skin;
			if (this._skin.hasAnimation('up')) this.hoverSkin = this._skin;
			if (this._skin.hasAnimation('down')) this.downSkin = this._skin;
			if (this._skin.hasAnimation('disabled')) this.disabledSkin = this._skin;
			if (this._skin.hasAnimation('up_selected')) this.selectedUpSkin = this._skin;
			if (this._skin.hasAnimation('over_selected')) this.selectedHoverSkin = this._skin;
			if (this._skin.hasAnimation('down_selected')) this.selectedDownSkin = this._skin;
		}

		private function getStateBySkin(skin:String):String {
			var result:String;
			switch (skin) {
				case Button.STATE_UP:
					result = 'up';
					break;
				case Button.STATE_DOWN:
					result = 'down';
					break;
				case Button.STATE_HOVER:
					result = 'over';
					break;
				case Button.STATE_DISABLED:
					return 'disabled';
			}

			if (isSelected) result += '_selected';
			return result;
		}
	}
}
