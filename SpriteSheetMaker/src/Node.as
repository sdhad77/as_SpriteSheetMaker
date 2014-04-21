package
{
	public class Node
	{
		private var _left:Node;
		private var _right:Node;
		private var _rect:Rect;
		private var _filled:Boolean;
	
		public function Node()
		{
		}
		
		public function Insert_Rect(rc:Rect):Node
		{
			if(this._left != null) return this._left.Insert_Rect(rc) || this._right.Insert_Rect(rc);
			
			if(_filled) return null;
			
			if(rc.isSameSize(this._rect))
			{
				_filled = true;
				return this;
			}
			
			if(rc.isTooBig(this._rect)) return null;
			
			_left = new Node();
			_right = new Node();
			
			var dw:int = this._rect.width - rc.width;
			var dh:int = this._rect.height - rc.height;       
	
			if(dw > dh)
			{
				this._left._rect = new Rect(this._rect.x, this._rect.y, rc.width, this._rect.height);
				this._right._rect = new Rect(this._rect.x + rc.width, this._rect.y,dw, this._rect.height);
			}
			
			else 
			{
				this._left._rect = new Rect(this._rect.x, this._rect.y, this._rect.width, rc.height);
				this._right._rect = new Rect(this._rect.x, this._rect.y + rc.height, this._rect.width, dh);
			}        
			
			return this._left.Insert_Rect(rc); 
		}
		
		public function get filled():Boolean            {   return _filled;     }
		public function set filled(value:Boolean):void  {   _filled = value;    }
		public function get rect():Rect                 {   return _rect;       }
		public function set rect(value:Rect):void       {   _rect = value;      }
		public function get right():Node                {   return _right;      }
		public function set right(value:Node):void      {   _right = value;     }
		public function get left():Node                 {   return _left;       }
		public function set left(value:Node):void       {   _left = value;      }
	}
}