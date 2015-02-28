package 
{
	import Douban.component.UIComponent;
	import Douban.component.UIRoot;
	import Douban.consts.CONST_SONGINFO;
	import Douban.DoubanLogin;
	import Douban.module.ProcessorDoubanModule;
	import Douban.module.ProcessorDoubanModule;
	import Douban.utils.TMD5;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author xueling
	 */
	[SWF(backgroundColor = 0xFFFFFF, height = 250, width = 520, frameRate = 30)] 
	public class Main extends Sprite 
	{
		protected var FUIRoot:UIRoot;
		protected var FDouban:ProcessorDoubanModule;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			FUIRoot = new UIRoot(stage);
			
			FDouban = new ProcessorDoubanModule(FUIRoot);
			this.addChild(FDouban);
			
			//var aa:String = "http://douban.fm/j/mine/playlist?type=s&sid=1520783&pt=3.7&channel=2046272&pb=64&from=mainsite";
			//trace(TMD5.Hash(aa + CONST_SONGINFO.MD5_KEY).substr( -10));//这个值应为8b1c3f79c4
		}
		
		private function OnEnterFrame(e:Event):void 
		{
			FDouban.Update();
		}
		
	}
	
}