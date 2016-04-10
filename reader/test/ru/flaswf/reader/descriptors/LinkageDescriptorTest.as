package ru.flaswf.reader.descriptors {
	
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertEquals;
	
	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                21.12.2015 0:06
	 */
	public class LinkageDescriptorTest {
		
		public static function create():LinkageDescriptor {
			var ld:LinkageDescriptor = new LinkageDescriptor();
			ld.scale9Grid = new Rectangle(10, 20, 30, 40);
			ld.animations.push(AnimationDescriptorTest.create(), AnimationDescriptorTest.create());
			ld.frames.push(FrameDescriptorTest.create(), FrameDescriptorTest.create());
			ld.link = 1;
			ld.name = 'test#' + int(Math.random() * 1000);
			return ld;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function LinkageDescriptorTest() {
			super();
		}
		
		[Test]
		public function testByteArray():void {
			var ld:LinkageDescriptor = create();
			
			var ba:ByteArray = new ByteArray();
			ld.toByteArray(ba);
			
			ba.position = 0;
			var ld2:LinkageDescriptor = new LinkageDescriptor();
			ld2.fromByteArray(ba);
			
			assertEquals(ld.frames.length, ld2.frames.length);
			assertEquals(ld.scale9Grid.width, ld2.scale9Grid.width);
			assertEquals(ld.animations.length, ld2.animations.length);
			assertEquals(ld.link, ld2.link);
			assertEquals(ld.name, ld2.name);
		}
	}
}
