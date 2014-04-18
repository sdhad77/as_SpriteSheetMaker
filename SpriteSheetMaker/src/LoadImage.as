package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	/**
	 * @author 신동환
	 * @brief 지정된 디렉토리내에 있는 이미지를 읽어오는 클래스.
	 */
	public class LoadImage
	{
		private var _loadedArray:Array = new Array();
		private var _pathArray:Array = new Array();
		private var _loader:Loader = new Loader();
		private var _imgLoadIdx:int = 0;
		
		public function LoadImage()
		{
		}
		
		/**
		 * @brief resource/in 디렉토리에 있는 .png, .jpg, .bmp 파일을 읽어오게 하는 함수
		 *        resource/in 경로설정과 이미지 파일 확인을 위한 imgPathSearch() 함수 사용
		 *        imgPathSearch를 통해 얻은 경로들을 이용하여 imgLoading()에서 이미지 읽으와서 addChild 함.
		 */		
		public function loadImage():void
		{
			_imgLoadIdx = 0;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderErrorHandler);	
			
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
					_pathArray.push(new URLRequest(getfiles[i].url))
				}
				else if(getfiles[i].url.search(GlobalData.FILENAME_EXTENSION_JPG) == (getfiles[i].url.length-4))
				{
					_pathArray.push(new URLRequest(getfiles[i].url))
					
				}
		/*		else if(getfiles[i].url.search(GlobalData.FILENAME_EXTENSION_BMP) == (getfiles[i].url.length-4))
				{
					_pathArray.push(new URLRequest(getfiles[i].url))
				}
		*/	}
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
		 *        디렉토리내의 모든 이미지 로딩이 끝났을 경우 addChild를 하고
		 *        아직 읽어야할 이미지가 있을 경우 다음 이미지를 읽기 위해 함수 호출.
		 */		
		private function loaderCompleteHandler(e:Event):void 
		{		
			_loadedArray.push(e.target.content);
			
			if(_imgLoadIdx == _pathArray.length-1)
			{    
				for(var i:uint = 0; i < _loadedArray.length; i++){
					if(i != 0) _loadedArray[i].y = _loadedArray[i-1].height + _loadedArray[i-1].y;
					GlobalData.globalStage.addChild(_loadedArray[i]);
				}    
				clearListeners();
			}
				
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
		}
	}
}