package
{
	import com.voidelement.images.BMPDecoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	/**
	 * @author 신동환
	 * @brief 지정된 디렉토리내에 있는 이미지를 읽어오는 클래스.
	 */
	public class ImageLoad
	{
		private var _loadedImg:Image;
		private var _pathArray:Array = new Array();
		private var _pathArrayBmp:Array = new Array();
		private var _loader:Loader = new Loader();
		private var _urlLoader:URLLoader = new URLLoader();
		private var _imgLoadIdx:int = 0;
		private var _imgLoadIdxBmp:int = 0;
		
		public function ImageLoad()
		{
		}
		
		/**
		 * @brief resource/in 디렉토리에 있는 .png, .jpg, .bmp 파일을 읽어오게 하는 함수
		 *        resource/in 경로설정과 이미지 파일 확인을 위한 imgPathSearch() 함수 사용
		 *        imgPathSearch를 통해 얻은 경로들을 이용하여 imgLoading()에서 이미지 읽으와서 addChild 함.
		 */		
		public function imageLoad():void
		{
			_imgLoadIdx = 0;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);	
			
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			
			imgPathSearch();
			imgLoading();
		}
		
		/**
		 * @brief resource/in 경로설정을 하고 디렉토리내의 파일의 이름을 알아낸 뒤
		 *        이미지 파일인지 확인하여 이미지일경우 _pathArray에 집어넣음
		 */		
		private function imgPathSearch():void
		{
			var desktop:File = File.applicationDirectory.resolvePath("resource/in");
			var getfiles:Array = desktop.getDirectoryListing();
			
			for (var i:int = 0; i < getfiles.length; i++) 
			{ 	 			  
				if(getfiles[i].url.search(GlobalData.FILENAME_EXTENSION_PNG) == (getfiles[i].url.length-4)) 
				{
					_pathArray.push(new URLRequest(getfiles[i].url));
				}
				else if(getfiles[i].url.search(GlobalData.FILENAME_EXTENSION_JPG) == (getfiles[i].url.length-4))
				{
					_pathArray.push(new URLRequest(getfiles[i].url));
				}
				else if(getfiles[i].url.search(GlobalData.FILENAME_EXTENSION_BMP) == (getfiles[i].url.length-4))
				{ 
					_pathArrayBmp.push(new URLRequest(getfiles[i].url));
				}
			}
		}
		
		/**
		 * @brief loader를 통해 이미지를 읽어옴
		 */		
		private function imgLoading():void
		{	
			if(_pathArray.length) _loader.load(_pathArray[_imgLoadIdx]);
		}
		
		/**
		 * @param e : loader의 이벤트
		 * @brief 개별 이미지 로딩이 끝났을때 호출. 읽어온 데이터는 array에 push함.
		 *        _pathArray에 해당되는 경로의 png,jpg 이미지들을 다 읽으면 BMP파일을 읽기 위해 loadBMPFile 함수를 호출하고,
		 *        아직 읽어야할 png,jpg 이미지가 있을 경우 다음 이미지를 읽기 위해 imgLoading 함수 호출.
		 */		
		private function loaderCompleteHandler(e:Event):void 
		{		
			_loadedImg = new Image;
			_loadedImg._img = e.target.content;
			GlobalData.imgVector.push(_loadedImg);
			
			if(_imgLoadIdx == _pathArray.length-1) loadBMPFile();

			else
			{
				_imgLoadIdx++;
				imgLoading();
			}
		}
		
		/**
		 * @param e : loader의 이벤트
		 * @brief 이미지 로딩이 실패할 경우 이벤트 리스너를 remove 함.
		 */		
		private function loaderErrorHandler(e:IOErrorEvent):void {
			trace("Error loading image! Here's the error:\n" + e);
			clearListeners();
		}
		
		/**
		 * @brief 이벤트리스너 remove
		 */		
		private function clearListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
			_urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);
		}
		
		/**
		 * @brief BMP파일을 urlLoader를 사용해서 읽어옴.
		 */
		private function loadBMPFile():void 
		{
			if(_pathArrayBmp.length) _urlLoader.load(_pathArrayBmp[_imgLoadIdxBmp]);
		}

		/**
		 * @brief BMP파일을 다읽었을 경우 호출됨.
		 *        읽은 BMP파일을 Bitmap에 맞게끔 변환을 해서 이미지 벡터에 push함.
		 *        모든 BMP파일을 읽었을 경우 이미지를 한장으로 만들기 위해 imgPacking 호출
		 *        아직 BMP파일이 남았을 경우 loadBMPFile을 호출해서 다음 파일을 읽음.
		 */
		private function urlLoaderCompleteHandler( e:Event ):void 
		{
			var loader:URLLoader = e.target as URLLoader;
			var decoder:BMPDecoder = new BMPDecoder();
			var bd:BitmapData = decoder.decode( loader.data );
			_loadedImg = new Image;
			_loadedImg._img = new Bitmap(bd,"auto",true);
			GlobalData.imgVector.push(_loadedImg);
			
			if(_imgLoadIdxBmp == _pathArrayBmp.length-1)
			{
				clearListeners();
				GlobalData.imagePacking.imgPacking();
			}
				
			else
			{
				_imgLoadIdxBmp++;
				loadBMPFile();
			}
		}

	}
}