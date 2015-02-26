package Douban.module.hall 
{
	import Douban.component.*;
	import Douban.consts.*;
	import Douban.logics.song.*;
	import Douban.logics.song.VO.SongVO;
	import Douban.manager.*;
	import Douban.manager.singelar.*;
	import Douban.manager.statics.*;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.*;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zhmq
	 */
	public class ProcessorHallView extends UIComponent 
	{
		//音乐进度条
		protected static const Bar_Song:int = 1;
		//加载进度条
		protected static const Bar_Load:int = 0;
		
		protected var FMainUI:Sprite;
		protected var FMountPoint:Sprite;
		protected var FBtnNext:UIButtton;
		protected var FBarSong:UIBar;
		protected var FTFCurTime:TextField;
		protected var FTFTotalTime:TextField;
		protected var FIsInit:Boolean;
		protected var FUnstreamizerSong:UnstreamizerSong;
		protected var FSongData:SongDatas;
		protected var FCurSong:SongVO;
		protected var FSongManager:SongConnection;
		protected var FDuration:Number;
		
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
			
			FBarSong = new UIBar(CONST_HALL.BAR_NUM);
			FBarSong.OnOver = OnSongBarOver;
			FBarSong.OnOut = OnSongBarOut;
			FBarSong.OnClick = OnSongBarClick;
			FBarSong.Substrate = FMainUI["MC_SongBar"];
			
			FTFCurTime = FMainUI["TF_CurTime"];
			FTFCurTime.text = "";
			FTFCurTime.visible = false;
			FTFTotalTime = FMainUI["TF_TotalTime"];
			FTFTotalTime.text = "";
			
			FSongManager = new SongConnection();
			FSongManager.OnMetaData = OnMetaData;
			
			FUnstreamizerSong = new UnstreamizerSong();
			FSongData = new SongDatas();
		}
		
		private function OnSongBarClick(
			Sender:Object,
			E:MouseEvent):void 
		{
			
		}
		
		private function OnSongBarOut(
			Sender:Object,
			E:MouseEvent):void 
		{
			FTFCurTime.visible = false;
		}
		
		private function OnSongBarOver(
			Sender:Object,
			E:MouseEvent):void 
		{
			var Bar:UIBar;
			
			Bar = Sender as UIBar;
			FTFCurTime.visible = true;
			FTFCurTime.text = CommonManager.GetTimeStrBySeconds(
				FDuration * Bar.BarScale);
			FTFCurTime.x = mouseX - FTFCurTime.width / 2;
		}
		
		private function OnMetaData(Info:Object):void 
		{
			FDuration = Info.duration;
			FTFTotalTime.text = CommonManager.GetTimeStrBySeconds(
				FDuration);
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
			FSongManager.Load(
				FCurSong.SongUrl,
				NextSong);
		}
		
		override public function Update():void 
		{
			var Stream:NetStream;
			
			super.Update();
			
			if (FSongManager == null) return;
			
			Stream = FSongManager.Stream;
			
			if (Stream == null) return;
			
			if (Stream.bytesLoaded != Stream.bytesTotal)
			{
				FBarSong.SetBar(
					Stream.bytesLoaded/Stream.bytesTotal)
			}
			if (Stream.time != FDuration)
			{
				FBarSong.SetBar(
					Stream.time / FDuration,
					Bar_Song)
			}
			
		}
		
	}

}