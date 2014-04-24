package
{
	import flash.display.Shape;
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
		
		//init에서 매개변수로 받은 데이터들을 클래스내부에서 사용하기 위해 변수선언함..
		//_imgVector는 이미지 데이터들이 들어있고
		//_imgBorderLine은 이미지 테두리의 두께를 몇으로 할 것인지 들어있음.
		private var _imgVector:Vector.<Image>;
		private var _imgBorderLine:int;
		
		public function TouchProcessing()
		{
		}
		
		/**
		 * 초기화 하는 함수. MOUSE_DOWN, MOUSE_UP, MOUSE_OUT, CLICK  네가지 이벤트를 추가함.
		 * @param imgVector 이미지 데이터들을 ImageProcessing 클래스로부터 받아옴
		 * @param imgBorderLine 이미지 테두리 두께 값을 받아옴
		 */
		public function init(imgVector:Vector.<Image>, imgBorderLine:int):void
		{
			_imgVector = imgVector;
			_imgBorderLine = imgBorderLine;
			
			//마우스 버튼 누른 시점에 발동하게끔..화면 스크롤에서 사용
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			
			//마우스 버튼이 올라왔을 때 발동. 화면 스크롤에서 사용
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
			
			//커서가 화면 밖으로 나갈경우. 화면 스크롤에서 사용
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).addEventListener(MouseEvent.MOUSE_OUT, MouseOutHandler);
			
			//마우스를 클릭 하였을 경우. 이미지 테두리 그릴 때 사용
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).addEventListener(MouseEvent.CLICK, MouseClickHandler);
		}
		
		/**
		 * 마우스 버튼이 눌렸을 때, 현재 터치된 위치를 저장하고 MOUSE_MOVE 이벤트를 추가함.
		 * @param e 이벤트
		 */
		private function MouseDownHandler(e:MouseEvent):void
		{	
			//먼저 그렸던 테두리가 있을 경우 삭제함
			if(GlobalData.globalStage.getChildByName(GlobalData.BORDERLINE_SHAPE_NAME)) GlobalData.globalStage.removeChild(GlobalData.globalStage.getChildByName(GlobalData.BORDERLINE_SHAPE_NAME));

			//현재 마우스의 위치를 저장함. 스크롤에서 이용함
			posX = e.stageX;
			posY = e.stageY;
			
			//마우스 버튼을 누르면 MOUSE_MOVE이벤트를 동작하게 함.
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).addEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 마우스 버튼이 Up 됐을 때 MOUSE_MOVE 이벤트를 제거함.
		 * @param e 이벤트
		 */
		private function MouseUpHandler(e:MouseEvent):void
		{		
			//마우스 버튼이 올라오면 MOUSE_MOVE 이벤트를 끔
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).removeEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 마우스 버튼이 화면 밖으로 나갔을 때 MOUSE_MOVE 이벤트를 제거함.
		 * @param e 이벤트
		 */
		private function MouseOutHandler(e:MouseEvent):void
		{		
			//화면 밖으로 커서가 나갈 경우 MOUSE_MOVE 이벤트를 끔
			GlobalData.globalStage.getChildByName(GlobalData.STAGE_PNG_SPRITE_NAME).removeEventListener(MouseEvent.MOUSE_MOVE, MouseMoveHandler);
		}
		
		/**
		 * 직전의 터치된 위치와 현재 터치된 위치를 비교하여 화면을 스크롤함.
		 * @param e 이벤트
		 */		
		private function MouseMoveHandler(e:MouseEvent):void
		{		
			//새로운 scrollRect가 될 rect
			var rect:Rectangle = e.target.scrollRect;
			
			//이전 마우스 위치와 현재 마우스 위치 값을 이용하여 rect값 설정
			rect.x += (posX - e.stageX);
			rect.y += (posY - e.stageY);
			
			//설정한 값이 만약 Sprite Sheet의 크기를 벗어날 경우 원래 값으로 되돌림.
			if((rect.x < 0) || (rect.x > (e.target.getChildAt(0).width-rect.width))) rect.x -= (posX - e.stageX);
			if((rect.y < 0) || (rect.y > (e.target.getChildAt(0).height-rect.height))) rect.y -= (posY - e.stageY);
			
			//scrollRect를 바꿔주고, 이전마우스위치값을 저장하는 변수를 최신화 시킴
			e.target.scrollRect = rect;
			posX = e.stageX;
			posY = e.stageY;
		}
		
		/**
		 * 마우스 클릭 이벤트를 처리하는 핸들러. 여기서는 개별 이미지에 대한 HIT처리가 이루어지고 그 결과에 따라 테두리를 그리게 됨. 
		 * @param e 이벤트
		 */
		private function MouseClickHandler(e:MouseEvent):void
		{
			//테두리를 그리기 위한 Shape
			var localShape:Shape = new Shape;
			localShape.name = GlobalData.BORDERLINE_SHAPE_NAME;
			
			//HIT 검사하는 과정. 마우스 클릭 좌표를 이용하여 어떤 이미지가 클릭 된건지 if문을 이용하여 검사함.
			for(var i:int = 0; i < _imgVector.length; i++)
			{
				if((_imgVector[i].img.x <= e.localX) && (e.localX <= (_imgVector[i].img.x+_imgVector[i].img.width))
				&& (_imgVector[i].img.y <= e.localY) && (e.localY <= (_imgVector[i].img.y+_imgVector[i].img.height)))
				{
					//충돌된 이미지가 발견 되었을 경우 테두리를 그리는 작업을 실시함.
					localShape.graphics.lineStyle(_imgBorderLine,1,1);
					localShape.graphics.drawRect(_imgVector[i].img.x-e.target.scrollRect.x,_imgVector[i].img.y-e.target.scrollRect.y,_imgVector[i].img.width,_imgVector[i].img.height);
					GlobalData.globalStage.addChild(localShape);
					trace(_imgVector[i].name + "충돌");
				}
			}
			trace("클릭");
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