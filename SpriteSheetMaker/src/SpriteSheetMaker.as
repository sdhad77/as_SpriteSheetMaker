package 
{  
	import flash.display.Sprite;
	
	/**
	 * @author 신동환
	 * @brief main 클래스
	 *        전역 변수를 따로 관리하기 위한 GlobalData클래스 사용
	 *        지정된 경로에서 이미지들을 읽어오기 위한 LoadImage클래스 사용
	 */
	public class SpriteSheetMaker extends Sprite 
	{ 
		public static var globalData:GlobalData;
		private var _imageLoad:ImageLoad = new ImageLoad();
		
		/**
		 * @brief main의 생성자 
		 *        stage를 전역으로 사용하기 위해 GlobalData클래스에 stage를 넘겨줌.
		 *        LoadImage클래스의 loadImage를 이용해 이미지 읽어옴.
		 */
		public function SpriteSheetMaker() 
		{
			globalData = new GlobalData(stage);
			
			_imageLoad.imageLoad();	
		}
	} 
} 