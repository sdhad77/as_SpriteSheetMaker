package
{
	import com.adobe.images.PNGEncoder;
	import com.voidelement.images.BMPDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * 이미지로딩, 이미지패킹, 이미지출력 등 이미지와 관련된 모든 처리를 하는 클래스.
	 * @author 신동환
	 */
	public class ImageProcessing
	{
		private var imgVector:Vector.<Image>;   //읽어온 이미지들을 저장하기 위한 벡터
		
		//이미지 로딩 관련
		private var _loadedImg      :Image;     //파일에서 읽어온 이미지 저장
		private var _pathArray      :Array;     //png,jpg,bmp파일 경로 저장
		private var _loader         :Loader;    //png,jpg 로더
		private var _urlLoader      :URLLoader; //bmp 로더
		private var _imgLoadIdx     :int;       //_pathArray의 인덱스
		private var _bmpDecoder     :BMPDecoder;//bmp파일을 읽기 위한 디코더
		
		//이미지 출력 관련
		private var _xml            :XML;
		
		public function ImageProcessing()
		{
			init();
		}
		
		/**
		 *초기화 하는 함수.
		 */
		private function init():void
		{
			imgVector = new Vector.<Image>();
			
			_pathArray = new Array();
			_loader    = new Loader();
			_urlLoader = new URLLoader();
			_imgLoadIdx = 0;
			_bmpDecoder = new BMPDecoder();
			
			_xml       = new XML;

			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);	
			
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}
		
		//==============================================================================================
		//===================================↓이미지 로딩 관련 기능들============================================		
		
		/**
		 * 디렉토리에 있는 png, jpg, bmp 파일의 이름을 Array에 저장하고, 이 Array를 이용하여 이미지를 읽어옴.
		 */		
		public function imageLoad():void
		{
			//경로 탐색
			imgPathSearch(); 
			
			//찾은 경로를 기반으로 이미지 로딩
			imgLoading();
		}
		
		/**
		 * resource/in 경로설정을 하고 디렉토리내의 파일의 이름을 알아낸 뒤 이미지 파일인지 확인하여 이미지일경우 _pathArray에 집어넣음.
		 */		
		private function imgPathSearch():void
		{
			var fileDirectory:File = File.applicationDirectory.resolvePath(GlobalData.PATH_IN_FILE);
			var getfiles:Array = fileDirectory.getDirectoryListing();
			
			var fileExtension:String;
			
			for (var i:int = 0; i < getfiles.length; i++) 
			{
				//파일 확장자만 자르기
				fileExtension = getfiles[i].url.substring(getfiles[i].url.lastIndexOf("."));
				
				//확장자 비교. png,bmp,jpg이면 push함.
				if((fileExtension == GlobalData.FILENAME_EXTENSION_PNG)
					|| (fileExtension == GlobalData.FILENAME_EXTENSION_JPG)
					|| (fileExtension == GlobalData.FILENAME_EXTENSION_BMP))
				{
					_pathArray.push(getfiles[i]);
				}
				
				fileExtension = null;
			}
			
			fileDirectory = null;
			getfiles = null;
		}
		
		/**
		 * png,jpg -> loader,   bmp -> urlloader 사용하여 이미지를 읽어옴.
		 */		
		private function imgLoading():void
		{	
			//파일 확장자 자르기
			var fileExtension:String = _pathArray[_imgLoadIdx].url.substring(_pathArray[_imgLoadIdx].url.lastIndexOf("."));
			
			if(_pathArray.length)
			{
				//bmp는 urlLoader 사용,    jpg,png는 loader 사용.
				if(GlobalData.FILENAME_EXTENSION_BMP == fileExtension) _urlLoader.load(new URLRequest(_pathArray[_imgLoadIdx].url));
				else _loader.load(new URLRequest(_pathArray[_imgLoadIdx].url));
			}
		}
		
		/**
		 * png,jpg 파일 하나의 로딩이 끝날때마다 호출되는 함수. 이미지 벡터에 읽어온 데이터를 push함.
		 * @param e : loader의 이벤트
		 */		
		private function loaderCompleteHandler(e:Event):void 
		{
			//Image 객체에 필요한 정보들을 _loadedImg에 저장 후 push.
			_loadedImg = new Image;
			_loadedImg.img = e.target.content;
			_loadedImg.name = _pathArray[_imgLoadIdx].url.substring(_pathArray[_imgLoadIdx].url.lastIndexOf("/") + 1);
			_loadedImg.size = _loadedImg.img.width * _loadedImg.img.height;
			imgVector.push(_loadedImg);
			
			//모든 이미지 파일을 읽고 push 했을 경우 패킹 작업 실시.
			if(_imgLoadIdx == _pathArray.length-1)
			{
				clearImageLoad();
				
				imgPack();
			}
			//아직 읽을 파일이 남아있을 경우 다시 파일 로딩 실시.
			else
			{
				_imgLoadIdx++;
				imgLoading();
			}
		}
		
		/**
		 * bmp 파일 하나의 로딩이 끝날때마다 호출되는 함수. 이미지 벡터에 읽어온 데이터를 push함.
		 * @param e : urlLoader의 이벤트
		 */
		private function urlLoaderCompleteHandler( e:Event ):void 
		{
			//읽어온 파일을 BitmapData로 convert 해줌.
			var loader:URLLoader = e.target as URLLoader;
			var decoder:BMPDecoder = new BMPDecoder();
			var bd:BitmapData = decoder.decode( loader.data );
			
			//Image 객체에 필요한 정보들을 _loadedImg에 저장 후 push.
			_loadedImg = new Image;
			_loadedImg.img = new Bitmap(bd,GlobalData.BITMAP_PIXEL_SNAPPING_AUTO,true);
			_loadedImg.name = _pathArray[_imgLoadIdx].url.substring(_pathArray[_imgLoadIdx].url.lastIndexOf("/") + 1);
			_loadedImg.size = _loadedImg.img.width * _loadedImg.img.height;
			imgVector.push(_loadedImg);
			
			//모든 이미지 파일을 읽고 push 했을 경우 패킹 작업 실시.
			if(_imgLoadIdx == _pathArray.length-1)
			{
				loader = null;
				decoder = null;
				bd.dispose();
				bd = null;
				
				//이미지 로드에서 사용했던 객체들 해제
				clearImageLoad();

				//이미지 패킹 시작
				imgPack();
			}
			//아직 읽을 파일이 남아있을 경우 다시 파일 로딩 실시.
			else
			{
				loader = null;
				decoder = null;

				_imgLoadIdx++;
				imgLoading();
			}
		}
		
		/**
		 * 이미지 로딩이 실패할 경우 메모리 해제.
		 * @param e : loader의 이벤트
		 */		
		private function loaderErrorHandler(e:IOErrorEvent):void
		{
			trace("Error loading image! Here's the error:\n" + e);
			clearImageLoad();
		}
		
		/**
		 * 이미지 로드 과정에서 사용한 객체들 클리어 해줌.
		 */
		private function clearImageLoad():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			_urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			
			while(_pathArray.length) _pathArray.pop();
			
			_pathArray = null;
			_loader = null;
			_urlLoader = null;
			_bmpDecoder = null;
		}
		
		//===================================↑이미지 로딩 관련 기능들============================================
		//==============================================================================================
		//===================================↓이미지 패킹 관련 기능들============================================
		
		/**
		 * 이미지 패킹을 시작하는 함수. 패킹이 완료되면 이미지 출력 함수를 호출함
		 */
		public function imgPack():void
		{
			//이미지를 크기순으로 정렬
			imgSorting();
			
			//이미지 패킹 시작
			imgPacking();
			
			//이미지 출력
			imgPrint();
			
			//메모리 해제
			clearImagePack();
		}
		
		/**
		 * 벡터내의 이미지를 크기순으로 정렬. 크기는 width * hegiht의 곱임.
		 */
		private function imgSorting():void
		{
			imgVector.sort(imgSortingCompareFunc);
		}
		
		/**
		 * size가 더 큰 이미지가 앞쪽으로 정렬되게 함. size = width ＊ height
		 * @param x 비교할 이미지1
		 * @param y 비교할 이미지2
		 * @return 이미지2의 size - 이미지1의 size
		 */
		private function imgSortingCompareFunc(x:Image, y:Image):Number
		{
			return y.size - x.size;
		}
		
		/**
		 * 이미지 한장으로 합치는 함수.
		 */
		private function imgPacking():void
		{
			var rect:Rect;
			var node:Node;
			var packingTreeRoot:Node = new Node;
			packingTreeRoot.rect = new Rect(GlobalData.IMAGE_BORDERLINE,GlobalData.IMAGE_BORDERLINE,GlobalData.SPRITE_SHEET_MAX_WIDTH,GlobalData.SPRITE_SHEET_MAX_HEIGHT);
			
			for(var i:int = 0; i < imgVector.length; i++)
			{
				//Sheet에 추가할 이미지의 width,height 세팅
				rect = new Rect(0,0,
					imgVector[i].img.width + GlobalData.IMAGE_BORDERLINE,
					imgVector[i].img.height + GlobalData.IMAGE_BORDERLINE);   
				
				//트리 탐색과정
				node = packingTreeRoot.Insert_Rect(rect);   
				
				//이미지가 저장될 공간이 있을 경우
				if(node)
				{	
					//이미지 위치 세팅 후 addChild
					imgVector[i].img.x = node.rect.x;
					imgVector[i].img.y = node.rect.y;
					imgVector[i].setRect();
					imgVector[i].isPacked = true;
				}
					//이미지 저장할 공간이 없을 경우
				else trace("packing 실패");
			}
			
			//현재는 단순 null 처리지만, 트리 순회하여 자식들 null 시켜줘야 함.
			packingTreeRoot = null;
		}
		
		/**
		 * 이 구간에서 사용하는 객체들은 로컬로 사용하기 때문에 여기서 해제할 것이 현재로는 없음
		 */
		private function clearImagePack():void
		{
		}
		
		//===================================↑이미지 패킹 관련 기능들============================================
		//==============================================================================================
		//===================================↓이미지 출력 관련 기능들============================================		
		
		/**
		 * 합친 이미지를 png로 출력하고, xml 파일도 내보내는 함수
		 */
		public function imgPrint():void
		{
			//합친 이미지 png로 출력하고, 화면에도 보여줌
			pngPrint();
			
			//이미지 벡터에 있는 데이터들을 xml 파일에 넣어줌
			xmlInputData();
			
			//xml 파일을 출력함
			xmlPrint();
			
			//사용이 끝난 메모리 해제
			clearImagePrint();
		}
		
		/**
		 * 이미지 패킹을 통해 얻은 각 이미지들의 x,y 좌표를 기반으로 png 파일을 제작하여 출력하고, 화면에도 보여주는 함수
		 */
		private function pngPrint():void
		{
			var pngSource:BitmapData = new BitmapData (GlobalData.SPRITE_SHEET_MAX_WIDTH, GlobalData.SPRITE_SHEET_MAX_HEIGHT,true,0x00000000);
			
			//이미지 한장에 그리는 중
			for(var i:int; i<imgVector.length; i++)
			{
				if(imgVector[i].isPacked) pngSource.draw(imgVector[i].img, new Matrix(1,0,0,1,imgVector[i].img.x,imgVector[i].img.y));
			}
			
			//한장에 그린 이미지를 png로 인코딩하여 출력함.
			var ba:ByteArray = PNGEncoder.encode(pngSource);
			var file:File = File.desktopDirectory.resolvePath(GlobalData.PATH_OUT_FILE_PNG);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(ba);
			fileStream.close();
			
			//한장에 그린 이미지를 화면에도 보여줌.
			GlobalData.globalStage.addChild(new Bitmap(pngSource));
			
			fileStream = null;
			file = null;
			
			trace("출력완료");
		}
		
		/**
		 * 이미지의 각 데이터를 _xml에 기록하는 함수. 
		 */
		private function xmlInputData():void
		{
			_xml = 
				<root>
				</root>;
			
			for(var i:int=0; i<imgVector.length; i++)
			{
				if(imgVector[i].isPacked)
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
					
					newItem.name    = imgVector[i].name;
					newItem.x       = imgVector[i].img.x;
					newItem.y       = imgVector[i].img.y;
					newItem.width   = imgVector[i].img.width;
					newItem.height  = imgVector[i].img.height;
					newItem.rotated = imgVector[i].rotate;
					
					_xml.appendChild(newItem);
					newItem = null;
				}
			}
		}
		
		/**
		 * _xml에 기록된 내용을 XML파일로 내보냄.
		 */
		private function xmlPrint():void
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
		
		private function clearImagePrint():void
		{
			_xml = null;
		}
		//===================================↑이미지 출력 관련 기능들============================================
		//==============================================================================================
	}
}