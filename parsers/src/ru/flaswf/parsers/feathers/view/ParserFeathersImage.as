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
	
	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.05.2015
	 */
	public class ParserFeathersImage extends Image {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ParserFeathersImage(source:DisplayObjectDescriptor, textureName:String = null) {
			super(ObjectBuilder.getTexture(ObjectBuilder.normalize(textureName || source.linkage.name)));
			this.source = source;
			
			if (this.source.linkage.scale9Grid) {
				var rect:Rectangle = source.linkage.scale9Grid.clone();
				rect.setTo(ObjectBuilder.t(rect.x), ObjectBuilder.t(rect.y), ObjectBuilder.t(rect.width), ObjectBuilder.t(rect.height));
				scale9Grid = rect;
			}
			
			var frameBounds:Rectangle = source.linkage.frames[0].bounds;
			pivotX = ObjectBuilder.t(-frameBounds.x);
			pivotY = ObjectBuilder.t(-frameBounds.y);
		}
		
		public var source:DisplayObjectDescriptor;
		
		public override function set scaleX(value:Number):void {
			if (scaleX == value) return;
			
			super.scaleX = value;
		}
		
		public override function set scaleY(value:Number):void {
			if (super.scaleY == value) return;
			
			super.scaleY = value;
		}
	}
}
