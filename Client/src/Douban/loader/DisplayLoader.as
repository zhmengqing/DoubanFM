package Douban.loader 
{
	import Douban.component.UIComponent;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class DisplayLoader extends UIComponent 
	{
		protected var FLoader:Loader;
		protected var FUrlRequest:URLRequest;
		protected var FOnComplete:Function;
		public function DisplayLoader(Parent:UIComponent) 
		{
			super(Parent);
			FLoader = new Loader();
			FUrlRequest = new URLRequest();
			
			addChild(FLoader);
			FLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, OnLoadComplete);
		}
		
		private function OnLoadComplete(e:Event):void 
		{
			if (FOnComplete != null)
			{
				FOnComplete(
					e.currentTarget.loader as Loader);
			}
		}
		
		public function Load(Url:String):void
		{
			FUrlRequest.url = Url;
			FLoader.load(FUrlRequest);
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