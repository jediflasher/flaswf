package ru.flaswf.reader.descriptors {
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                19.12.2015 17:41
	 */
	public class TextFieldDescriptor extends DisplayObjectDescriptor {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TextFieldDescriptor() {
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public var text:String;
		
		public var embedFonts:Boolean;
		
		public var multiline:Boolean;
		
		public var wordWrap:Boolean;
		
		public var restrict:String;
		
		public var editable:Boolean;
		
		public var selectable:Boolean;
		
		public var displayAsPassword:Boolean;
		
		public var maxChars:int;
		
		public var textFormat:TextFormat;

		public var x:int;

		public var y:int;

		public var width:Number = 0;

		public var height:Number = 0;

		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function fromByteArray(byteArray:ByteArray):void {
			super.fromByteArray(byteArray);

			text = byteArray.readUTF();
			embedFonts = byteArray.readBoolean();
			multiline = byteArray.readBoolean();
			wordWrap = byteArray.readBoolean();
			editable = byteArray.readBoolean();
			selectable = byteArray.readBoolean();
			displayAsPassword = byteArray.readBoolean();
			maxChars = byteArray.readUnsignedInt();
			x = byteArray.readInt();
			y = byteArray.readInt();
			width = byteArray.readFloat();
			height = byteArray.readFloat();

			var alignFlag:uint = byteArray.readShort();
			var align:String;
			switch (alignFlag) {
				case 0:
					align = TextFormatAlign.LEFT;
					break;
				case 1:
					align = TextFormatAlign.RIGHT;
					break;
				case 2:
					align = TextFormatAlign.CENTER;
					break;
				case 3:
					align = TextFormatAlign.JUSTIFY;
					break;
				case 4:
					align = TextFormatAlign.START;
					break;
				case 5:
					align = TextFormatAlign.END;
					break;
			}

			textFormat = new TextFormat();
			textFormat.align = align;
			textFormat.blockIndent = byteArray.readUnsignedInt();
			textFormat.bold = byteArray.readBoolean();
			textFormat.bullet = byteArray.readBoolean();
			textFormat.color = byteArray.readUnsignedInt();
			textFormat.font = byteArray.readUTF();
			textFormat.indent = byteArray.readUnsignedInt();
			textFormat.italic = byteArray.readBoolean();
			textFormat.kerning = byteArray.readBoolean();
			textFormat.leading = byteArray.readUnsignedInt();
			textFormat.leftMargin = byteArray.readUnsignedInt();
			textFormat.letterSpacing = byteArray.readFloat();
			textFormat.rightMargin = byteArray.readUnsignedInt();
			textFormat.size = byteArray.readUnsignedInt();
			textFormat.underline = byteArray.readBoolean();
		}

		public override function toByteArray(byteArray:ByteArray):void {
			super.toByteArray(byteArray);

			byteArray.writeUTF(text);
			byteArray.writeBoolean(embedFonts);
			byteArray.writeBoolean(multiline);
			byteArray.writeBoolean(wordWrap);
			byteArray.writeBoolean(editable);
			byteArray.writeBoolean(selectable);
			byteArray.writeBoolean(displayAsPassword);
			byteArray.writeUnsignedInt(maxChars);
			byteArray.writeInt(x);
			byteArray.writeInt(y);
			byteArray.writeFloat(width);
			byteArray.writeFloat(height);

			var alignFlag:uint;

			switch (textFormat.align) {
				case TextFormatAlign.LEFT:
					alignFlag = 0;
					break;
				case TextFormatAlign.RIGHT:
					alignFlag = 1;
					break;
				case TextFormatAlign.CENTER:
					alignFlag = 2;
					break;
				case TextFormatAlign.JUSTIFY:
					alignFlag = 3;
					break;
				case TextFormatAlign.START:
					alignFlag = 4;
					break;
				case TextFormatAlign.END:
					alignFlag = 5;
					break;
			}

			byteArray.writeShort(alignFlag);

			// TextFormat
			byteArray.writeUnsignedInt(int(textFormat.blockIndent));
			byteArray.writeBoolean(textFormat.bold);
			byteArray.writeBoolean(textFormat.bullet);
			byteArray.writeUnsignedInt(int(textFormat.color));
			byteArray.writeUTF(textFormat.font);
			byteArray.writeUnsignedInt(int(textFormat.indent));
			byteArray.writeBoolean(textFormat.italic);
			byteArray.writeBoolean(textFormat.kerning);
			byteArray.writeUnsignedInt(int(textFormat.leading));
			byteArray.writeUnsignedInt(int(textFormat.leftMargin));
			byteArray.writeFloat(int(textFormat.letterSpacing));
			byteArray.writeUnsignedInt(int(textFormat.rightMargin));
			byteArray.writeUnsignedInt(int(textFormat.size));
			byteArray.writeBoolean(textFormat.underline);
		}
	}
}
