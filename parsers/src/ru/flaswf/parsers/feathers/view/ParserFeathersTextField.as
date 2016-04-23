////////////////////////////////////////////////////////////////////////////////
//
//  © 2015 CrazyPanda LLC
//
////////////////////////////////////////////////////////////////////////////////
package ru.flaswf.parsers.feathers.view {
	
	import feathers.controls.text.TextFieldTextRenderer;
	
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import ru.flaswf.parsers.feathers.ObjectBuilder;
	import ru.flaswf.reader.descriptors.BitmapFilterDescriptor;
	import ru.flaswf.reader.descriptors.TextFieldDescriptor;
	
	/**
	 * @author                    Obi
	 * @langversion                3.0
	 * @date                    22.05.2015
	 */
	public class ParserFeathersTextField extends TextFieldTextRenderer {

		private static const PROCESSED_TEXTFIELDS:Dictionary = new Dictionary(true);

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function ParserFeathersTextField(source:TextFieldDescriptor) {
			super();

			var fmt:TextFormat = source.textFormat;
			var nativeFilters:Array;

			if (!(source in PROCESSED_TEXTFIELDS)) {
				var configFilters:Vector.<BitmapFilterDescriptor> = source.filters;
				if (configFilters) {

					nativeFilters = [];

					for each (var fd:BitmapFilterDescriptor in configFilters) {
						var f:BitmapFilter = BitmapFilterDescriptor.toNative(fd);

						if (f is GlowFilter) {
							(f as GlowFilter).blurX = ObjectBuilder.t((f as GlowFilter).blurX);
							(f as GlowFilter).blurY = ObjectBuilder.t((f as GlowFilter).blurY);
						}

						nativeFilters.push(f);
					}
				}

				fmt.blockIndent = int(ObjectBuilder.t(fmt.blockIndent));
				fmt.indent = int(ObjectBuilder.t(fmt.indent));
				fmt.leading = int(ObjectBuilder.t(fmt.leading));
				fmt.leftMargin = int(ObjectBuilder.t(fmt.leftMargin));
				fmt.letterSpacing = int(ObjectBuilder.t(fmt.letterSpacing));
				fmt.rightMargin = int(ObjectBuilder.t(fmt.rightMargin));
				fmt.size = int(ObjectBuilder.t(fmt.size));

				PROCESSED_TEXTFIELDS[source] = true;
			}

			super.nativeFilters = nativeFilters;
			displayAsPassword = source.displayAsPassword;
			embedFonts = true;
			isHTML = true;
			textFormat = fmt;
			pixelSnapping = true;
			useSnapshotDelayWorkaround = true;

			super.wordWrap = source.multiline;
			super.width = ObjectBuilder.t(source.width);
			super.height = ObjectBuilder.t(source.height);

			super.text = source.text;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		protected override function draw():void {
			super.draw();

			if (isInvalid()) {
				setSizeInternal(textField.textWidth, textField.textHeight + ObjectBuilder.t(10), false);
			}
		}
	}
}
