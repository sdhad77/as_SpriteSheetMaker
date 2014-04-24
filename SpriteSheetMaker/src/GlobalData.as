package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
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
		
		public static const SPRITE_SHEET_MAX_WIDTH:int = 1024;
		public static const SPRITE_SHEET_MAX_HEIGHT:int = 1024;
		
		public static var globalStage:Stage;
		
		//mouse click 이벤트를 처리하기 위한 전역변수.
		//isFirstTouch 는 처음으로 클릭한것인지 판별하기 위함
		public static var isFirstTouch:Boolean = true;
		
		//mouse click의 결과로 이미지의 테두리를 그릴때 이전에 그린것을 삭제하기 위해 존재하는 Sprite
		public static var beforeUseSprite:Sprite = new Sprite;
		
		/**
		 * @param stage : main클래스에서 받아온 stage
		 * @brief stage를 전역변수에 넣고, setting() 함수를 통해 환경설정을 함.
		 */
		public function GlobalData(stage)
		{	//stage를 전역으로.
			globalStage = stage;
			
			setting();
		}
		
		/**
		 * @brief 환경설정을 하는 함수 
		 */
		private function setting():void
		{
			globalStage.scaleMode = StageScaleMode.NO_SCALE;  
			globalStage.align = StageAlign.TOP_LEFT;
			globalStage.addEventListener(Event.DEACTIVATE, deactivate);
		}
		
		/**
		 * @param e : 전역 stage의 이벤트
		 * @brief 화면에서 어플리케이션이 사라질 경우 자동으로 종료.
		 */
		private function deactivate(e:Event):void   
		{  
			NativeApplication.nativeApplication.exit();  
		} 
	}
}