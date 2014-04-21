package
{
	public class Node
	{
		private var left:Node;
		private var right:Node;
		private var rect:Rect;
		private var filled:Boolean;
	
		public function Node()
		{
		}
		
		public function Insert_Rect(rc:Rect):Node
		{
			if(this.left != null) return this.left.Insert_Rect(rc) || this.right.Insert_Rect(rc);
			
			if(filled) return null;
			
			if(rc.isSameSize(this.rect))
			{
				filled = true;
				return this;
			}
			
			if(rc.isTooBig(this.rect)) return null;
			
			left = new Node();
			right = new Node();
			
			var dw:int = this.rect.width - rc.width;
			var dh:int = this.rect.height - rc.height;       
	
			if(dw > dh)
			{
				this.left.rect = new Rect(this.rect.x, this.rect.y, rc.width, this.rect.height);
				this.right.rect = new Rect(this.rect.x + rc.width, this.rect.y,dw, this.rect.height);
			}
			
			else 
			{
				this.left.rect = new Rect(this.rect.x, this.rect.y, this.rect.width, rc.height);
				this.right.rect = new Rect(this.rect.x, this.rect.y + rc.height, this.rect.width, dh);
			}        
			
			return this.left.Insert_Rect(rc); 
		}
	}
}