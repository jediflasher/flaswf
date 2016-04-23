package ru.flaswf.parsers.feathers.view {
	
	import flash.geom.Rectangle;

	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                03.04.2016 13:13
	 */
	public class ParserFeathersTiledImage extends ParserFeathersImage {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersTiledImage(source:DisplayObjectDescriptor) {
			super(source);
			tileGrid = new Rectangle();
		}
	}
}
