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
			var Vars:URLVariables = new URLVariables();
			
			Vars.type = "s";
			Vars.sid = Sid;
			Vars.channel = 0;
			Vars.from = "mainsite";
			Vars.pb = 64;
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SONG,
				Vars);
		}
	}

}