package ru.flaswf.reader.descriptors {

	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;

	import ru.swfReader.descriptors.TextFieldDescriptorTest;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                20.12.2015 23:51
	 */
	public class FrameDescriptorTest {

		public static function create():FrameDescriptor {
			var f:FrameDescriptor = new FrameDescriptor();
			f.bounds = new Rectangle(10, 20, 30, 40);
			f.objects.push(
					DisplayObjectDescriptorTest.create(),
					TextFieldDescriptorTest.create(),
					TextFieldDescriptorTest.create()
			);
			return f;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FrameDescriptorTest() {
			super();
		}

		[Test]
		public function test_toByteArray():void {
			var f:FrameDescriptor = new FrameDescriptor();
			f.bounds = new Rectangle(10, 20, 30, 40);

			var ba:ByteArray = new ByteArray();
			f.toByteArray(ba);

			assertTrue(ba.length > 0);
		}

		[Test]
		public function testByteArray():void {
			var f:FrameDescriptor = create();

			var ba:ByteArray = new ByteArray();
			f.toByteArray(ba);

			ba.position = 0;
			var f2:FrameDescriptor = new FrameDescriptor();
			f2.fromByteArray(ba);

			assertEquals(f.objects.length, f2.objects.length);
			assertEquals(f.bounds.width, f2.bounds.width);
		}
	}
}
