package ru.flaswf.reader.descriptors {

	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                21.12.2015 0:31
	 */
	public class SwfDescriptorTest {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SwfDescriptorTest() {
			super();
		}

		[Test]
		public function testByteArray():void {
			var sd:SwfDescriptor = new SwfDescriptor();
			sd.addLinkage(LinkageDescriptorTest.create());
			sd.addLinkage(LinkageDescriptorTest.create());
			sd.addLinkage(LinkageDescriptorTest.create());

			var ba:ByteArray = new ByteArray();
			sd.toByteArray(ba);

			ba.position = 0;
			var sd2:SwfDescriptor = new SwfDescriptor();
			sd2.fromByteArray(ba);

			assertEquals(sd.linkages.length, sd2.linkages.length);
		}
	}
}
