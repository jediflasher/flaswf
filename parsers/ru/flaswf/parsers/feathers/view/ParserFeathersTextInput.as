package ru.flaswf.parsers.feathers.view {

	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextRenderer;
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

			var props:Object = {
				fontSize: ObjectBuilder.t(Number(fmt.size)),
				color: fmt.color,
				fontFamily: '_sans'
			};

			this.promptFactory = function ():ITextRenderer {
				var result:TextFieldTextRenderer = new TextFieldTextRenderer();
				var fmt:TextFormat = new TextFormat(props.font, props.fontSize, props.color);
				result.textFormat = fmt;
				return result;
			};

			this.textEditorProperties = props;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
	}
}
