package
{
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class SpriteSheetPrint
	{
		public function SpriteSheetPrint()
		{
		}
		
		public function print():void
		{
			var pngSource:BitmapData = new BitmapData (GlobalData.SPRITE_SHEET_MAX_WIDTH, GlobalData.SPRITE_SHEET_MAX_HEIGHT,true,0x00000000);
			
			for(var i:int; i<GlobalData.imgVector.length; i++)
			{
				if(GlobalData.imgVector[i]._isPacked) pngSource.draw(GlobalData.imgVector[i]._img, new Matrix(1,0,0,1,GlobalData.imgVector[i]._img.x,GlobalData.imgVector[i]._img.y));
			}
			
			var ba:ByteArray = PNGEncoder.encode(pngSource);
			var file:File = File.desktopDirectory.resolvePath(GlobalData.PATH_OUT_FILE_PNG);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(ba);
			fileStream.close();
			
			GlobalData.globalStage.addChild(new Bitmap(pngSource));
			
			fileStream = null;
			file = null;
			
			trace("출력완료");
		}
	}
}