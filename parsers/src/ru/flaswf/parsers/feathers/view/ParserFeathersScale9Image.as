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

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    27.05.2015
	 */
	public class ParserFeathersScale9Image extends Image {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersScale9Image(source:DisplayObjectDescriptor) {
			var texture:Texture = ObjectBuilder.getTexture(ObjectBuilder.normalize(source.linkage.name));
			super(texture);

			var rect:Rectangle = source.linkage.scale9Grid.clone();
			rect.setTo(ObjectBuilder.t(rect.x), ObjectBuilder.t(rect.y), ObjectBuilder.t(rect.width), ObjectBuilder.t(rect.height));
			scale9Grid = rect;

			var frameBounds:Rectangle = source.getFrameBounds();
			pivotX = ObjectBuilder.t(-frameBounds.x);
			pivotY = ObjectBuilder.t(-frameBounds.y);
		}
	}
}
