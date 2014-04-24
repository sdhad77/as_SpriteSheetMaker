package
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 터치 이벤트를 한곳에서 처리하기 위한 클래스 
	 * @author 신동환
	 */
	public class TouchProcessing
	{
		//바로 직전에 마우스가 있었던 위치를 저장하는 변수
		private var posX:int;
		private var posY:int;
		
		
		public function TouchProcessing()
		{
		}
		
		/**
		 * 초기화 하는 함수. MOUSE_DOWN, MOUSE_UP, MOUSE_OUT 세가지 이벤트를 추가함.
		 */
		public function init():void
		{
			GlobalData.globalStage.getChildAt(1).addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			GlobalData.globalStage.getChildAt(1).addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
			GlobalData.globalStage.getChildAt(1).addEventListener(MouseEvent.MOUSE_OUT, MouseOutHandler);
		}
		
		/**
		 * 마우스 버튼이 눌렸을 때, 현재 터치된 위치를 저장하고 MOUSE_MOVE 이벤트를 추가함.
		 * @param e 이벤트
		 */
		private function MouseDownHandler(e:MouseEvent):void
		{		
			posX = e.stageX;
			posY = e.stageY;
			GlobalData.globalStage.getChildAt(1).addEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 마우스 버튼이 Up 됐을 때 MOUSE_MOVE 이벤트를 제거함.
		 * @param e 이벤트
		 */
		private function MouseUpHandler(e:MouseEvent):void
		{		
			GlobalData.globalStage.getChildAt(1).removeEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 마우스 버튼이 화면 밖으로 나갔을 때 MOUSE_MOVE 이벤트를 제거함.
		 * @param e 이벤트
		 */
		private function MouseOutHandler(e:MouseEvent):void
		{		
			GlobalData.globalStage.getChildAt(1).removeEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 직전의 터치된 위치와 현재 터치된 위치를 비교하여 화면을 스크롤함.
		 * @param e 이벤트
		 */		
		private function MouseMoveHandler(e:MouseEvent):void
		{		
			var rect:Rectangle = e.target.scrollRect;
			rect.x += (posX - e.stageX);
			rect.y += (posY - e.stageY);
			e.target.scrollRect = rect;
			posX = e.stageX;
			posY = e.stageY;
		}
		
		/**
		 * 이벤트 리스너 제거 함수
		 */
		public function cleanEventListener():void
		{
			GlobalData.globalStage.getChildAt(1).removeEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			GlobalData.globalStage.getChildAt(1).removeEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
			GlobalData.globalStage.getChildAt(1).removeEventListener(MouseEvent.MOUSE_OUT, MouseOutHandler);
		}
	}
}