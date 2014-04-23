package
{
	public class ImagePacking
	{
		private var _rect:Rect;
		private var _node:Node;
		private var imgVectorIdx:int = 0;
		private var packingTreeRoot:Node = new Node;
		
		public function ImagePacking()
		{
			packingTreeRoot.rect = new Rect(GlobalData.IMAGE_BORDERLINE,GlobalData.IMAGE_BORDERLINE,GlobalData.SPRITE_SHEET_MAX_WIDTH,GlobalData.SPRITE_SHEET_MAX_HEIGHT);
		}
		
		/**
		 *  @brief 이미지 한장으로 합치는 함수.
		 */
		public function imgPacking():void
		{
			//Sheet에 추가할 이미지의 width,height 세팅
			_rect = new Rect(0,0,
				GlobalData.imgVector[imgVectorIdx].img.width + GlobalData.IMAGE_BORDERLINE,
				GlobalData.imgVector[imgVectorIdx].img.height + GlobalData.IMAGE_BORDERLINE);         
			
			//트리 탐색과정
			_node = packingTreeRoot.Insert_Rect(_rect);   
			
			//이미지가 저장될 공간이 있을 경우
			if(_node)
			{	
				//이미지 위치 세팅 후 addChild
				GlobalData.imgVector[imgVectorIdx].img.x = _node.rect.x;
				GlobalData.imgVector[imgVectorIdx].img.y = _node.rect.y;
				GlobalData.imgVector[imgVectorIdx].setRect();
				GlobalData.imgVector[imgVectorIdx].isPacked = true;
			}
				//이미지 저장할 공간이 없을 경우
			else trace("packing 실패");
			nextImage();
		}
		
		/** 
		 *  @brief Sheet에 추가할 다음 이미지로 인덱스를 이동시킴.
		 */
		private function nextImage():void{
			//다음이미지로 이동
			if(GlobalData.imgVector.length > imgVectorIdx) imgVectorIdx++;
			
			//이미지 끝까지 인덱스가 이동했는지 검사
			if(GlobalData.imgVector.length != imgVectorIdx) imgPacking();
		}
	}
}