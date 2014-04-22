package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class XMLPrint
	{
		private var _xml:XML = new XML;
		
		public function XMLPrint()
		{
			_xml = 
				<root>
				</root>;
		}
		
		public function inputData():void
		{
			for(var i:int=0; i<GlobalData.imgVector.length; i++)
			{
				var newItem:XML =
					<img>
					<name></name>
					<x></x>
					<y></y>
					<width></width>
					<height></height>
					<rotated></rotated>
					</img>;
				
				newItem.name    = GlobalData.imgVector[i]._name;
				newItem.x       = GlobalData.imgVector[i]._img.x;
				newItem.y       = GlobalData.imgVector[i]._img.y;
				newItem.width   = GlobalData.imgVector[i]._img.width;
				newItem.height  = GlobalData.imgVector[i]._img.height;
				newItem.rotated = GlobalData.imgVector[i]._rotate;
				
				_xml.appendChild(newItem);
				newItem = null;
			}
		}
		
		public function print():void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(_xml);
			var file:File = File.desktopDirectory.resolvePath(GlobalData.PATH_OUT_FILE_XML);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(ba.toString());
			fileStream.close();
			
			ba.clear();
			ba = null;
			fileStream = null;
		}
	}
}