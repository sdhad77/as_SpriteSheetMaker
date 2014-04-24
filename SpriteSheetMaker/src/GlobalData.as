package
{
	import flash.display.Stage;
	
	/** 
	 * @author 신동환
	 * @brief 전역변수들을 관리하기 위한 클래스
	 *        stage를 모든 클래스에서 사용하기 위해 이곳에서 전역선언함
	 */
	public class GlobalData
	{
		public static const FILENAME_EXTENSION_JPG:String = ".jpg";
		public static const FILENAME_EXTENSION_PNG:String = ".png";
		public static const FILENAME_EXTENSION_BMP:String = ".bmp";
		public static const PATH_IN_FILE:String = "resource/in";
		public static const PATH_OUT_FILE_PNG:String = "out/spritesheet.png";
		public static const PATH_OUT_FILE_XML:String = "out/atlas.xml";
		public static const BITMAP_PIXEL_SNAPPING_AUTO:String = "auto";
		
		public static const STAGE_PNG_SPRITE_NAME:String = "_pngSprite";
		public static const BORDERLINE_SHAPE_NAME:String = "borderShape";
		
		public static const DEVICE_WIDTH:int = 768;
		public static const DEVICE_HEIGHT:int = 1004;
		
		public static const SPRITE_SHEET_2_X_2:int       = 4;
		public static const SPRITE_SHEET_4_X_4:int       = 16;
		public static const SPRITE_SHEET_8_X_8:int       = 64;
		public static const SPRITE_SHEET_16_X_16:int     = 256;
		public static const SPRITE_SHEET_32_X_32:int     = 1024;
		public static const SPRITE_SHEET_64_X_64:int     = 4096;
		public static const SPRITE_SHEET_128_X_128:int   = 16384;
		public static const SPRITE_SHEET_256_X_256:int   = 65536;
		public static const SPRITE_SHEET_512_X_512:int   = 262144;
		public static const SPRITE_SHEET_1024_X_1024:int = 1048576;
		public static const SPRITE_SHEET_2048_X_2048:int = 4194304;
		public static const SPRITE_SHEET_4096_X_4096:int = 16777216;
		
		public static var globalStage:Stage;
		
		/**
		 * @param stage : main클래스에서 받아온 stage
		 * @brief stage를 전역변수에 넣고, setting() 함수를 통해 환경설정을 함.
		 */
		public function GlobalData(stage)
		{	//stage를 전역으로.
			globalStage = stage;
		}
	}
}