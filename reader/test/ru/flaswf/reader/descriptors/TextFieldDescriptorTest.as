package ru.flaswf.reader.descriptors {

	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;

	import org.flexunit.asserts.assertEquals;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                21.12.2015 0:20
	 */
	public class TextFieldDescriptorTest {

		public static function create():TextFieldDescriptor {
			var td:TextFieldDescriptor = new TextFieldDescriptor();
			td.displayAsPassword = true;
			td.editable = false;
			td.maxChars = 35;
			td.selectable = false;
			td.text = 'test test test';
			td.textFormat = new TextFormat('Arial', 14, 0xFF00FF, true, false, true);
			td.alpha = 0.5;
			td.transform = new Matrix();
			td.linkToDescriptor = 1;
			td.name = 'test#' + int(Math.random() * 1000);

			return td;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TextFieldDescriptorTest() {
			super();
		}

		[Test]
		public function testByteArray():void {
			var td:TextFieldDescriptor = create();
			var ba:ByteArray = new ByteArray();
			td.toByteArray(ba);

			ba.position = 0;
			var td2:TextFieldDescriptor = new TextFieldDescriptor();
			td2.fromByteArray(ba);
			assertEquals(td.displayAsPassword, td2.displayAsPassword);
			assertEquals(td.editable, td2.editable);
			assertEquals(td.multiline, td2.multiline);
			assertEquals(td.selectable, td2.selectable);
			assertEquals(td.text, td2.text);
			assertEquals(td.textFormat.bold, td2.textFormat.bold);
			assertEquals(td.textFormat.color, td2.textFormat.color);
			assertEquals(td.textFormat.size, td2.textFormat.size);
			assertEquals(td.textFormat.font, td2.textFormat.font);
			assertEquals(td.textFormat.italic, td2.textFormat.italic);
		}
	}
}
