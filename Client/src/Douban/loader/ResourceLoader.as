package Douban.loader 
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ResourceLoader extends Loader 
	{
		protected var FUrlRequest:URLRequest;
		
		protected var FOnComplete:Function;
		protected var FOnError:Function;
		
		public function ResourceLoader() 
		{
			super();
			FUrlRequest = new URLRequest();
			
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, OnLoadError);
		}	
		
		public function loadResource(
			Url:String,
			LoadContext:LoaderContext):void 
		{
			FUrlRequest.url = Url;
			load(
				FUrlRequest,
				LoadContext);			
		}
		
		private function OnLoadError(e:IOErrorEvent):void 
		{
			if (FOnError != null)
			{
				FOnError(e);
			}
		}
		
		private function OnLoadComplete(e:Event):void 
		{
			if (FOnComplete != null)
			{
				FOnComplete(
					e.target.loader as Loader);
			}
		}
		
		public function get OnComplete():Function 
		{
			return FOnComplete;
		}
		
		public function set OnComplete(value:Function):void 
		{
			FOnComplete = value;
		}
		
		public function get OnError():Function 
		{
			return FOnError;
		}
		
		public function set OnError(value:Function):void 
		{
			FOnError = value;
		}
		
	}

}