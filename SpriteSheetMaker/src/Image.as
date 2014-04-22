package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Image
	{
		internal var _img:Bitmap;
		internal var _name:String;
		internal var _rotate:Boolean = false;
		private var _mySprite:Sprite = new Sprite;
		
		public function Image()
		{
		}
		
		public function setRect():void
		{
			_mySprite.graphics.beginFill(0x000000,0);
			_mySprite.graphics.drawRect(_img.x, _img.y, _img.width, _img.height);
			_mySprite.graphics.endFill();
			GlobalData.globalStage.addChild(_mySprite);
			_mySprite.addEventListener(MouseEvent.CLICK, MouseClickHandler);
		}
		
		public function MouseClickHandler(e:MouseEvent):void
		{
			var localSprite:Sprite = new Sprite;
			
			if(GlobalData.isFirstTouch) GlobalData.isFirstTouch = false;
			else GlobalData.globalStage.removeChild(GlobalData.beforeUseSprite);

			localSprite.graphics.lineStyle(GlobalData.IMAGE_BORDERLINE,1,1);
			localSprite.graphics.drawRect(_img.x, _img.y, _img.width, _img.height);
			GlobalData.beforeUseSprite = localSprite;
			GlobalData.globalStage.addChild(localSprite);
			
			localSprite = null;
			
			trace("클릭");
		}
	}
}