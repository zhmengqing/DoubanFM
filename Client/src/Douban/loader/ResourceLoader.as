package Douban.loader 
{
	import flash.display.Loader;
	import flash.events.Event;
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
		
		public function ResourceLoader() 
		{
			super();
			FUrlRequest = new URLRequest();
			
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete)
		}	
		
		public function loadResource(
			Url:String,
			ResourceId:String = ""):void 
		{
			FUrlRequest.url = Url;
			load(FUrlRequest);			
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
		
	}

}