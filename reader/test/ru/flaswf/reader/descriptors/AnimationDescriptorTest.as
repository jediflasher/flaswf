package ru.flaswf.reader.descriptors {

	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	public class AnimationDescriptorTest {

		public static function create():AnimationDescriptor {
			var a:AnimationDescriptor = new AnimationDescriptor();
			a.startFrame = 5;
			a.endFrame = 10;
			a.name = 'test' + int(Math.random() * 100);
			return a;
		}

		public function AnimationDescriptorTest() {

		}

		[Test]
		public function testByteArray():void {
			var a:AnimationDescriptor = create();

			var ba:ByteArray = new ByteArray();
			a.toByteArray(ba);

			ba.position = 0;
			var a2:AnimationDescriptor = new AnimationDescriptor();
			a2.fromByteArray(ba);

			assertEquals(a.startFrame, a2.startFrame);
			assertEquals(a.endFrame, a2.endFrame);
			assertEquals(a.name, a2.name);
		}
	}
}
