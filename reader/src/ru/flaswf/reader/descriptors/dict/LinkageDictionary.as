package ru.flaswf.reader.descriptors.dict {


	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 17:55
	 */
	public class LinkageDictionary {

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function LinkageDictionary(name:String) {
			super();
			this.name = name;
		}

		//---------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------

		public const animations:Vector.<AnimationDictionary> = new Vector.<AnimationDictionary>();

		public var name:String;

		//---------------------------------------------------------
		//
		// Variables
		//
		//---------------------------------------------------------

		/**
		 * @private
		 */
		private const _hash:Object = {}; // animation name -> AnimationDictionary

		//---------------------------------------------------------
		//
		// Public methods
		//
		//---------------------------------------------------------

		public function add(animation:AnimationDictionary):void {
			animations.push(animation);
			this._hash[animation.name] = animation;
		}

		public function getAnimation(name:String):AnimationDictionary {
			return this._hash[name];
		}

		public function hasAnimation(name:String):Boolean {
			return name in this._hash;
		}
	}
}
