package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Image
	{
		private var _img:Bitmap;
		private var _name:String;
		private var _rotate:Boolean = false;
		private var _mySprite:Sprite = new Sprite;
		private var _isPacked:Boolean = false;
		private var _size:int;
		
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
		
		public function get img():Bitmap                 {   return _img;       }
		public function set img(value:Bitmap):void       {   _img = value;      }
		public function get name():String                {   return _name;      }
		public function set name(value:String):void      {   _name = value;     }
		public function get rotate():Boolean             {   return _rotate;    }
		public function set rotate(value:Boolean):void   {   _rotate = value;   }
		public function get isPacked():Boolean           {   return _isPacked;  }
		public function set isPacked(value:Boolean):void {   _isPacked = value; }
		public function get size():int                   {   return _size;      }
		public function set size(value:int):void         {   _size = value;     }
	}
}