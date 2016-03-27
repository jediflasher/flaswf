package ru.flaswf.writer {

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import ru.flaswf.reader.descriptors.LinkageDescriptor;
	import ru.flaswf.reader.descriptors.SwfDescriptor;
	import ru.flaswf.reader.utils.MatrixPacker;
	import ru.flaswf.writer.util.getDefinitionNames;

	import spark.components.Alert;

	/**
	 * @author              Roman
	 * @version             1.0
	 * @playerversion       Flash 11
	 * @langversion         3.0
	 * @date                19.12.2015 17:29
	 */
	public class SWFWriter {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SWFWriter() {
			super();
		}

		public static function processSwf(loader:Loader, fileName:String, targetPath:String):void {
			trace('============= ' + fileName + '.swf' + ' =============');

			var loaderDomain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
			var names:Array = getDefinitionNames(loader.contentLoaderInfo, false, true);
			var rasterizer:DisplayRasterizer = new DisplayRasterizer();
			var swf:SwfDescriptor = new SwfDescriptor();

			for each(var className:String in names) {
				if (swf.getLinkageByName(className)) continue;

				try {
					var clazz:Class = Class(loaderDomain.getDefinition(className));
					var c:* = new clazz();
					if (!(c is Sprite)) {
						trace('linkage is ' + c + '. Skip');
						continue;
					}

					var linkages:Vector.<LinkageDescriptor> = rasterizer.rasterize(c as Sprite, className);
					for each (var link:LinkageDescriptor in linkages) {
						swf.addLinkage(link);
					}

					trace('processed ' + className);
				} catch (e:Error) {
					trace('==============ERROR==============');
					trace(e.message + '\n' + e.getStackTrace());
					trace('=================================');

					Alert.show(e.message + '\n' + e.getStackTrace(), e.name);
				}
			}

			savePackedAnimationDescriptors(swf, fileName, targetPath);
			trace('processed ' + fileName + ' matrix wrote: ' + MatrixPacker.count, rasterizer.mtxCount);
		}

		private static function savePackedAnimationDescriptors(swfDescriptor:SwfDescriptor, fileName:String, outPath:String):void {
			var result:ByteArray = new ByteArray();
			swfDescriptor.toByteArray(result);
			result.compress("lzma");
			fileName = outPath + "/" + fileName + ".animation";

			var fileStream:FileStream = new FileStream();
			fileStream.open(new File(fileName), FileMode.WRITE);
			fileStream.writeBytes(result);
			fileStream.close();

			trace('Animation: ' + fileName + ' after compress:' + (result.length / 1024).toFixed(2) + 'kb');

			setTimeout(function ():void {
				var t:Number = getTimer();
				var swf:SwfDescriptor = new SwfDescriptor(result);
				trace('\n\n');
				trace('decompressed: ' + (getTimer() - t) + ' ms.');
			}, 1000);
		}
	}
}
