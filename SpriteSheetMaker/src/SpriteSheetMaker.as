package 
{  
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	/**
	 * main 클래스</br>
	 * 전역 변수를 따로 관리하기 위한 GlobalData클래스 사용</br>
	 * 지정된 경로에서 이미지들을 읽어오기 위한 LoadImage클래스 사용
	 * @author 신동환
	 */
	public class SpriteSheetMaker extends Sprite 
	{ 
		public static var globalData:GlobalData;
		
		/**
		 * main의 생성자 </br>
		 * stage를 전역으로 사용하기 위해 GlobalData클래스에 stage를 넘겨줌.</br>
		 * LoadImage클래스의 loadImage를 이용해 이미지 읽어옴.
		 */
		public function SpriteSheetMaker() 
		{
			setting();
			
			globalData = new GlobalData(stage);
			
			var imageProcessing:ImageProcessing = new ImageProcessing;
			imageProcessing.imageLoad();
		}
		
		/**
		 * 환경설정을 하는 함수 
		 */
		private function setting():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;  
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
		}
		
		/**
		 * 화면에서 어플리케이션이 사라질 경우 자동으로 종료.
		 * @param e : 전역 stage의 이벤트
		 */
		private function deactivate(e:Event):void   
		{  
			NativeApplication.nativeApplication.exit();  
		} 
	} 
} 