package Douban.module.hall 
{
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.consts.CONST_SERVERID;
	import Douban.manager.DomainManager;
	import Douban.manager.SServerManager;
	import flash.display.Sprite;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorHallView extends UIComponent 
	{
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		
		public function ProcessorHallView(
			Parent:UIComponent) 
		{
			super(Parent);
			
		}
		
		public function InitView():void
		{
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Login) as Sprite;
				
			this.addChild(FMainUI);
			
			FMountPoint = FMainUI["MC_MountPoint"];
		}
		
		public function NextSong(
			Sid:String = ""):void
		{
			var Url:String = "http://douban.fm/j/mine/playlist?type=n&sid=289954&pt=2.3&channel=-3&pb=64&from=mainsite&r=a0bdc8eb6a";
			var Vars:URLVariables = new URLVariables();
			
			Vars.type = "n";
			Vars.sid = 289954;
			Vars.pt = 2.3;
			Vars.channel = -3;
			Vars.pb = 64;
			Vars.from = "mainsite";
			Vars.r = "a0bdc8eb6a";
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SONG,
				Vars);
		}
	}

}