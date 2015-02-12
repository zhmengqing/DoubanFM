package 
{
	import Douban.component.UIComponent;
	import Douban.component.UIRoot;
	import Douban.DoubanLogin;
	import Douban.module.login.ProcessorDobanLogin;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author xueling
	 */
	public class Main extends Sprite 
	{
		protected var FUIRoot:UIRoot;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			FUIRoot = new UIRoot(stage);
			// entry point
			var Douban:ProcessorDobanLogin = new ProcessorDobanLogin(FUIRoot);
			this.addChild(Douban);
		}
		
	}
	
}