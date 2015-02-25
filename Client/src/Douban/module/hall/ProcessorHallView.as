package Douban.module.hall 
{
	import Douban.component.UIBar;
	import Douban.component.UIButtton;
	import Douban.component.UIComponent;
	import Douban.consts.CONST_RESOURCE;
	import Douban.consts.CONST_SERVERID;
	import Douban.logics.song.SongDatas;
	import Douban.logics.song.UnstreamizerSong;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.DomainManager;
	import Douban.manager.SServerManager;
	import Douban.manager.SSongManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorHallView extends UIComponent 
	{
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		protected var FBtnNext:UIButtton;
		protected var FBarSong:UIBar;
		protected var FIsInit:Boolean;
		protected var FUnstreamizerSong:UnstreamizerSong;
		protected var FSongData:SongDatas;
		protected var FCurSong:SongVO;
		
		public function ProcessorHallView(
			Parent:UIComponent) 
		{
			super(Parent);
			
		}
		
		public function InitView():void
		{
			if (FIsInit)
			{
				return;
			}
			FIsInit = true;
			FMainUI = DomainManager.CreateDisplayByName(
				CONST_RESOURCE.RESOURCE_VIEW_Hall) as Sprite;
				
			this.addChild(FMainUI);
			
			FMountPoint = FMainUI["MC_MountPoint"];
			
			FBtnNext = new UIButtton();
			FBtnNext.Substrate = FMainUI["Btn_Next"];
			FBtnNext.OnClick = OnNextSong;
			
			FBarSong = new UIBar();
			FBarSong.Substrate = FMainUI["MC_SongBar"];
			
			FUnstreamizerSong = new UnstreamizerSong();
			FSongData = new SongDatas();
		}
		
		private function OnNextSong(
			Sender:Object,
			E:MouseEvent):void 
		{
			NextSong();
		}
		
		public function SetData(SongObj:Object):void
		{
			FUnstreamizerSong.UnstreamizerPerform(
				FSongData,
				SongObj);
		}
		
		public function NextSong(
			Sid:String = ""):void
		{
			var Url:String = "http://douban.fm/j/mine/playlist?type=n&sid=289954&pt=2.3&channel=-3&pb=64&from=mainsite&r=a0bdc8eb6a";
			var Vars:URLVariables = new URLVariables();
			//return;
			Vars.type = "n";
			Vars.sid = "289954";
			Vars.pt = "2.3";
			Vars.channel = "-3";
			Vars.pb = "64";
			Vars.from = "mainsite";
			Vars.r = "a0bdc8eb6a";
			SServerManager.Load(
				CONST_SERVERID.SERVERID_SONG,
				Vars);
		}
		
		public function LoadSong():void
		{
			var Radom:int;
			
			Radom = FSongData.Count * Math.random();
			FCurSong = FSongData.GetSongByIndex(Radom);
			SSongManager.Load(
				FCurSong.SongUrl,
				NextSong);
		}
		
	}

}