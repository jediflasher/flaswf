package ru.flaswf.parsers.feathers.view {

	import feathers.display.TiledImage;

	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.DisplayObjectDescriptor;

	import starling.textures.Texture;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                03.04.2016 13:13
	 */
	public class ParserFeathersTiledImage extends TiledImage {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersTiledImage(descriptor:DisplayObjectDescriptor) {
			var texture:Texture = ObjectBuilder.getTexture(ObjectBuilder.normalize(descriptor.name));
			super(texture);
		}
	}
}
