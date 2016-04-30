////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {
	
	import flash.geom.Rectangle;

	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    27.05.2015
	 */
	public class ParserFeathersScale9Image extends ParserFeathersImage {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersScale9Image(source:DisplayObjectDescriptor) {
			super(source);

			var frameBounds:Rectangle = source.getFrameBounds();
			pivotX = ObjectBuilder.t(-frameBounds.x);
			pivotY = ObjectBuilder.t(-frameBounds.y);
		}
	}
}
