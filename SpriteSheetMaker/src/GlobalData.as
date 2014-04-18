package
{
	import flash.desktop.NativeApplication;
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
		
		public static var globalStage:Stage;
		
		/**
		 * @param stage : main클래스에서 받아온 stage
		 * @brief stage를 전역변수에 넣고, setting() 함수를 통해 환경설정을 함.
		 */
		public function GlobalData(stage)
		{
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