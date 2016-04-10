package ru.flaswf.reader.descriptors {

	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	public class DisplayObjectDescriptorTest {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static function create():DisplayObjectDescriptor {
			var o:DisplayObjectDescriptor = new DisplayObjectDescriptor();
			o.alpha = 0.5;
			o.transform = new Matrix();
			o.linkToDescriptor = 1;
			o.name = 'test';
			return o;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function DisplayObjectDescriptorTest() {
			super();
		}

		[Test]
		public function byteArrayTest():void {
			var o:DisplayObjectDescriptor = create();

			var ba:ByteArray = new ByteArray();
			o.toByteArray(ba);
			ba.position = 0;

			var o2:DisplayObjectDescriptor = new DisplayObjectDescriptor();
			o2.fromByteArray(ba);

			assertEquals(o.alpha, o2.alpha);
			assertEquals(o.linkToDescriptor, o2.linkToDescriptor);
			assertEquals(o.name, o2.name);
		}
	}
}
