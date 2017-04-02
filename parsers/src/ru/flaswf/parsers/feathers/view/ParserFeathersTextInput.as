package ru.flaswf.parsers.feathers.view {
	
	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	
	import flash.text.TextFormat;
	
	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.TextFieldDescriptor;
	
	/**
	 * @author              Obi
	 * @version             1.0
	 * @playerversion       Flash 10
	 * @langversion         3.0
	 * @date                30.06.15 9:14
	 */
	public class ParserFeathersTextInput extends TextInput {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersTextInput(source:TextFieldDescriptor) {
			super();

			var fmt:TextFormat = source.textFormat;
			fmt.blockIndent = int(ObjectBuilder.t(fmt.blockIndent));
			fmt.indent = int(ObjectBuilder.t(fmt.indent));
			fmt.leading = int(ObjectBuilder.t(fmt.leading));
			fmt.leftMargin = int(ObjectBuilder.t(fmt.leftMargin));
			fmt.letterSpacing = int(ObjectBuilder.t(fmt.letterSpacing));
			fmt.rightMargin = int(ObjectBuilder.t(fmt.rightMargin));
			fmt.size = int(ObjectBuilder.t(fmt.size));
			

			var props:Object = {
				fontSize: fmt.size,
				color: fmt.color,
				fontFamily: fmt.font
			};

			this.promptFactory = function ():ITextRenderer {
				var result:TextFieldTextRenderer = new TextFieldTextRenderer();
				var fmt:TextFormat = fmt;
				result.textFormat = fmt;
				return result;
			};
			
			this.textEditorFactory = function():ITextEditor {
				var result:TextFieldTextEditor = new TextFieldTextEditor();
				result.textFormat = fmt;
				result.embedFonts = true;
				return result;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	}
}
