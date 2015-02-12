package Douban.loader 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	/**
	 * ...
	 * @author zhmq
	 */
	public class HttpLoader 
	{
		protected var FUrlLoader:URLLoader;
		protected var FUrlRequest:URLRequest;
		
		protected var FOnComplete:Function;
		
		public function HttpLoader() 
		{
			FUrlRequest = new URLRequest();
			FUrlLoader = new URLLoader();
			
			FUrlLoader.addEventListener(Event.COMPLETE, OnCompleteHandler); 
		}
		
		public function Load(
			Url:String,
			Method:String = "",
			data:* = null):void
		{
			if (Method == "")
			{
				FUrlRequest.method = URLRequestMethod.GET; 
			}
			else
			{
				FUrlRequest.method = Method; 
			}
			FUrlRequest.url = Url;
			FUrlRequest.data = data;
			FUrlLoader.load(FUrlRequest);
		}
		
		protected function OnCompleteHandler(e:Event):void
		{
			if (FOnComplete != null)
			{
				FOnComplete(e.target.data);
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
		
	}

}