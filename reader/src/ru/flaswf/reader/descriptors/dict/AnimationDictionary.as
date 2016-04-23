package ru.flaswf.reader.descriptors.dict {

	/**
	 * @author                Obi
	 * @version                1.0
	 * @playerversion        Flash 10
	 * @langversion            3.0
	 * @date                05.07.14 17:39
	 */
	public class AnimationDictionary {

		//---------------------------------------------------------
		//
		// Constructor
		//
		//---------------------------------------------------------

		public function AnimationDictionary(name:String) {
			super();
			this.name = name;
		}

		//---------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------

		public var name:String;

		public var startFrame:int = 0;

		public var endFrame:int = 0;

	}
}
