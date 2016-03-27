////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {

	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.textures.Texture;

	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    27.05.2015
	 */
	public class ParserFeathersScale9Image extends Scale9Image {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersScale9Image(source:DisplayObjectDescriptor) {
			var rect:Rectangle = source.linkage.scale9Grid.clone();
			rect.setTo(ObjectBuilder.t(rect.x), ObjectBuilder.t(rect.y), ObjectBuilder.t(rect.width), ObjectBuilder.t(rect.height));
			var texture:Texture = ObjectBuilder.getTexture(ObjectBuilder.normalize(source.linkage.name));
			var textures:Scale9Textures = new Scale9Textures(texture, rect);
			super(textures);

			var frameBounds:Rectangle = source.getFrameBounds();
			pivotX = ObjectBuilder.t(-frameBounds.x);
			pivotY = ObjectBuilder.t(-frameBounds.y);
		}

		public function get rect():Rectangle {
			return super.textures.scale9Grid;
		}
	}
}
