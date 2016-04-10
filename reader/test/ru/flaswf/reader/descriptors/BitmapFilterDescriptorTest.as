package ru.flaswf.reader.descriptors {

	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                20.12.2015 23:44
	 */
	public class BitmapFilterDescriptorTest {

		public static function create():BitmapFilterDescriptor {
			var f:BitmapFilterDescriptor = new BitmapFilterDescriptor();
			f.alpha = 1;
			f.angle = 30;
			f.blurX = 2;
			f.blurY = 3;
			f.color = 0xFF0000;
			f.distance = 13;
			f.inner = true;
			f.knockout = false;
			f.strength = 123;
			f.type = BitmapFilterDescriptor.TYPE_DROP_SHADOW;
			return f;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapFilterDescriptorTest() {
			super();
		}

		[Test]
		public function testByteArray():void {
			var f:BitmapFilterDescriptor = create();

			var ba:ByteArray = new ByteArray();
			f.toByteArray(ba);

			ba.position = 0;
			var f2:BitmapFilterDescriptor = new BitmapFilterDescriptor();
			f2.fromByteArray(ba);

			assertEquals(f.alpha, f2.alpha);
			assertEquals(f.angle, f2.angle);
			assertEquals(f.blurX, f2.blurX);
			assertEquals(f.blurY, f2.blurY);
			assertEquals(f.color, f2.color);
			assertEquals(f.distance, f2.distance);
			assertEquals(f.inner, f2.inner);
			assertEquals(f.knockout, f2.knockout);
			assertEquals(f.strength, f2.strength);
			assertEquals(f.type, f2.type);
		}
	}
}
