package
{
	import flash.display.Bitmap;

	public class Image
	{
		private var _img:Bitmap;
		private var _name:String;
		private var _rotate:Boolean = false;
		private var _isPacked:Boolean = false;
		private var _size:int;
		
		public function Image()
		{
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